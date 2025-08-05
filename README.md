# gov_statistics_investigation_io
# TỔNG ĐIỀU TRA KINH TẾ - TÔN GIÁO TÍN NGƯỠNG

### PHIẾU THU THẬP THÔNG TIN VỀ HOẠT ĐỘNG CỦA CƠ SỞ TÔN GIÁO, TÍN NGƯỠNG

## **Usage**

1. Open the project in vscode or android studio editor or...
2. Open terminal
3. Run 
```
 
## Config and build

### Before release app

##### Change the bundle id in:

- ios/Runner/Info.plist
- android/app/build.gradle
- lib/config/constants/app_values.dart

```dart
// build apk dev 
    flutter build apk --flavor dev --dart-define "BASE_API=http://xxxxx.gso.gov.vn:2985/"
 

```
```
// build apk prod
flutter build apk --flavor prod --dart-define "BASE_API=http://api_cathe_thidiemtdtkt2026.gso.gov.vn/"
```
```
// build app bundle
flutter build appbundle --flavor prod
```

v1.0.0: Chỉ phiếu tôn giáo.