import 'dart:io';

import 'package:expense_capture/services/google_ml_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final textFromImageProvider =
    FutureProvider.family<String, File>((ref, imageFile) async {
  return ref.read(googleMLserviceProvider).recogniseText(imageFile);
});
