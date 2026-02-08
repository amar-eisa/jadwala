# المرحلة 1: البناء (Build) باستخدام صورة Bun الرسمية
FROM oven/bun:1 as build

# تحديد مجلد العمل داخل الحاوية
WORKDIR /app

# نسخ ملفات تعريف الحزم (package.json وملف القفل الخاص بـ Bun)
COPY package.json bun.lockb ./

# تثبيت الحزم بدقة بناءً على ملف القفل (بديل npm ci)
RUN bun install --frozen-lockfile

# نسخ باقي ملفات المشروع بالكامل
COPY . .

# بناء تطبيق الويب (سينتج مجلد dist)
RUN bun run build

# المرحلة 2: التشغيل (Production) باستخدام خادم Nginx
FROM nginx:alpine

# نسخ ملفات الموقع الجاهزة من مرحلة البناء إلى مجلد Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# نسخ ملف إعدادات Nginx (تأكد من وجود هذا الملف بجانب Dockerfile)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# فتح المنفذ 80
EXPOSE 80

# تشغيل الخادم
CMD ["nginx", "-g", "daemon off;"]