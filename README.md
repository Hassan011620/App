# NFC Pay — تطبيق الدفع اللاتلامسي

نظام دفع مغلق (Closed-Loop) باستخدام NFC للأسواق ذات البنية المصرفية الضعيفة.

---

## 🏗️ هيكل المشروع

```
lib/
├── main.dart                          # نقطة الدخول
├── core/
│   ├── theme/
│   │   ├── app_colors.dart            # نظام الألوان
│   │   ├── motion_tokens.dart         # مدة الحركات والمنحنيات
│   │   └── theme.dart                 # ThemeData الكامل
│   ├── router/
│   │   └── router.dart                # GoRouter — جميع المسارات
│   └── widgets/
│       ├── glass_card.dart            # بطاقة زجاجية (Glassmorphism)
│       ├── morphing_button.dart       # زر متحوّل (idle/loading/success/error)
│       ├── shake_widget.dart          # تأثير اهتزاز عند الخطأ
│       ├── slot_machine_counter.dart  # عداد الرصيد المتحرك
│       └── nfc_ripples_widget.dart    # حلقات NFC المتموجة + خط المسح
│
├── features/
│   ├── splash/            → SplashScreen
│   ├── onboarding/        → OnboardingScreen (3 صفحات)
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart      # مع مقياس قوة كلمة المرور
│   │   └── otp_screen.dart           # 6 خانات مع عداد تنازلي
│   ├── home/
│   │   ├── home_screen.dart          # بطاقة الرصيد + Slot Counter + Mini Chart
│   │   └── main_shell.dart           # BottomNav مع Glassmorphism
│   ├── wallet/
│   │   ├── send_screen.dart          # خطوتان: تحقق المستلم → لوحة أرقام
│   │   └── receive_screen.dart       # QR + نسخ المعرف السداسي
│   ├── nfc/
│   │   └── nfc_pay_screen.dart       # بطاقة افتراضية + تأثيرات + حالات
│   ├── cards/
│   │   └── cards_screen.dart         # مكدس البطاقات + قلب 3D
│   ├── notifications/
│   │   └── notifications_screen.dart # تجميع زمني + قراءة فردية/كل
│   └── profile/
│       └── profile_screen.dart       # إحصاءات + إعدادات منظّمة

android/
├── app/src/main/
│   ├── AndroidManifest.xml            # NFC Permissions + HCE
│   ├── kotlin/com/nfcpay/app/
│   │   ├── MainActivity.kt            # MethodChannel للـ NFC
│   │   └── NfcHceService.kt           # HCE – محاكاة بطاقة الدفع
│   └── res/xml/
│       ├── nfc_tech_filter.xml
│       ├── apdu_service.xml
│       └── network_security_config.xml
```

---

## 🚀 خطوات بناء APK

### المتطلبات
| أداة | الإصدار الأدنى |
|------|----------------|
| Flutter SDK | 3.22+ |
| Dart | 3.0+ |
| Android Studio / VS Code | أحدث إصدار |
| Java JDK | 17 |
| Android SDK | API 24+ |

### 1. تثبيت الاعتمادیات
```bash
cd nfc_pay
flutter pub get
```

### 2. إضافة ملفات الخطوط (مطلوب)
```bash
mkdir -p assets/fonts assets/images assets/icons

# نزّل Inter من fonts.google.com ثم:
cp Inter-Regular.ttf  assets/fonts/
cp Inter-Medium.ttf   assets/fonts/
cp Inter-SemiBold.ttf assets/fonts/
cp Inter-Bold.ttf     assets/fonts/
```

### 3. بناء APK للتطوير
```bash
# Debug APK
flutter build apk --debug

# Release APK (بدون توقيع)
flutter build apk --release

# App Bundle للمتجر
flutter build appbundle --release
```

### 4. تشغيل مباشر على جهاز
```bash
flutter devices          # قائمة الأجهزة
flutter run -d <id>      # تشغيل على جهاز محدد
```

### 5. توقيع للإنتاج
```bash
# إنشاء keystore
keytool -genkey -v \
  -keystore ~/nfcpay-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias nfcpay

# أضف في android/key.properties:
storePassword=<PASSWORD>
keyPassword=<PASSWORD>
keyAlias=nfcpay
storeFile=<PATH>/nfcpay-release.jks

# بناء موقّع
flutter build apk --release
```

---

## 📱 الشاشات المبنية

| الشاشة | المسار | الميزة الرئيسية |
|--------|--------|-----------------|
| Splash | `/splash` | Logo + Pulse animation |
| Onboarding | `/onboarding` | 3 صفحات + مؤشر خطي |
| تسجيل دخول | `/login` | Shake on error + Biometric btn |
| تسجيل | `/register` | Password strength meter |
| OTP | `/otp` | 6 خانات + عداد تنازلي |
| الرئيسية | `/home` | Slot counter + Mini chart |
| إرسال | `/send` | خطوتان + Numpad |
| استلام | `/receive` | QR + نسخ معرّف |
| دفع NFC | `/nfc-pay` | Ripples + Card flip + States |
| البطاقات | `/cards` | Card stack + 3D flip |
| الإشعارات | `/notifications` | تجميع زمني |
| الملف الشخصي | `/profile` | إحصاءات + إعدادات |

---

## 🔑 ميزات التصميم

- **Glassmorphism** — backdropFilter على كل البطاقات والـ BottomNav
- **Dark-only** — `#0A0A0A` خلفية، بيضاء أساسية، لا ألوان Accent
- **Motion tokens** — سرعات وحنيات موحّدة في كل المشروع
- **Slot machine counter** — رصيد يتحرك بسلاسة بين القيم
- **Morphing button** — يتحوّل بين idle → loading → success → error
- **Shake on error** — اهتزاز مرئي + haptic عند الخطأ
- **3D card flip** — قلب بطاقة بمحور Y حقيقي
- **NFC ripples** — 3 حلقات متتالية متموجة
- **Password strength** — شريط ملوّن يقيم القوة لحظياً

---

## 📝 ملاحظات للمطوّر

- التطبيق يعمل بـ **Mock data** — لا backend حقيقي
- لتفعيل NFC الحقيقي: استبدل الـ `_simulateSuccess()` في `NfcPayScreen` بـ `nfc_manager` plugin
- للـ HCE: الخدمة `NfcHceService.kt` جاهزة، احتاج فقط ربطها بـ token حقيقي
- كود OTP للتجربة: **123456**

---

## 🛡️ الأمان المطبّق

- `network_security_config.xml` يمنع cleartext traffic
- `allowBackup="false"` يمنع backup البيانات الحساسة
- `requireDeviceUnlock="true"` في HCE يستلزم فتح الشاشة للدفع
- `usesCleartextTraffic="false"` على مستوى التطبيق

---

*Built with Flutter 3.22 · Dart 3.0 · GoRouter · Riverpod · flutter_animate*
