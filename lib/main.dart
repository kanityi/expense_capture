import 'dart:io';

import 'package:camera/camera.dart';
import 'package:expense_capture/pages/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers.dart';

late List<CameraDescription> _cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    File s = File("");
    bool _canProcess = true;
    bool _isBusy = false;
    CustomPaint? _customPaint;
    String? _text;
    //final textFromImage = ref.watch(textFromImageProvider(s));
    return MaterialApp(
      home: CameraView(
        title: 'Text Detector',
        customPaint: _customPaint,
        text: _text,
        onImage: (inputImage) {
          ref.read(textFromImageProvider(inputImage));
        },
        cameras: _cameras,
      ),
    );
  }
}
