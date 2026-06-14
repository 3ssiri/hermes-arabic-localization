# تعريب Hermes Desktop

حزمة بسيطة لإضافة اللغة العربية إلى واجهة **Hermes Desktop**.

الفكرة: لا تحتاج إلى تنزيل نسخة كاملة معدلة من Hermes. هذا المستودع يوفر:

- ملف patch للتعريب.
- سكربت يطبقه على نسخة Hermes الموجودة لديك.
- إعداد تلقائي للغة العربية.
- أوامر تحقق للتأكد أن الواجهة لم تنكسر.

المشروع الأصلي:
https://github.com/NousResearch/hermes-agent

طلب الدمج الرسمي:
https://github.com/NousResearch/hermes-agent/pull/45619

## التثبيت السريع

افتح PowerShell ونفذ:

```powershell
git clone https://github.com/3ssiri/hermes-arabic-localization.git
cd hermes-arabic-localization
.\scripts\apply-arabic.ps1 -Build
```

بعد اكتمال البناء، شغل Hermes من:

```text
%LOCALAPPDATA%\hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe
```

## إذا كان Hermes في مسار مختلف

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "C:\path\to\hermes-agent" -Build
```

## ماذا يشمل التعريب؟

- إضافة العربية كخيار لغة.
- دعم اتجاه RTL.
- تعريب الإعدادات.
- تعريب المزودين والحسابات.
- تعريب أدوات ومفاتيح API.
- تعريب MCP.
- تعريب المحادثات المؤرشفة.
- تعريب صفحة حول.
- تعريب منطقة Danger Zone.

## ماذا لا يغير؟

هذا التعريب لا يغير:

- منطق الوكيل.
- الـ prompt.
- أدوات النموذج.
- الخلفية أو API.
- المزودين.
- لوحة Dashboard.

## ماذا يفعل السكربت؟

عند تشغيل:

```powershell
.\scripts\apply-arabic.ps1 -Build
```

يقوم بالآتي:

1. يتحقق من وجود Hermes.
2. ينشئ فرعاً باسم `arabic-localization`.
3. يطبق ملف التعريب:

```text
patches/desktop-arabic-localization.patch
```

4. يضبط اللغة العربية في إعدادات Hermes:

```yaml
display:
  language: ar
```

5. يشغل فحص TypeScript واختبارات التعريب.
6. يبني نسخة Hermes Desktop.

## التحقق اليدوي

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent\apps\desktop
npm run typecheck
npm run test:ui -- src/i18n/runtime.test.ts src/i18n/languages.test.ts src/i18n/context.test.tsx src/components/language-switcher.test.tsx
```

## ملفات مهمة

- `patches/desktop-arabic-localization.patch`: ملف التعريب.
- `scripts/apply-arabic.ps1`: تطبيق التعريب على Windows.
- `scripts/apply-arabic.sh`: تطبيق التعريب على macOS/Linux.
- `scripts/verify.ps1`: تشغيل فحوصات التعريب.
- `docs/`: شروحات إضافية.

## عند حدوث مشكلة

راجع:

```text
docs/troubleshooting-ar.md
```

إذا فشل تطبيق التعريب بعد تحديث Hermes، افتح issue وأرفق:

- نظام التشغيل.
- رقم commit من Hermes.
- رسالة الخطأ كاملة.

## الحقوق

إعداد وصيانة التعريب العربي:

- علي عسيري
- البريد الإلكتروني: assiri@gmail.com

هذا المستودع حزمة تعريب مجتمعية مستقلة، وليس إصداراً رسمياً من Hermes إلا إذا تم دمجه في المشروع الأصلي.

تبقى حقوق Hermes Agent وترخيصه الأصلي محفوظة للمؤلفين والمساهمين الأصليين.
