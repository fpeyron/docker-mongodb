#
# MongoDB Dockerfile
#
#
# Pull base image.
FROM debian:jessie-slim

# Environment variables
ENV MONGODB_USERNAME ""
ENV MONGODB_PASSWORD ""
ENV MONGODB_DBNAME "demo"

# Install MongoDB.
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
  echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | tee /etc/apt/sources.list.d/mongodb-org.list && \
  apt-get update && \
  apt-get install -y mongodb-org netcat && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Add Initial data
#ADD initial_data /initial_data
#RUN mkdir /initial_data

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh && mkdir -p /data && touch /data/.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017

# Define mountable directories.
VOLUME ["/data"]
