FROM mongo:4

ENV MONGO_INITDB_ROOT_USERNAME root
ENV MONGO_INITDB_ROOT_PASSWORD password
ENV MONGO_INITDB_DATABASE admin

# we take over the default & start mongo in replica set mode in a background task
ENTRYPOINT mongod --port 27018 --replSet rs0 --bind_ip 0.0.0.0 & MONGOD_PID=$!; \
# we prepare the replica set with a single node and prepare the root user config
INIT="rs.initiate({ _id: 'rs0', members: [{ _id: 0, host: 'localhost:27018' }] })"; \
ROOT="db.getUser('$MONGO_INITDB_ROOT_USERNAME') || db.createUser({ user: '$MONGO_INITDB_ROOT_USERNAME', pwd: '$MONGO_INITDB_ROOT_PASSWORD', roles: [{ role: 'root', db: 'admin' }] })"; \
ADMIN="db.getUser('admin') || db.createUser({ user: 'admin', pwd: 'password', roles: [{ role: 'userAdminAnyDatabase', db: 'admin' }] })"; \
USE_ONE="db.getSiblingDB('one').auth('admin', 'password')"; \
USER="db.getUser('user') || db.createUser({ user: 'user', pwd: 'password', roles: [{ role: 'readWrite', db: 'one' }] })"; \
until (mongo admin --port 27018 --eval "$INIT && $ROOT && $ADMIN && $USE_ONE && $USER"); do sleep 1; done; \
# we are done but we keep the container by waiting on signals from the mongo task
echo "REPLICA SET ONLINE"; wait $MONGOD_PID;
