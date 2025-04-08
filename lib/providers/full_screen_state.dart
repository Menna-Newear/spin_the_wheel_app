import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullscreenState with ChangeNotifier {
  bool _isFullScreen = false;
  final FocusNode _focusNode = FocusNode();

  bool get isFullScreen => _isFullScreen;

  FocusNode get focusNode => _focusNode;

  void toggleFullscreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  Future<void> setFullScreen(bool value) async {
    _isFullScreen = value;
    notifyListeners();
  }

  void handleEscapeKey(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _isFullScreen = false;
      notifyListeners();
    }
  }
  void handleEnterKey(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      _isFullScreen = true;
      notifyListeners();
    }
  }
    void requestFocus(BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode); // Use the context here
      });
    }
  }

