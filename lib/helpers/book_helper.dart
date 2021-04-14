import 'package:bookify/models/book_model.dart';
import 'package:bookify/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookHelper {
  String _books = "allBooks";

  Future<String> addBook(BookModel book) async {
    try {
      await FirebaseFirestore.instance
          .collection(_books)
          .doc(book.bookId)
          .set(book.toMap(), SetOptions(merge: true));

      return Constants.success;
    } catch (e) {
      print("Error: $e");
      return Constants.fail;
    }
  }

  Future<List<BookModel>> getBooksByUid(String uid) async {
    List<BookModel> books = [];
    try {
      var result = await FirebaseFirestore.instance
          .collection(_books)
          .where("addedByUid", isEqualTo: uid)
          .get();

      for (var doc in result.docs) {
        books.add(BookModel.fromMap(doc.data()));
      }
      return books;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String> deleteBookById(BookModel book) async {
    try {
      await FirebaseFirestore.instance
          .collection(_books)
          .doc(book.bookId)
          .delete();
      deleteFileFromStorage(book.bookUrl);
      deleteFileFromStorage(book.coverPhotoUrl);
      deleteFileFromStorage(book.endPagePhotoUrl);

      return Constants.success;
    } catch (e) {
      print(e);
      return Constants.fail;
    }
  }

  Future<String> editBook(BookModel book) async {
    try {
      await FirebaseFirestore.instance
          .collection(_books)
          .doc(book.bookId)
          .set(book.toMap(), SetOptions(merge: true));

      return Constants.success;
    } catch (e) {
      print("Error: $e");
      return Constants.fail;
    }
  }

  Future deleteFileFromStorage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (e) {
      print(e);
    }
  }
}
