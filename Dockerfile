# Container image that runs your code
FROM python:3.11-slim-bullseye

# Copies your code file from your action repository to the filesystem path `/` of the container
RUN apt-get update > /dev/null \
    && apt-get -y install curl jq bash git
RUN pip install openai
COPY *.sh /
COPY *.py /
RUN chmod +x entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
