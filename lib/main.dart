import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:recipie_app/presentation/splash_screen.dart';

import 'dependency_injection.dart';

void main () async {
  await _loadShader();
  runApp(const RunApp());
  // DependencyInjection.init();
}

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: 'Splash Screen',
    );
  }
}



Shader? shaderProgram;
Future<void> _loadShader() async {
  try {
    final prgm = await FragmentProgram.fromAsset('assets/shaders/shader.frag');
    // Here you need to use the shader program according to your requirement
    shaderProgram = prgm.fragmentShader();
  } catch (error, stackTrace) {
    FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stackTrace));
  }
}