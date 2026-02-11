FROM node:22-alpine AS deps
WORKDIR /app
RUN npm i -g npm@latest
COPY package*.json ./
RUN npm ci --omit=dev
FROM node:22-alpine
WORKDIR /app
RUN addgroup -S refael_g && adduser -S refael_u -G refael_g
COPY --from=deps /app/node_modules ./node_modules
COPY . .
USER refael_u
ENV PORT=3000
EXPOSE 3000
CMD ["npm", "start"]