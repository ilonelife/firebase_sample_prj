import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/model/photo.dart';

/*
  사진 파일을 업로드한다
 */
class PhotoUploadViewModle {
  final photoRef =
      FirebaseFirestore.instance.collection('photos').withConverter<Photo>(
            fromFirestore: (snapshot, _) => Photo.fromJson(snapshot.data()!),
            toFirestore: (photo, _) => photo.toJson(),
          );

  // 1. 파일 업로드 : Storage
  Future<String?> _uploadMemory(String filePath) async {
    File file = File(filePath);

    try {
      final refName = 'uploads/${FirebaseAuth.instance.currentUser!.uid}'
          '-${DateTime.now().millisecondsSinceEpoch}.${filePath.split('.').last}';
      await FirebaseStorage.instance.ref(refName).putFile(file);

      final downloadUrl = await _getDownloadURL(refName);
      return downloadUrl;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<String?> _uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      final refName = 'uploads/${FirebaseAuth.instance.currentUser!.uid}'
          '-${DateTime.now().millisecondsSinceEpoch}.${filePath.split('.').last}';
      await FirebaseStorage.instance.ref(refName).putFile(file);

      final downloadUrl = await _getDownloadURL(refName);
      return downloadUrl;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  // 2. 업로드 URL 얻기
  Future<String> _getDownloadURL(String refName) async {
    String downloadURL =
        await FirebaseStorage.instance.ref(refName).getDownloadURL();

    return downloadURL;
  }

  // 3. DB 업로드  : Firestore
  Future<void> _addTitle(String url, String title) async {
    try {
      await photoRef.add(Photo(url: url, title: title));
    } catch (e) {
      // 에러 발생
      print('add title error ${e.toString()}');
    }
  }

  //  사진 업로드 전체
  Future<void> uploadPhoto(String filePath, String title) async {
    // storage 파일 업로드 -> 저장 위치 url 얻기
    final downloadUrl = await _uploadFile(filePath);

    // store DB 작성
    if (downloadUrl != null) {
      await _addTitle(downloadUrl, title);
    } else {
      // 에러 처리...
    }
  }
}
