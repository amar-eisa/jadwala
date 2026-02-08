# المرحلة 1: البناء (Build)
FROM oven/bun:1 as build

WORKDIR /app

# نسخ ملفات تعريف الحزم
COPY package.json bun.lockb ./

# --- التغيير هنا: إزالة --frozen-lockfile للسماح بالتثبيت ---
RUN bun install
# --------------------------------------------------------

# المتغيرات المباشرة (التي اتفقنا عليها لحل الشاشة البيضاء)
# استبدل القيم أدناه بروابطك الحقيقية
ENV VITE_SUPABASE_URL="https://lhilcaymbhticyafyimb.supabase.co"
ENV VITE_SUPABASE_PUBLISHABLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoaWxjYXltYmh0aWN5YWZ5aW1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzNTI4NTEsImV4cCI6MjA4NTkyODg1MX0.8RJxjC0kSbROkmcgNPzPJVR9Qv9XFolqVCbJz2ICnLQ"


# نسخ باقي الملفات
COPY . .

# بناء المشروع
RUN bun run build

# المرحلة 2: التشغيل (Production)
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]