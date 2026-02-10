FROM node:20 AS build
WORKDIR /opt/server
COPY package.json .
COPY server.js .
RUN npm install

FROM node:20.19-alpine
WORKDIR /opt/server
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop 
ENV MONGO="true" \
    REDIS_URL='redis://redis:6379' \
    MONGO_URL="mongodb://mongodb:27017/users"    
LABEL created_by="Kishore" \
      component="user" \
      project="roboshop"
EXPOSE 8080
# Copying build artifacts from build stage and also changing ownership to roboshop user. This is more efficient way than using separate RUN command for ownership change
COPY --from=build --chown=roboshop:roboshop /opt/server .
USER roboshop
# CMD providing default arguments to ENTRYPOINT - so the CMD that keeps the container running will be CMD ["node", "server.js"]
ENTRYPOINT ["node"]
CMD ["server.js"]


# FROM node:20
# WORKDIR /opt/server
# COPY package.json .
# COPY *js .
# RUN npm install
# ENV MONGO="true" \
#     REDIS_URL='redis://redis:6379' \
#     MONGO_URL="mongodb://mongodb:27017/users"
# EXPOSE 8080
# CMD ["node", "server.js"]