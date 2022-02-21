import 'dart:io';

import 'package:firebase_sample/presentation/photo_upload/photo_upload_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({Key? key}) : super(key: key);

  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final viewModel = PhotoUploadViewModle();
  final ImagePicker _picker = ImagePicker();

  XFile? _xFile;
  // Uint8List? _memory;

  final titleTextController = TextEditingController();

  @override
  void dispose() {
    titleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 업로드'),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () async {
              final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (image == null) {
                // 취소
              } else {
                final bytes = await image.readAsBytes();
                setState(() {
                  _xFile = image;
                  // _memory = bytes;
                });
              }
            },
            child: SizedBox(
              width: double.infinity,
              height: 300,
              // child: _memory == null ? Placeholder() : Image.memory(_memory!),
              child: _xFile == null
                  ? Placeholder()
                  : Image.file(File(_xFile!.path)),
            ),
          ),
          TextField(
            controller: titleTextController,
          ),
          ElevatedButton(
            onPressed: () {
              // if (_memory != null) {
              //   viewModel.uploadPhoto(_memory., titleTextController.text);
              // }
              if (_xFile != null) {
                viewModel.uploadPhoto(_xFile!.path, titleTextController.text);
              }
            },
            child: const Text('업로드'),
          ),
        ],
      ),
    );
  }
}
