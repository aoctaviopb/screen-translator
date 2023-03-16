import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';
import 'componentes/custom_painter.dart';
import 'componentes/text_recognition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  Size? imageSize;
  List<List<Point<int>>> imageCornerPoints = [];
  List<String> toTranslate = [];
  List<String> translated = [];

  GoogleMlKit googleMlKit = GoogleMlKit();

  RecognizedText? recognizedText;
  final translator = GoogleTranslator();

  late InputImage inputImage;
  final textRecognizer = TextRecognizer(
    script: TextRecognitionScript.korean,
  );

  final TranslateLanguage sourceLanguage = TranslateLanguage.korean;
  final TranslateLanguage targetLanguage = TranslateLanguage.english;

  void pickImage() async {
    clear();
    final ImagePicker imagePicker = ImagePicker();

    final XFile? imgPick =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (imgPick == null) {
      return;
    }
    image = File(imgPick.path);

    var decode = await decodeImageFromList(image!.readAsBytesSync());
    imageSize = Size(decode.width.toDouble(), decode.height.toDouble());

    inputImage = InputImage.fromFile(image!);
    setState(() {});
  }

  void translate() async {
    clear();
    recognizedText = await googleMlKit.recognizeText(
      inputImage: inputImage,
      textRecognizer: textRecognizer,
    );

    for (TextBlock block in recognizedText!.blocks) {
      imageCornerPoints.add(block.cornerPoints);
      toTranslate.add(block.text);
/*       for (TextLine line in block.lines) {
        imageCornerPoints.add(line.cornerPoints);
        toTranslate.add(line.text);
      } */
    }

    for (String line in toTranslate) {
/*       String lineTranslated = await googleMlKit.translateText( //Translate with google MLKit (is better with the widget translator)
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        text: line,
      ); */

      Translation lineTranslated =
          await translator.translate(line, from: 'auto', to: 'en');

      translated.add(lineTranslated.toString());
    }

    setState(() {});
  }

  void clear() {
    imageCornerPoints = [];
    toTranslate = [];
    translated = [];
  }

  @override
  void dispose() {
    super.dispose();
    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: image != null
                      ? const Text(
                          'Soy uma imagen',
                        )
                      : CustomPaint(
                          foregroundPainter: RectPainter(
                            imageSize: imageSize!,
                            imageCornerPoints: imageCornerPoints,
                            translated: translated,
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
