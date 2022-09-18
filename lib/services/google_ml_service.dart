import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final googleMLserviceProvider =
    Provider<GoogleMLServisceBase>((ref) => GoogleMLService());

abstract class GoogleMLServisceBase {
  Future<String> recogniseText(File imageFile);
}

class SlipItem {
  final String text;
  final double bottom;

  SlipItem(this.text, this.bottom);
}

class GoogleMLService implements GoogleMLServisceBase {
  @override
  Future<String> recogniseText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(inputImage);

      final slipItems = List<SlipItem>.empty(growable: true);
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          if (slipItems
              .any((element) => element.bottom == line.boundingBox.bottom)) {
            var item = slipItems.singleWhere(
                (element) => element.bottom == line.boundingBox.bottom);
            var updatedItem =
                SlipItem('${item.text} ${line.text}', item.bottom);
            slipItems.removeWhere(
                (element) => element.bottom == line.boundingBox.bottom);
            slipItems.add(updatedItem);
          } else {
            slipItems.add(SlipItem(line.text, line.boundingBox.bottom));
          }
        }
      }

      String results = '';
      for (var item in slipItems) {
        if (kDebugMode) {
          print('${item.text} BOTTOM_POSITION: ${item.bottom}');
        }
        results += '${item.text} BOTTOM_POSITION: ${item.bottom}\n';
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
