FROM n8nio/n8n:latest

USER root

# Set working directory
WORKDIR /home/node

# Expose n8n port
EXPOSE 5678

# Switch back to node user
USER node

# Start n8n
CMD ["n8n"]
