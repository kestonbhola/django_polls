# Use an official Nginx image as base
FROM nginx:alpine

# Copy the webpage files into the container
COPY . /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
