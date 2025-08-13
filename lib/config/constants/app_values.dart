class AppValues {
  AppValues._();

  static const appName = 'Tổng điều tra kinh tế tôn giáo';
  static const timeOut = 15; // 15s for limit request
  static const bundleIdAndroid =
      'gov.tongdtkt.tongiao'; // get from android/app/build.gradle
  static const bundleIdIos =
      'gov.tongdtkt.tongiao'; // get from ios/Runner/Info.plist
  static const versionApp = '1.0.0';
  static const versionDanhMuc = '1.0.0';
  static const urlStore = "";
  // border
  static const borderLv1 = 6.0;
  static const borderLv2 = 12.0;
  static const borderLv3 = 20.0;
  static const borderLv4 = 24.0;
  static const borderLv5 = 32.0;

  static const padding = 20.0;
  static const paddingBox = 15.0;
  static const marginBottomBox = 10.0;

  static const buttonHeight = 48.0;
  static const showValueMessage = false; //show value for dev test
  // individual:123456
}

const String THOI_GIAN_BAT_DAU = 'ThoiGianBD';
const String THOI_GIAN_KET_THUC = 'ThoiGianKt';
