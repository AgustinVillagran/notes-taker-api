FROM --platform=linux/amd64 node:16.14.0-alpine3.14

WORKDIR /src

COPY package.json .

RUN yarn

COPY . .

EXPOSE 3000

CMD ["yarn", "start"]