import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';
import 'package:spin_the_wheel_app/screens/participate_screen/participate_screen.dart';
import 'package:window_manager/window_manager.dart';
import '../providers/full_screen_state.dart';
import '../utils/background_image.dart';
import '../utils/toggle_fullscreen_android.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fullscreenState = Provider.of<FullscreenState>(context);
    final theme = Theme.of(context);
    return KeyboardListener(
      focusNode: fullscreenState.focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          fullscreenState.handleEscapeKey(event);
        }
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          fullscreenState.handleEnterKey(event);
        }

        // If the platform is Windows, Linux, or macOS, use window_manager
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          windowManager.setFullScreen(fullscreenState.isFullScreen);
        } else if (Platform.isAndroid) {
          toggleFullScreenAndroid(fullscreenState.isFullScreen);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Lucky Spin",
            style: theme.textTheme.titleLarge,
          ),
          actions: [
            IconButton(
              icon: Icon(
                fullscreenState.isFullScreen
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
                size: 25,
              ),
              onPressed: () async {
                fullscreenState.toggleFullscreen();
                if (Platform.isWindows ||
                    Platform.isLinux ||
                    Platform.isMacOS) {
                  await windowManager
                      .setFullScreen(fullscreenState.isFullScreen);
                } else if (Platform.isAndroid) {}
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: BackgroundImage(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<GameState>(context, listen: false).resetGame();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ParticipantSpinScreen()));
                },
                child: Text(
                  "Start Game",
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*class MyWindowListener extends WindowListener {
  final _HomeScreenState _state;

  MyWindowListener(this._state);

  @override
  void onWindowEvent(String eventName) async {
    if (eventName == 'maximize') {
      await toggleFullScreen(
          _state._updateFullScreenState, _state.isFullScreen);
    }
  }

  @override
  void onKeyEvent(KeyEvent event) async {
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      await toggleFullScreen(
          _state._updateFullScreenState, _state.isFullScreen);
    }
  }
}*/
