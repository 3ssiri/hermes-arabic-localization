# دليل التثبيت

## المتطلبات

- نسخة Hermes Agent محلية.
- Git.
- Node.js وnpm كما يستخدمهما Hermes Desktop.
- PowerShell على Windows.

## التثبيت المختصر

```powershell
git clone https://github.com/3ssiri/hermes-arabic-localization.git
cd hermes-arabic-localization
.\scripts\apply-arabic.ps1 -Build
```

إذا كانت نسخة Hermes في مسار مختلف:

```powershell
.\scripts\apply-arabic.ps1 -HermesPath "C:\path\to\hermes-agent" -Build
```

## بعد التثبيت

شغل Hermes Desktop من:

```text
%LOCALAPPDATA%\hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe
```

ثم افتح:

```text
Settings -> Appearance -> Language -> العربية
```

أو تأكد من وجود:

```yaml
display:
  language: ar
```

في ملف:

```text
%LOCALAPPDATA%\hermes\config.yaml
```
