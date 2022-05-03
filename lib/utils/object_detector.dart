import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class ObjectDetecter extends ValueNotifier<List> {
  ObjectDetecter._() : super([]);

  static late CameraController? _controller;
  
  static bool _isDetecting = false;
  static const platform = MethodChannel('francium.tech/tensorflow');

  static final ObjectDetecter instance = ObjectDetecter._();

  void init(CameraController controller) async {
    _controller = controller;
    _controller!.initialize().then((_) {
      _controller!.startImageStream((CameraImage image) {
        if (!_isDetecting) {
          _isDetecting = true;
          _runDetection(image);
        }
      }); 
    });
  }
  
  void _runDetection(CameraImage image) async {
    try {

      var inputImage = <String, dynamic>{};
      inputImage["planes"]= [];
      for (int i = 0; i < image.planes.length; i++) { 
        var value = {};
        value["bytes"] = image.planes[i].bytes;
        value["bytesPerRow"] = image.planes[i].bytesPerRow;
        value["bytesPerPixel"] = image.planes[i].bytesPerPixel;
        value["height"] = image.planes[i].height;
        value["width"] = image.planes[i].width;
        inputImage["planes"][i] = value;
      }
      inputImage["height"] = image.height;
      inputImage["width"] = image.width;
      inputImage["rotation"] = 90;
    
      var results = await platform.invokeMethod('detectObject', inputImage);
      value = results;
    } finally {
      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    suspend();
  }

  void suspend() {
    _controller!.dispose();
    _controller = null;
    value = [];
  }
}
