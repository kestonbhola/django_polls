# Step 1: Use an official Python image to build the application
FROM python:3.13.3-slim as base

# Step 2: Set environment variables for Python to ensure no buffering
ENV PYTHONUNBUFFERED 1

# Step 3: Install dependencies for the project
RUN apt-get update && apt-get install -y \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Step 4: Set up the working directory inside the container
WORKDIR /app

# Step 5: Copy requirements.txt and install the dependencies
COPY requirements.txt /app/
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Step 6: Copy the entire project into the container
COPY . /app/

# Step 7: Run Django migrations and collect static files
RUN python manage.py migrate
RUN python manage.py collectstatic --noinput

# Step 8: Install Nginx and configure the static files for Nginx
FROM nginx:alpine as final

# Step 9: Copy over the necessary files
COPY --from=base /app /app
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=base /app/static /usr/share/nginx/html/

# Step 10: Expose port 80 for Nginx
EXPOSE 80

# Step 11: Set the command to run Gunicorn and Nginx
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:80 myproject.wsgi:application & nginx -g 'daemon off;'"]