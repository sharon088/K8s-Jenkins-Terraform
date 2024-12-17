# Flask App with Multi-Stage Dockerfile

This project is a simple **Flask** web application packaged in a **Docker** container using a **multi-stage Dockerfile**. The multi-stage build process helps optimize the image size and ensures that only the required runtime dependencies are included in the final image.

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Build the Docker Image](#2-build-the-docker-image)
  - [3. Run the Docker Container](#3-run-the-docker-container)
- [Development](#development)
  - [1. Updating the Application](#1-updating-the-application)
  - [2. Rebuilding the Docker Image](#2-rebuilding-the-docker-image)

---

## Project Overview

This is a simple Flask application that displays a "Hello World" page. The project uses a multi-stage Dockerfile to separate the build process from the final runtime environment, ensuring that the final image is optimized for production.

The app uses the following technologies:
- **Flask**: A lightweight web framework for Python.
- **Docker**: Used for containerizing the application.
- **Python**: The backend language for the application.

---

## Prerequisites

Before you start, ensure that you have the following installed:
- [Docker](https://www.docker.com/products/docker-desktop)
- [Python 3.10](https://www.python.org/downloads/)

---

## Installation

### 1. Clone the Repository

Start by cloning this repository to your local machine:

```bash
git clone https://github.com/yourusername/flask-app.git
cd flask-app
```

### 2. Build the Docker Image

In the root of the project directory, you can build the Docker image using the following command:

```bash
docker build -t flask-app .
```

This command will trigger the multi-stage Docker build process. It will install the required dependencies and package the app into a lightweight Docker image.

### 3. Run the Docker Container

Once the image is built, run the container:

```bash
docker run -p 5000:5000 flask-app
```

This will start the Flask app inside a Docker container and expose it on port 5000.

You can now access the Flask app by navigating to [http://127.0.0.1:5000](http://127.0.0.1:5000) in your web browser.

---

## Development

### 1. Updating the Application

To make changes to the application:

1. Edit the `app.py` or the HTML template in the `templates` folder (if any).
2. Update any other files as necessary (e.g., `requirements.txt` for dependencies).

### 2. Rebuilding the Docker Image

After making changes, you’ll need to rebuild the Docker image to see the updates:

```bash
docker build -t flask-app .
```

Then, stop and remove the previous container if it’s still running:

```bash
docker ps  # to list containers
docker stop <container_id>
docker rm <container_id>
```

Finally, restart the container:

```bash
docker run -p 5000:5000 flask-app
```
