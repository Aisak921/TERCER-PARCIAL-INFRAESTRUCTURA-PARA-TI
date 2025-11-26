FROM node:22-alpine

WORKDIR /usr/src/app

COPY package*.json ./

# Use npm install instead of npm ci, with force flag for compatibility
RUN npm install --legacy-peer-deps

COPY . .

USER 1001

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

CMD ["npm", "start"]
