import 'dart:io';

import 'package:expense_capture/services/google_ml_service.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final textFromImageProvider =
    FutureProvider.family<String, InputImage>((ref, imageFile) async {
  return ref.read(googleMLserviceProvider).recogniseText(imageFile);
});
