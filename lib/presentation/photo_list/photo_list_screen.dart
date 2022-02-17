import 'package:firebase_sample/presentation/photo_list/photo_list_view_model.dart';
import 'package:flutter/material.dart';

import '../photo_upload/photo_upload_screen.dart';
import 'components/photo_item.dart';

class PhotoListScreen extends StatelessWidget {
  PhotoListScreen({Key? key}) : super(key: key);

  final viewModel = PhotoListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사진 리스트'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoUploadScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
    ;
  }

  _buildBody() {
    return ListView(
      children: viewModel.photos.map((e) => PhotoItem(e)).toList(),
    );
  }
}
