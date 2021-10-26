# Base
FROM node:14-alpine as build
WORKDIR /app

# Dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force

# Build
COPY . .
RUN npm run build

# Application
FROM node:14-alpine

WORKDIR /app
COPY --from=build app/package*.json ./
RUN npm install --only=production
COPY --from=build app/dist ./dist/

USER node
ENV PORT=4076
EXPOSE 4076

CMD ["node", "./dist/main.js"]