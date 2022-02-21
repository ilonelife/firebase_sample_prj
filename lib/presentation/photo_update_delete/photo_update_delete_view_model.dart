import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/photo.dart';

class PhotoUpdateDeleteViewModel with ChangeNotifier {
  bool isUploading = false;

  final photosRef =
      FirebaseFirestore.instance.collection('photos').withConverter<Photo>(
            fromFirestore: (snapshot, _) => Photo.fromJson(snapshot.data()!),
            toFirestore: (photo, _) => photo.toJson(),
          );

  // 이벤트 처리
  final _streamController = StreamController<String>.broadcast();
  Stream<String> get eventStream => _streamController.stream;

  // 2. URL 얻기
  Future<String> _getDownloadURL(String ref) async {
    String downloadURL =
        await FirebaseStorage.instance.ref(ref).getDownloadURL();

    return downloadURL;
  }

  // 1. 파일 업로드
  Future<String?> _uploadFile(String filePath, String ref) async {
    File file = File(filePath);

    try {
      await FirebaseStorage.instance.ref(ref).putFile(file);

      final downloadUrl = await _getDownloadURL(ref);

      print('!!!!!!!!!');
      print(downloadUrl);
      return downloadUrl;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return null;
    }
  }

  // 3. DB 업로드
  Future<void> _updateTitle(
      String id, String url, String title, String ref) async {
    try {
      await photosRef
          .doc(id)
          .update(Photo(url: url, title: title, uploadRef: ref).toJson());
    } catch (e) {
      // 에러
      print('add Title 실패 ${e.toString()}');
    }
  }

  Future<void> updatePhoto(
      String id, Photo photo, String filePath, String title) async {
    // 업로드 중!!!!!!!!!!!!!!!!
    isUploading = true;
    notifyListeners();
    // _streamController.add('start');

    // 1. 파일 업로드 -> URL 얻기
    final ref = photo.uploadRef ?? '';

    final downloadUrl = await _uploadFile(filePath, ref);

    // 2. DB 작성
    if (downloadUrl != null) {
      await _updateTitle(id, downloadUrl, title, ref);
    } else {
      print('updatePhoto error');
    }

    // 업로드 끝!!!!!!!!!!!!!!!!
    isUploading = false;
    notifyListeners();
    _streamController.add('end');
  }
}
