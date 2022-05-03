// ignore_for_file: avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:face_mask_detection/main.dart';
import 'package:tflite/tflite.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late CameraController cameraController;
  final GlobalKey _keyCameraPreview = GlobalKey();
  bool busy = false;

  Future<void> runModelOnStreamFrames(CameraImage image) async {
    final bytesList = image.planes.map((plane) {
      return plane.bytes;
    }).toList();

    var recognitions = await Tflite.runModelOnFrame(
      bytesList: bytesList, // required
      // imageHeight: image.height,
      // imageWidth: image.width,
      // imageMean: 127.5, // defaults to 127.5
      // imageStd: 127.5, // defaults to 127.5
      // rotation: 90, // defaults to 90, Android only
      // threshold: 0.1, // defaults to 0.1
      // asynch: true // defaults to true
    );
    print('dit con di me may');
    print(recognitions);
  }

  @override
  void initState() {
    super.initState();

    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {
        cameraController.startImageStream((image) async {
          if (!busy) {
            busy = true;
            await runModelOnStreamFrames(image);
            busy = false;
          }
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();

    await cameraController.dispose();
    await Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face mask detection'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          alignment: FractionalOffset.center,
          children: <Widget>[
            CameraPreview(cameraController),
            // AspectRatio(
            //   key: _keyCameraPreview,
            //   aspectRatio: cameraController.value.aspectRatio,
            //   child: CameraPreview(cameraController),
            // ),
            const Positioned.fill(child: Text('ok')),
          ],
        ),
      ),
    );
  }
}





// import 'package:camera/camera.dart';
// import 'package:face_mask_detection/utils/draw_objects.dart';
// import 'package:face_mask_detection/utils/object_detector.dart';
// import 'package:flutter/material.dart';
// import 'package:face_mask_detection/main.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
//   final ObjectDetecter detector = ObjectDetecter.instance;
//   late CameraController controller;
//   final GlobalKey _keyCameraPreview = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//       detector.addListener(() {
//         setState(() {});
//       });
//       detector.init(controller);
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     controller.dispose();
//     detector.dispose();
//     super.dispose();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     detector.dispose();
//     super.dispose();
//   }

//   Widget _cameraPreviewWidget(List value) {
//     if (!controller.value.isInitialized) {
//       return const Text(
//         'Loading Camera',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return Stack(alignment: FractionalOffset.center, children: <Widget>[
//         AspectRatio(
//             key: _keyCameraPreview,
//             aspectRatio: controller.value.aspectRatio,
//             child: CameraPreview(controller)),
//         Positioned.fill(
//             child: CustomPaint(
//           painter: DrawObjects(value, _keyCameraPreview),
//         )),
//       ]);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(primarySwatch: Colors.blueGrey),
//         home: Scaffold(
//             appBar: AppBar(
//                 title: const Center(
//               child: Text('Object Detector'),
//             )),
//             body: Center(
//               child: Column(children: [
//                 _cameraPreviewWidget(detector.value),
//               ]),
//             )));
//   }
// }
