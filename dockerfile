# เลือกฐานข้อมูลของภาพเริ่มต้นที่มี Node.js
FROM node:18 as builder

# ตั้งค่าโฟลเดอร์ทำงาน
WORKDIR /app

# คัดลอกไฟล์ package.json และ package-lock.json เข้าไปยังโฟลเดอร์ทำงาน
COPY package*.json ./

# ติดตั้ง dependencies โดยใช้ npm
RUN npm install

# คัดลอกโค้ด Angular app เข้าไปยังโฟลเดอร์ทำงาน
COPY . .

# สร้างและ compile Angular app สำหรับ production
RUN npm run build -- --configuration=production

# ขั้นตอนการสร้างภาพ Docker สำหรับ production
FROM nginx:alpine

# คัดลอกไฟล์ build จากภาพ builder มายังโฟลเดอร์ที่เหมาะสมใน Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# คำสั่งเริ่มต้นของ Nginx เมื่อ container ถูกเรียกใช้
CMD ["nginx", "-g", "daemon off;"]
