import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

Future<void> toggleFullScreen(
    Function(bool) setFullScreenState,
    bool isFullScreen,
    ) async {
  try {
    if (Platform.isWindows) {
      // Windows-specific full-screen logic
      if (isFullScreen) {
        await windowManager.setFullScreen(false);
      } else {
        await windowManager.setFullScreen(true);
      }
      setFullScreenState(!isFullScreen);
    } else if (Platform.isAndroid) {
      // Android-specific full-screen logic
      if (isFullScreen) {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } else {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
      setFullScreenState(!isFullScreen);
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error toggling full screen: $e");
    }
  }
}
