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
  String texto = "Aca va texto";
  String traduccion = "Aca va una traducción";

  GoogleMlKit googleMlKit = GoogleMlKit();

  final textRecognizer = TextRecognizer(
    script: TextRecognitionScript.korean,
  );

  final TranslateLanguage sourceLanguage = TranslateLanguage.korean;
  final TranslateLanguage targetLanguage = TranslateLanguage.english;

  void pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? imgPick =
        await imagePicker.pickImage(source: ImageSource.gallery);
    image = File(imgPick!.path);
    setState(() {});
  }

  void translate() async {
    texto = await googleMlKit.recognizeText(
      image: image!,
      textRecognizer: textRecognizer,
    );

    traduccion = await googleMlKit.translateText(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      text: texto,
    );

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
                        foregroundPainter: RectPainter(),
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(texto),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(traduccion),
                ],
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

class RectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color.fromARGB(255, 82, 85, 82)
      ..style = PaintingStyle.fill;
    //canvas.drawRect(Offset(22, 165) & Size(200, 100), paint1);
    //print(size.height);
    //print(size.width);
    var a = const Offset(0, 0); 
    var b = const Offset(109, 45);

    canvas.drawRect(Rect.fromPoints(a, b), paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
