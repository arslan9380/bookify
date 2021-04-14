import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageHelper {

  Future<String> uploadFiles(File image, String folder) async {
    String url;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      if (image == null) return null;
      await FirebaseStorage.instance
          .ref()
          .child(folder)
          .child(id)
          .putFile(image)
          .then((value) async {
        url = await value.ref.getDownloadURL();
      });
      return url;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
