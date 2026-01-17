FROM ubuntu:latest
LABEL authors="andrea"
COPY ./falcone.sh .
COPY ./scripts ./scripts

RUN chmod +x ./falcone.sh


ENTRYPOINT ["top", "-b"]
