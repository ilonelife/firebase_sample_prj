import 'package:firebase_sample/presentation/photo_list/photo_list_view_model.dart';
import 'package:firebase_sample/presentation/photo_update_delete/photo_update_delete_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../domain/model/photo.dart';
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

  Widget _buildBody() {
    return FirestoreListView<Photo>(
      query: viewModel.photoRef,
      loadingBuilder: (context) => const CircularProgressIndicator(),
      errorBuilder: (context, error, stackTrace) => ListTile(
        title: Text(error.toString()),
        subtitle: Text(stackTrace.toString()),
      ),
      itemBuilder: (context, snapshot) {
        Photo photo = snapshot.data();
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PhotoUpdateDeleteScreen(snapshot.id, photo)),
            );
          },
          child: PhotoItem(photo),
        );
      },
    );
  }
// _buildBody() {
//   return ListView(
//     children: viewModel.photos.map((e) => PhotoItem(e)).toList(),
//   );
// }

//streambuilder 방식....
// _buildBody() {
//   return StreamBuilder<Object>(
//     stream: null,
//     builder: (context, snapshot) {
//       return ListView(
//         children: viewModel.photos.map((e) => PhotoItem(e)).toList(),
//       );
//     }
//   );
// }
}
