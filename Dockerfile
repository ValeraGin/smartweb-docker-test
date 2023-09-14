FROM node:18 as build

ENV DEPLOY_URL http://static.kion.ru/static-web/kion.ru/

RUN if [[ -z "$DEPLOY_URL" ]] ; then echo DEPLOY_URL not provided ; else echo DEPLOY_URL is $DEPLOY_URL ; fi

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build -- --deploy-url=$DEPLOY_URL

RUN npm run build:ssr -- --deploy-url=$DEPLOY_URL

FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/dist /app/dist

COPY --from=build /app/package.json /app/package.json

COPY --from=build /app/package-lock.json /app/package-lock.json

#RUN npm install --production

EXPOSE 4000

CMD ["npm", "run", "serve:ssr"]


