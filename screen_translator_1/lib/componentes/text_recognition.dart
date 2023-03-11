import 'dart:io';
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/painting/image_decoder.dart' as dec;

class GoogleMlKit {
  Future<RecognizedText> recognizeText({
    required InputImage inputImage,
    required TextRecognizer textRecognizer,
  }) async {
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    RecognizedText text = recognizedText;

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
