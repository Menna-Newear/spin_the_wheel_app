import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<void> toggleFullScreenAndroid(bool isFullScreen) async {
  if (Platform.isAndroid) {
    try {
      if (isFullScreen) {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } else {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error toggling Android full screen: $e");
      }
    }
  }
}