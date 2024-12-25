# Stage 1: Build Stage
FROM python:3.12-slim AS build-stage

# Set working directory
WORKDIR /app

# Copy only the requirements file first to leverage Docker caching
COPY requirements.txt /app/

# Install dependencies in build stage
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Stage (Runtime Stage)
FROM python:3.12-slim AS runtime-stage

# Set working directory
WORKDIR /app

# Copy installed dependencies from the build stage
COPY --from=build-stage /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# Copy the application code to the runtime container
COPY . /app/

# Expose the port Flask will run on
EXPOSE 5000

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Command to run the application
CMD ["flask", "run"]
