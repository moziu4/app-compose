FROM natsio/nats-box:0.10.0

RUN nats context add nats --server nats:4222 --description "NATS Container" --select

RUN ln -s /usr/bin/nats /bin/nats


COPY backup.sh /bin/
