# Use an official Python runtime as a base image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /workdir

# Copy requirements.txt to the container
COPY ./requirements.txt /workdir/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /workdir/requirements.txt

# Copy the entire app directory and other necessary files to the container
COPY ./app /workdir

# Expose a port (example: Flask web server running on port 5000)
EXPOSE 8000

# Run your Python application from the app directory
# CMD ["python", "/workdir/main.py"]
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
