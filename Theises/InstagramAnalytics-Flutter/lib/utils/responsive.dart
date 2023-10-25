import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformInfo {
  static String asString() {
    if (kIsWeb) {
      return "web";
    }
    if (Platform.isMacOS) {
      return "macos";
    }
    if (Platform.isFuchsia) {
      return "fuchsia";
    }
    if (Platform.isLinux) {
      return "linux";
    }
    if (Platform.isWindows) {
      return "windows";
    }
    if (Platform.isIOS) {
      return "ios";
    }
    if (Platform.isAndroid) {
      return "android";
    }
    return "unknown";
  }

  static bool isDesktopOS() {
    if (kIsWeb) {
      return false;
    }
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  }

  static bool isAppOS() {
    if (kIsWeb) {
      return false;
    }
    return Platform.isMacOS || Platform.isAndroid;
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static PlatformType getCurrentPlatformType() {
    if (kIsWeb) {
      return PlatformType.Web;
    }
    if (Platform.isMacOS) {
      return PlatformType.MacOS;
    }
    if (Platform.isFuchsia) {
      return PlatformType.Fuchsia;
    }
    if (Platform.isLinux) {
      return PlatformType.Linux;
    }
    if (Platform.isWindows) {
      return PlatformType.Windows;
    }
    if (Platform.isIOS) {
      return PlatformType.iOS;
    }
    if (Platform.isAndroid) {
      return PlatformType.Android;
    }
    return PlatformType.Unknown;
  }
}

enum PlatformType { Web, iOS, Android, MacOS, Fuchsia, Linux, Windows, Unknown }

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    Key key,
    @required this.mobile,
    this.tablet,
    @required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 1100) {
      return desktop;
    } else if (_size.width >= 850 && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
