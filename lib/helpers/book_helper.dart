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

      return success;
    } catch (e) {
      print("Error: $e");
      return fail;
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

      await FirebaseStorage.instance.refFromURL(book.bookUrl).delete();
      await FirebaseStorage.instance.refFromURL(book.coverPhotoUrl).delete();
      await FirebaseStorage.instance.refFromURL(book.endPagePhotoUrl).delete();

      return success;
    } catch (e) {
      print(e);
      return fail;
    }
  }

  Future<String> editBook(BookModel book) async {
    try {
      await FirebaseFirestore.instance
          .collection(_books)
          .doc(book.bookId)
          .set(book.toMap(), SetOptions(merge: true));

      return success;
    } catch (e) {
      print("Error: $e");
      return fail;
    }
  }

}
