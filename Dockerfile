FROM node:18 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build:ssr

FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/dist /app/dist

COPY --from=build /app/package.json /app/package.json

COPY --from=build /app/package-lock.json /app/package-lock.json

RUN npm install --production

EXPOSE 4000

CMD ["npm", "run", "serve:ssr"]


