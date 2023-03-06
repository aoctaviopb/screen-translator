import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  String texto = "Aca va texto";
  String traduccion = "Aca va una traducción";
  final textRecognizer = TextRecognizer(
    script: TextRecognitionScript.korean,
  );

  void pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? imgPick =
        await imagePicker.pickImage(source: ImageSource.gallery);
    image = File(imgPick!.path);
    setState(() {});
  }

  void recognizeText() async {
    final InputImage inputImage;
    inputImage = InputImage.fromFile(image!);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    //print(text);
    setState(() {
      texto = text;
    });

    translateText(text);

/*     for (TextBlock block in recognizedText.blocks) {
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    } */
  }

  void translateText(String text) async {
    final TranslateLanguage sourceLanguage;
    final TranslateLanguage targetLanguage;

    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.korean,
      targetLanguage: TranslateLanguage.english,
    );

    final String response = await onDeviceTranslator.translateText(text);
    print(response);
    setState(() {
      traduccion = response;
    });
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
        //width: double.infinity,
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
                      : Image.file(
                          image!,
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
              onPressed: recognizeText,
              child: const Text('Traducir'),
            )
          ],
        ),
      ),
    );
  }
}
