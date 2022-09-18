import 'dart:developer';
import 'dart:io';

import 'package:expense_capture/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/controls_widget.dart';
import '../widgets/text_area_widget.dart';

class ImagePickerPage extends HookConsumerWidget {
  ImagePickerPage({Key? key}) : super(key: key);
  final image = useState<File>(File("no file"));
  final text = useState<String>('');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Recognition'),
      ),
      body: Column(
        children: [
          Expanded(child: buildImage()),
          const SizedBox(height: 16),
          ControlsWidget(
            onClickedPickImage: pickImage,
            onClickedScanText: () => scanText(context, ref),
            onClickedClear: clear,
          ),
          const SizedBox(height: 16),
          TextAreaWidget(
            text: text.value,
            onClickedCopy: copyToClipboard,
          ),
        ],
      ),
    );
  }

  Widget buildImage() => Container(
        child: image.value.path != "no file"
            ? Image.file(File(image.value.path))
            : const Icon(
                Icons.photo,
                size: 80,
                color: Colors.black,
              ),
      );
  Future pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      image.value = File(file.path);
    }
  }

  Future scanText(BuildContext context, WidgetRef ref) async {
    final textProvider =
        await ref.read(textFromImageProvider(image.value).future);
    // showDialog(
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    //   context: context,
    // );

    text.value = textProvider;
  }

  void clear() {
    image.value = File("no file");
    setText('');
  }

  void onButtonTapped(BuildContext context) {
    Navigator.of(context).pop();
  }

  void copyToClipboard() {
    if (text.value.trim() != '') {
      log(text.value);
    }
  }

  void setImage(File newImage) {
    image.value = newImage;
  }

  void setText(String newText) {
    text.value = newText;
  }
}
