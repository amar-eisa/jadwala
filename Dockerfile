# المرحلة 1: البناء (Build)
FROM node:20-alpine as build

# تحديد مجلد العمل
WORKDIR /app

# نسخ ملفات تعريف الحزم وتثبيتها
COPY package.json package-lock.json ./
RUN npm ci

# نسخ باقي ملفات المشروع
COPY . .

# بناء المشروع للإنتاج
RUN npm install

# المرحلة 2: التشغيل (Serve) باستخدام خادم خفيف مثل Nginx
FROM nginx:alpine

# نسخ ملفات البناء من المرحلة السابقة إلى مجلد Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# نسخ إعدادات Nginx (اختياري، لكن مفيد لتطبيقات React Router)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# فتح المنفذ 80
EXPOSE 80

# تشغيل Nginx
CMD ["nginx", "-g", "daemon off;"]