import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/full_screen_state.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';
import 'package:spin_the_wheel_app/screens/home_screen.dart';
import 'package:spin_the_wheel_app/theme/light_theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();  // Initialize window manager on desktop platforms
  }
  runApp(
    ScreenUtilInit(
      designSize: Size(1920, 1080),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => GameState(),
          ),
          ChangeNotifierProvider(
            create: (context) => FullscreenState(),
          ),
        ],
        child: SpinTheWheelApp(),
      ),
    ),
  );
}

class SpinTheWheelApp extends StatelessWidget {
  const SpinTheWheelApp({super.key});

  @override
  Widget build(BuildContext context) {

    if (Platform.isAndroid) {
      // Android Fullscreen: using SystemChrome for Android devices
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: LightTheme().themeData,
    );
  }
}
