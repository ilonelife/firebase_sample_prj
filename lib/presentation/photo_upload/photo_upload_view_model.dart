import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/model/photo.dart';

class PhotoUploadViewModle {
  final photoRef =
      FirebaseFirestore.instance.collection('photos').withConverter<Photo>(
            fromFirestore: (snapshot, _) => Photo.fromJson(snapshot.data()!),
            toFirestore: (photo, _) => photo.toJson(),
          );

  // 1. 파일 업로드 : Storage

  // 2. 업로드 URL 얻기

  // 3. DB 업로드  : Firestore

  //  전체

}
