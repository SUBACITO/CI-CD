# ---------- BUILD STAGE ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy file cấu hình trước để tận dụng cache
COPY package.json package-lock.json* ./ 
# Hoặc nếu dùng yarn/pnpm thì thay bằng file lock tương ứng

RUN npm install

COPY . .

# Build Next.js
RUN npm run build


# ---------- RUNNER STAGE ----------
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# Copy các file build
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/next.config.js ./next.config.js

EXPOSE 3000

# Chạy server Next.js
CMD ["npm", "start"]
