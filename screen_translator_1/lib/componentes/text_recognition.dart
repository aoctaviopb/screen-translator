import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class GoogleMlKit {
  Future<String> recognizeText({
    required File image,
    required TextRecognizer textRecognizer,
  }) async {
    final InputImage inputImage;
    inputImage = InputImage.fromFile(image);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;

    for (TextBlock block in recognizedText.blocks) {
      final String textBlock = block.text;
      final List<String> languages = block.recognizedLanguages;

      //print(block.cornerPoints);
      //print(block.boundingBox.left);


      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        //print(line.cornerPoints);

/*         for (TextElement element in line.elements) {
          // Same getters as TextBlock
        } */
      }
    }

  return text;

  }

  Future<String> translateText({
    required TranslateLanguage sourceLanguage,
    required TranslateLanguage targetLanguage,
    required String text,
  }) async {
    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    final String response = await onDeviceTranslator.translateText(text);
    return response;
  }


}
