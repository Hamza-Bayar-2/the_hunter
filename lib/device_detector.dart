import 'package:flutter/foundation.dart';

class DeviceDetector {
  DeviceDetector();
  bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;
  bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
  bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;
  bool get isWeb => kIsWeb;
  bool get isDesktop => isWindows || isMacOS || isLinux;
  bool get isMobile => isAndroid || isIOS;
  bool get isDesktopWeb => isDesktop && isWeb;
  bool get isMobileWeb => isMobile && isWeb;
}
