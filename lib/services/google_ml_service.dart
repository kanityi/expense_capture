import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final googleMLserviceProvider =
    Provider<GoogleMLServisceBase>((ref) => GoogleMLService());

abstract class GoogleMLServisceBase {
  Future<String> recogniseText(File imageFile);
}

class GoogleMLService implements GoogleMLServisceBase {
  @override
  Future<String> recogniseText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(inputImage);

      String text = recognizedText.text;
      if (kDebugMode) {
        print('whole text from the picture: $text');
      }

      String results = '';

      for (TextBlock block in recognizedText.blocks) {
        final List<Point<int>> cornerPoints = block.cornerPoints;
        if (kDebugMode) {
          print('cornerPoints from the picture: $cornerPoints');
        }
        final String text = block.text;
        if (kDebugMode) {
          print('text from the picture: $text');
        }
        final List<String> languages = block.recognizedLanguages;
        if (kDebugMode) {
          print('lamguages from the picture: $languages');
        }
        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          for (TextElement word in line.elements) {
            results += word.text;
            // Same getters as TextBlock
            if (kDebugMode) {
              print('element from the picture: ${word.text}');
            }
          }
        }
        results = '$results\n';
      }

      return results;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('error occured : ${e.toString()}');
      }
      return e.toString();
    }
  }
}
