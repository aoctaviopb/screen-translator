import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';
import 'componentes/text_recognition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  Size? imageSize;
  /*  String texto = "Aca va texto";
  String traduccion = "Aca va una traducción"; */
  List<String> toTranslate = [];
  List<List<Point<int>>> imageCornerPoints = [];
  List<String> translated = [];

  GoogleMlKit googleMlKit = GoogleMlKit();

  RecognizedText? recognizedText;

  late InputImage inputImage;
  final textRecognizer = TextRecognizer(
    script: TextRecognitionScript.korean,
  );

  final TranslateLanguage sourceLanguage = TranslateLanguage.korean;
  final TranslateLanguage targetLanguage = TranslateLanguage.english;

  void pickImage() async {
    imageCornerPoints.clear();
    final ImagePicker imagePicker = ImagePicker();
    final XFile? imgPick =
        await imagePicker.pickImage(source: ImageSource.gallery);
    image = File(imgPick!.path);

    var decode = await decodeImageFromList(image!.readAsBytesSync());
    imageSize = Size(decode.width.toDouble(), decode.height.toDouble());

    inputImage = InputImage.fromFile(image!);
    setState(() {});
  }

  void translate() async {
    recognizedText = await googleMlKit.recognizeText(
      inputImage: inputImage,
      textRecognizer: textRecognizer,
    );

    for (TextBlock block in recognizedText!.blocks) {
      for (TextLine line in block.lines) {
        imageCornerPoints.add(line.cornerPoints);
        toTranslate.add(line.text);
      }
    }

    for (String line in toTranslate) {
      String lineTranslated = await googleMlKit.translateText(
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        text: line,
      );
      translated.add(lineTranslated);
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
/*     double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
 */

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Traducir pantalla'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                child: Container(
                  alignment: Alignment.center,
                  child: image == null
                      ? const Text(
                          'Soy uma imagen',
                        )
                      : CustomPaint(
                          foregroundPainter: RectPainter(
                            imageSize: imageSize!,
                            imageCornerPoints: imageCornerPoints,
                          ),
                          child: Image.file(
                            image!,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
/*             SingleChildScrollView(
              child: Column(
                children: [
                  Text('texto'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(traduccion),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ), */
            TextButton(
              onPressed: translate,
              child: const Text('Traducir'),
            )
          ],
        ),
      ),
    );
  }
}

class RectPainter extends CustomPainter {
  RectPainter({
    required this.imageSize,
    required this.imageCornerPoints,
  });
  Size imageSize;
  List<List<Point<int>>> imageCornerPoints;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color.fromARGB(255, 82, 85, 82)
      ..style = PaintingStyle.fill;

    for (var cornerPoint in imageCornerPoints) {
      Point<int> point1 = cornerPoint[0];
      Point<int> point2 = cornerPoint[2];

      int x1 = point1.x;
      int y1 = point1.y;

      int x2 = point2.x;
      int y2 = point2.y;

      double dx1 = x1 * size.width / imageSize.width;
      double dy1 = y1 * size.height / imageSize.height;

      double dx2 = x2 * size.width / imageSize.width;
      double dy2 = y2 * size.height / imageSize.height;

      var a = Offset(dx1, dy1);
      var b = Offset(dx2, dy2);

      canvas.drawRect(Rect.fromPoints(a, b), paint1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
