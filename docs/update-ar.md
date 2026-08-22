# تحديث التعريب مع تحديثات Hermes

> [!NOTE]
> صارت العربية مدعومة أصلاً في Hermes Desktop منذ `5b6990e7a` (2026-07-24). إن كانت نسختك
> أحدث من ذلك فلا تحتاج هذا الدليل: حدّث Hermes واختر العربية من
> Settings ← Appearance ← Language. ما يلي يخص النسخ الأقدم فقط.

يتغير Hermes بسرعة، لذلك قد يحتاج ملف patch إلى تحديث عند صدور تغييرات كبيرة في
واجهة سطح المكتب.

## تحديث Hermes ثم إعادة تطبيق التعريب

داخل مجلد Hermes:

```powershell
git fetch origin main
git switch main
git pull --ff-only
```

ثم داخل مجلد التعريب:

```powershell
.\scripts\apply-arabic.ps1 -Build
```

## إذا فشل التطبيق

إذا ظهر خطأ من:

```text
git apply --check
```

فهذا يعني أن ملفات Hermes تغيرت بما يكفي ليحتاج patch إلى تحديث.

افتح issue في مستودع التعريب وارفق:

- رقم commit من Hermes:

```powershell
git -C "$env:LOCALAPPDATA\hermes\hermes-agent" rev-parse HEAD
```

- رسالة الخطأ كاملة.
- نظام التشغيل.

## تحديث patch للمساهمين

تحسينات الترجمة الجديدة تذهب مباشرة إلى [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)،
لأن ملفات العربية صارت هناك. الخطوات التالية تبقى للرجوع إليها عند العمل على patch لنسخة قديمة:

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent
git fetch origin main
git switch arabic-localization-pr
git rebase origin/main
git format-patch --stdout origin/main..HEAD > ..\hermes-arabic-localization\patches\desktop-arabic-localization.patch
```
