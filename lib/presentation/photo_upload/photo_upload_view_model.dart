import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/photo.dart';

/*
  사진 파일을 업로드한다
 */
class PhotoUploadViewModel with ChangeNotifier {
  bool isUploading = false;

  // firestore 저장된 데이터
  final photoRef =
      FirebaseFirestore.instance.collection('photos').withConverter<Photo>(
            fromFirestore: (snapshot, _) => Photo.fromJson(snapshot.data()!),
            toFirestore: (photo, _) => photo.toJson(),
          );

  // 파일 등록 후 이전 화면으로 이동시키기 위해 스트림 사용. 이벤트 처리
  final _streamController = StreamController<String>.broadcast();
  Stream get eventStream => _streamController.stream; // getter..

  // 1. 파일 업로드 : Storage
  Future<String?> _uploadFile(String filePath, String ref) async {
    File file = File(filePath);

    try {
      // final refName = 'uploads/${FirebaseAuth.instance.currentUser!.uid}'
      //     '-${DateTime.now().millisecondsSinceEpoch}.${filePath.split('.').last}';
      await FirebaseStorage.instance.ref(ref).putFile(file);

      final downloadUrl = await _getDownloadURL(ref);
      return downloadUrl;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  // 2. 업로드 URL 얻기
  Future<String> _getDownloadURL(String ref) async {
    String downloadURL =
        await FirebaseStorage.instance.ref(ref).getDownloadURL();

    return downloadURL;
  }

  // 3. DB 업로드  : Firestore
  Future<void> _addTitle(String url, String title, String uploadRef) async {
    try {
      await photoRef.add(Photo(url: url, title: title, uploadRef: uploadRef));
    } catch (e) {
      // 에러 발생
      print('add title error ${e.toString()}');
    }
  }

  //  사진 업로드 전체
  Future<void> uploadPhoto(String filePath, String title) async {
    // 업로드 중....
    isUploading = true;
    notifyListeners();

    // storage 파일 업로드 -> 저장 위치 url 얻기
    final ref = 'uploads/${FirebaseAuth.instance.currentUser!.uid}-'
        '${DateTime.now().millisecondsSinceEpoch}.${filePath.split('.').last}';
    final downloadUrl = await _uploadFile(filePath, ref);

    // store DB 작성
    if (downloadUrl != null) {
      await _addTitle(downloadUrl, title, ref);
    } else {
      // 에러 처리...
    }

    // 업로드 종료....
    isUploading = false;
    notifyListeners();
    _streamController.add('end');
  }
}
