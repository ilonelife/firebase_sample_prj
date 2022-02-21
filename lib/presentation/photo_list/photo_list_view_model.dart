import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/model/photo.dart';

class PhotoListViewModel {
  final photoRef =
      FirebaseFirestore.instance.collection('photos').withConverter<Photo>(
            fromFirestore: (snapshot, _) => Photo.fromJson(snapshot.data()!),
            toFirestore: (photo, _) => photo.toJson(),
          );

  final photos = [
    // Photo(
    //   url:
    //       'https://cdn.pixabay.com/photo/2018/04/22/21/30/bird-3342446_960_720.jpg',
    //   title: 'test image 1',
    // ),
    // Photo(
    //   url:
    //       'https://cdn.pixabay.com/photo/2017/07/02/15/54/the-whale-2464799_960_720.jpg',
    //   title: 'test image 2',
    // ),
  ];
}
