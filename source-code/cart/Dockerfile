FROM node:18-alpine AS builder
WORKDIR /opt/server
COPY package.json .
RUN npm install 
COPY server.js .
FROM node:18-alpine 
RUN addgroup -S roboshop && adduser  -S roboshop -G roboshop
WORKDIR /opt/server
COPY --from=builder /opt/server/ /opt/server
USER roboshop
EXPOSE 8080
CMD ["node", "server.js"]
