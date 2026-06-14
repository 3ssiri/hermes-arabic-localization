# استكشاف الأخطاء

## السكربت يقول إن الشجرة غير نظيفة

الرسالة:

```text
Hermes checkout has uncommitted changes
```

الحل:

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent
git status
```

احفظ تغييراتك أو انقلها إلى branch آخر. استخدم `-AllowDirty` فقط إذا كنت تعرف
ما تفعل.

## التطبيق يفتح نسخة قديمة

أغلق كل عمليات Hermes من Task Manager، ثم شغل النسخة المبنية:

```text
%LOCALAPPDATA%\hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe
```

## العربية لا تظهر

افتح ملف الإعداد:

```text
%LOCALAPPDATA%\hermes\config.yaml
```

وتأكد من:

```yaml
display:
  language: ar
```

ثم أعد تشغيل Hermes Desktop.

## فشل npm run typecheck

نفذ:

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent
npm install
cd apps\desktop
npm run typecheck
```

## فشل البناء

أعد تشغيل PowerShell، أغلق Hermes Desktop، ثم نفذ:

```powershell
cd $env:LOCALAPPDATA\hermes\hermes-agent
.\.venv\Scripts\python.exe -m hermes_cli.main desktop --build-only --force-build
```
