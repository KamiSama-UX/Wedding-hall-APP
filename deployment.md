============================
Wedding Halls Booking System
دليل النشر
============================

يشرح هذا الدليل كيفية تشغيل المكونات الثلاثة الرئيسية للمشروع محلياً:

1.  Backend (Node.js + Express)
2.  Python Chatbot
3.  Frontend (Static HTML + http-server)

----------------------------
1. Backend (Node.js)
----------------------------

المسار: ./backend

المتطلبات:
- Node.js (الإصدار 18 أو أعلى)
- تثبيت MySQL وتشغيله
- ملف `.env` يحتوي على بيانات اعتماد قاعدة البيانات

الإعداد:
1. افتح الطرفية وانتقل إلى مجلد backend:
   cd backend

2. تثبيت التبعيات:
   npm install
   قد يكون هناك بعض المكاتب مثل Bcrybt لا تتثبت بدون Vpn

3. أنشئ ملف `.env` بناءً على `.env.example`، وقم بتعيين:
   - DB_HOST
   - DB_USER
   - DB_PASSWORD
   - DB_NAME
   - JWT_SECRET
   - PORT (الافتراضي 5000)

4. قم بتشغيل ترحيل قاعدة البيانات أو تأكد من جاهزيتها.

بدء تشغيل الخادم:
   npm start

يعمل الخادم على: http://localhost:5000

----------------------------
2. Python Chatbot (Flask)
----------------------------

المسار: ./wedding-chatbot-env

المتطلبات:
- Python 3.9 أو أحدث
- تثبيت `pip`
- يُوصى باستخدام بيئة افتراضية

الإعداد:
1. انتقل إلى مجلد chatbot:
   cd wedding-chatbot-env

2. (اختياري) إنشاء وتفعيل البيئة الافتراضية:
   python -m venv venv
   على ويندوز: venv\Scripts\activate
   على ماك/لينكس: source venv/bin/activate

3. تثبيت التبعيات:
   pip install -r requirements.txt

بدء تشغيل chatbot:
   python app.py

يعمل الخادم على: http://localhost:6000

4.  أنشئ ملف `.env` بناءً على `.env`، وقم بتعيين:
DEEPSEEK_API_KEY=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
----------------------------
3. Frontend (ملفات ثابتة)
----------------------------

المسار: ./frontend

المتطلبات:
- `http-server` (خادم ملفات ثابتة من Node.js)

الإعداد:
1. انتقل إلى مجلد frontend:
   cd frontend

2. تثبيت http-server عالمياً (إذا لم يكن مثبتاً):
   npm install -g http-server

3. بدء تشغيل الخادم:
   http-server --index login.html -p 8080

واجهة المستخدم متاحة على:
   http://localhost:8080/login.html

----------------------------
ملاحظات هامة
----------------------------
- تأكد من عدم تعارض المنافذ (5000، 6000، 8080)
- يجب تشغيل جميع الخدمات في نفس الوقت لضمان عمل النظام كاملاً
- تم تكوين CORS على الـ backend للسماح بطلبات من الـ frontend
- يستخدم الـ frontend `fetch()` للتواصل مع كل من الـ backend والـ chatbot
- يتعامل chatbot مع استفسارات القاعات والخدمات
- يتم تخزين الـ tokens (JWT) في localStorage المتصفح
