// import 'package:flutter/material.dart';
// import 'package:face_mask_detection/main.dart';

// class DrawObjects extends CustomPainter {
//   final List? values;
//   GlobalKey<State<StatefulWidget>> keyCameraPreview;
//   DrawObjects(this.values, this.keyCameraPreview);

//   @override
//   void paint(Canvas canvas, Size size) {
//     print(values);
//     if (values == null && values!.isNotEmpty && values?[0] == null) return;

//     final RenderBox renderPreview =
//         keyCameraPreview.currentContext!.findRenderObject() as RenderBox;
//     final sizeRed = renderPreview.size;

//     var ratioW = sizeRed.width / 416;
//     var ratioH = sizeRed.height / 416;
//     for (var value in values!) {
//       var index = value["classIndex"];
//       var rgb = colors[index];
//       Paint paint = Paint();
//       paint.color =
//           Color.fromRGBO(rgb[0].toInt(), rgb[1].toInt(), rgb[2].toInt(), 1);
//       paint.strokeWidth = 2;
//       var rect = value["rect"];
//       double x1 = rect["left"] * ratioW,
//           x2 = rect["right"] * ratioW,
//           y1 = rect["top"] * ratioH,
//           y2 = rect["bottom"] * ratioH;
//       TextSpan span = TextSpan(
//           style: TextStyle(
//               color: Colors.black,
//               background: paint,
//               fontWeight: FontWeight.bold,
//               fontSize: 14),
//           text: " " +
//               labels[index] +
//               " " +
//               (value["confidence"] * 100).round().toString() +
//               " % ");
//       TextPainter tp = TextPainter(
//           text: span,
//           textAlign: TextAlign.left,
//           textDirection: TextDirection.ltr);
//       tp.layout();
//       tp.paint(canvas, Offset(x1 + 1, y1 + 1));
//       tp.paint(canvas, const Offset(1, 2));
//       canvas.drawLine(Offset(x1, y1), Offset(x2, y1), paint);
//       canvas.drawLine(Offset(x1, y1), Offset(x1, y2), paint);
//       canvas.drawLine(Offset(x1, y2), Offset(x2, y2), paint);
//       canvas.drawLine(Offset(x2, y1), Offset(x2, y2), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(DrawObjects oldDelegate) {
//     return true;
//   }
// }
