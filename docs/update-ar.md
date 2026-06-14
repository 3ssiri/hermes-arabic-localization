# تحديث التعريب مع تحديثات Hermes

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

إذا كنت تطور التعريب:

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent
git fetch origin main
git switch arabic-localization-pr
git rebase origin/main
git format-patch --stdout origin/main..HEAD > ..\hermes-arabic-localization\patches\desktop-arabic-localization.patch
```
