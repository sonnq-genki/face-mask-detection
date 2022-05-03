// ignore_for_file: avoid_print

import 'dart:async';
import 'package:face_mask_detection/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    throw CameraException('-1', 'Load camera failed: ${e.toString()}');
  }
  await loadModel();
  runApp(const FaceMaskDetectionApp());
}

Future<void> loadModel() async {
  Tflite.close();
  try {
    final res = await Tflite.loadModel(
        model: 'assets/yolov5.tflite', labels: 'assets/yolov5.txt');
    print("Load model: ${res.toString()}");
  } on PlatformException catch (e) {
    throw Exception("Failed to load model: ${e.toString()}");
  }
}

class FaceMaskDetectionApp extends StatelessWidget {
  const FaceMaskDetectionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}
