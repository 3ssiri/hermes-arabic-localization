# تعريب Hermes Desktop

هذا المستودع يوفر حزمة تعريب عربية مجتمعية لواجهة Hermes Desktop.

الفكرة ليست توزيع نسخة كاملة معدلة من Hermes، بل توفير patch وسكربت يطبقه على
نسخة Hermes الموجودة لديك.

المشروع الأصلي:
https://github.com/NousResearch/hermes-agent

طلب الدمج الرسمي:
https://github.com/NousResearch/hermes-agent/pull/45619

## ماذا يشمل التعريب؟

- إضافة العربية كخيار لغة في Hermes Desktop.
- تفعيل اتجاه RTL عند اختيار العربية.
- تعريب أقسام الإعدادات.
- تعريب المزودين والحسابات.
- تعريب أدوات ومفاتيح API.
- تعريب MCP.
- تعريب المحادثات المؤرشفة.
- تعريب صفحة حول ومنطقة Danger Zone.
- اختبارات للتأكد من عمل العربية داخل i18n.

لا يغير هذا التعريب:

- منطق الوكيل.
- الـ prompt.
- أدوات النموذج.
- الخلفية أو API.
- المزودين.
- لوحة Dashboard.

## التثبيت السريع على Windows

افتح PowerShell:

```powershell
git clone https://github.com/3ssiri/hermes-arabic-localization.git
cd hermes-arabic-localization
.\scripts\apply-arabic.ps1 -Build
```

يفترض السكربت أن Hermes موجود هنا:

```text
%LOCALAPPDATA%\hermes\hermes-agent
```

إذا كان في مسار آخر:

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "C:\path\to\hermes-agent" -Build
```

## ماذا يفعل السكربت؟

1. يتأكد أن مجلد Hermes هو مستودع Git.
2. يرفض العمل إذا كانت هناك تغييرات غير محفوظة، إلا إذا استخدمت `-AllowDirty`.
3. ينشئ أو ينتقل إلى فرع `arabic-localization`.
4. يطبق ملف التعريب الموجود في `patches/`.
5. يضبط اللغة في إعدادات Hermes إلى:

```yaml
display:
  language: ar
```

6. يشغل فحص TypeScript واختبارات i18n.
7. يبني تطبيق سطح المكتب إذا استخدمت `-Build`.

## التحقق اليدوي

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent\apps\desktop
npm run typecheck
npm run test:ui -- src/i18n/runtime.test.ts src/i18n/languages.test.ts src/i18n/context.test.tsx src/components/language-switcher.test.tsx
```

## عند صدور تحديث جديد من Hermes

إذا لم يطبق patch بسبب تغييرات جديدة في Hermes:

1. حدث Hermes.
2. أعد تشغيل السكربت.
3. إذا فشل `git apply --check`، افتح issue هنا مع رقم commit ورسالة الخطأ.

## الحقوق

إعداد وصيانة تعريب Hermes Desktop:

- علي عسيري
- البريد الإلكتروني: assiri@gmail.com

يوجد عمل تعريب عربي أوسع سابق في الطلب:
NousResearch/hermes-agent#44987 بواسطة Da7-Tech.

هذا المستودع حزمة تعريب مجتمعية مستقلة، وليس إصداراً رسمياً من Hermes إلا إذا
تم دمجه في المشروع الأصلي.

تبقى حقوق Hermes Agent وترخيصه الأصلي محفوظة للمؤلفين والمساهمين الأصليين.
