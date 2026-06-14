# متابعة المستودع

يحتوي المستودع على مهمتين عبر GitHub Actions لمتابعة التعريب.

## متابعة تحديثات Hermes

مهمة `Monitor upstream compatibility` تعمل كل اثنتي عشرة ساعة، ويمكن تشغيلها يدويًا من تبويب Actions.

ما تقوم به:

1. تسحب آخر نسخة من `NousResearch/hermes-agent`.
2. تقارن آخر Commit في Hermes مع `src/manifest.json`.
3. تتجاوز تثبيت الاعتماديات والاختبارات إذا لم يتغير Hermes.
4. تثبت اعتماديات واجهة سطح المكتب فقط عند ظهور تحديث جديد.
5. تطبق ملف التعريب `patches/desktop-arabic-localization.patch`.
6. تشغل فحص TypeScript واختبارات i18n الخاصة بسطح المكتب.
7. إذا نجح كل شيء وكان Hermes قد تقدم إلى Commit جديد، تحدث `src/manifest.json`.
8. إذا فشل تطبيق التعريب أو الاختبارات، تفتح أو تحدث Issue مخصص للمراجعة.

## متابعة الملاحظات والمشاكل

مهمة `Issue watch` تعمل عند فتح Issue جديد أو إعادة فتح Issue قديم.

تضيف وسم `needs-review` وتضع تعليق استلام حتى تكون البلاغات واضحة وقابلة للمتابعة.

## فحص يدوي

لتشغيل نفس المسار محليًا:

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "$env:LOCALAPPDATA\hermes\hermes-agent"
```

بعد ذلك تتم مراجعة نسخة Hermes وتحديث ملف التعريب إذا تغيرت واجهة i18n في التطبيق.
