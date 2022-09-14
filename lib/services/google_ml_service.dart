import 'dart:io';

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
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          results += '${line.text}\n';
          if (kDebugMode) {
            print(line.text);
          }
        }
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
