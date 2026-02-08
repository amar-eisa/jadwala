# المرحلة 1: البناء (Build)
FROM oven/bun:1 as build

WORKDIR /app

# نسخ ملفات تعريف الحزم
COPY package.json bun.lockb ./

# تثبيت الحزم
RUN bun install --frozen-lockfile

# --- إضافة المتغيرات مباشرة هنا (الحل الجذري) ---
# استبدل القيم أدناه بالقيم الحقيقية من ملف .env الخاص بك
ENV VITE_SUPABASE_URL="https://lhilcaymbhticyafyimb.supabase.co"
ENV VITE_SUPABASE_PUBLISHABLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoaWxjYXltYmh0aWN5YWZ5aW1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzNTI4NTEsImV4cCI6MjA4NTkyODg1MX0.8RJxjC0kSbROkmcgNPzPJVR9Qv9XFolqVCbJz2ICnLQ"
# ------------------------------------------------

# نسخ باقي الملفات
COPY . .

# بناء المشروع (الآن سيجد المتغيرات أعلاه ويعمل بنجاح)
RUN bun run build

# المرحلة 2: التشغيل (Production)
FROM nginx:alpine

# نسخ الملفات المبنية
COPY --from=build /app/dist /usr/share/nginx/html

# نسخ إعدادات Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]