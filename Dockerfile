FROM node:18.7-slim
## WORKDIR specifies the directory were the application's code will live.
WORKDIR /app
## Copying package.json file to the app directory
COPY app/package.json /app
## npm install is run to install express for the application
RUN npm install
## Copying the rest of the application to the app direcoty
COPY app/app.js /app
## Allowing inter-container communication by exposing port 3000. (optional)
EXPOSE 3030
## Start the application by calling npm start.
CMD ["npm", "start"]