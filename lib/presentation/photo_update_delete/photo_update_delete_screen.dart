import 'dart:io';

import 'package:firebase_sample/presentation/photo_update_delete/photo_update_delete_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../domain/model/photo.dart';

class PhotoUpdateDeleteScreen extends StatefulWidget {
  final String id;
  final Photo photo;

  const PhotoUpdateDeleteScreen(this.id, this.photo, {Key? key})
      : super(key: key);

  @override
  State<PhotoUpdateDeleteScreen> createState() =>
      _PhotoUpdateDeleteScreenState();
}

class _PhotoUpdateDeleteScreenState extends State<PhotoUpdateDeleteScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _xFile;

  final titleTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleTextController.text = widget.photo.title;

    Future.microtask(() {
      final viewModel = context.read<PhotoUpdateDeleteViewModel>();
      viewModel.eventStream.listen((event) {
        if (event == 'end') {
          print('???????????????????');
          print(event);
          Navigator.pop(context);
          // Navigator.of(context, rootNavigator: true).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    titleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PhotoUpdateDeleteViewModel>();
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
                // 사진 선택
                setState(() {
                  _xFile = image;
                });
              }
            },
            child: SizedBox(
              width: double.infinity,
              height: 300,
              child: _xFile == null
                  ? Image.network(widget.photo.url)
                  : Image.file(File(_xFile!.path)),
            ),
          ),
          TextField(
            controller: titleTextController,
          ),
          ElevatedButton(
            onPressed: () {
              if (_xFile != null) {
                viewModel.updatePhoto(widget.id, widget.photo, _xFile!.path,
                    titleTextController.text);
              }
            },
            child: Text('수정'),
          ),
          if (viewModel.isUploading)
            Row(
              children: const [
                CircularProgressIndicator(),
                Text('수정 중 .....'),
              ],
            ),
        ],
      ),
    );
  }
}
