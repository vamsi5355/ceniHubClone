import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

class CineHubApp extends StatelessWidget {
  const CineHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Poppins'),
      home: const MainScreen(),
    );
  }
}
