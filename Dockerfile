# Base image
FROM python:3.10.11-slim-buster

# Create work directory
WORKDIR /app

# Create non-root user
RUN useradd -m user

# Copy requirements file
COPY requirements.txt requirements.txt

# Install Requirements
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the app file
COPY app.py /app

# Change the owner of the app file
RUN chown -R user /app

#Run as non-root user
USER user

CMD sh -c 'python3 app.py'
