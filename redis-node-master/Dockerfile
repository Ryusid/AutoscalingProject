FROM node:latest

RUN mkdir -p /app/node_modules && chown -R node:node /app

WORKDIR /app

COPY package*.json ./

USER node 

RUN npm install --force

COPY --chown=node:node . .

EXPOSE 5400

CMD [ "node", "main.js" ]
