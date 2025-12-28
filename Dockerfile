# Stage 1: build
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build || echo "no build step"

# Stage 2: runtime
FROM node:20-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=build /app ./
USER appuser
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "app/server.js"]
