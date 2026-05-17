# ระบบตารางเรียนการสอน

เว็บตัวอย่างสำหรับจัดการตารางเรียนหลักสูตรทหาร มีหน้า Login, Dashboard, ข้อมูลพื้นฐาน, ทะเบียนคุมหลักสูตร/วิชา/อาจารย์ และตารางเรียนแบบเพิ่ม แก้ไข ลบ ค้นหาได้

## วิธีเปิดใช้งานในเครื่อง

เปิดไฟล์ `index.html` ด้วยเบราว์เซอร์ได้ทันที

บัญชีทดลอง:

- ชื่อผู้ใช้: `admin`
- รหัสผ่าน: `1234`

ข้อมูลระหว่างทดลองจะเก็บใน LocalStorage ของเบราว์เซอร์

## โครงสร้างไฟล์

- `index.html` หน้าเว็บหลัก
- `styles.css` รูปแบบหน้าจอ
- `app.js` ระบบ CRUD และข้อมูลตัวอย่าง
- `database.sql` โครงสร้างฐานข้อมูล PostgreSQL สำหรับ Supabase หรือ Neon

## Export ตารางเรียน

ในหน้า `ตารางเรียน` สามารถเลือกส่งออกข้อมูลได้ 2 ช่วงเวลา:

- รายสัปดาห์
- รายเดือน

และเลือกชนิดไฟล์ได้ 2 แบบ:

- Excel (`.xls`)
- PDF ผ่านหน้าพิมพ์ของเบราว์เซอร์

การกรองสัปดาห์/เดือนจะอ้างอิงช่อง `วันที่จริง` ของแต่ละรายการตารางเรียน

## ฐานข้อมูลฟรีที่แนะนำ

แนะนำ Supabase สำหรับเริ่มต้น เพราะมี PostgreSQL ฟรีและมีระบบ Login พร้อมในตัว

ขั้นตอนย้ายไปฐานข้อมูลจริง:

1. สมัคร Supabase และสร้าง Project ใหม่
2. เปิด SQL Editor
3. วางคำสั่งจาก `database.sql` แล้ว Run
4. เปิด Table Editor เพื่อตรวจตาราง `courses`, `subjects`, `teachers`, `schedules`
5. เชื่อมหน้าเว็บกับ Supabase JavaScript SDK ใน `app.js`

## การนำขึ้น GitHub Pages

ถ้ามี Git ติดตั้งแล้ว ให้ใช้คำสั่ง:

```powershell
git init
git add .
git commit -m "Create timetable web app"
git branch -M main
git remote add origin https://github.com/Ncsc8650/Timetable.git
git push -u origin main
```

จากนั้นเปิด GitHub repository > Settings > Pages แล้วเลือก Deploy from branch `main`
