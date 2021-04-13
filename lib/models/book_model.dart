import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String bookUrl;
  String coverPhotoUrl;
  Timestamp addedTime;
  String endPagePhotoUrl;
  String description;
  List<String> bookGenre;
  String isbnNo;
  String bookId;
  String addedByUid;
  String addedBy;

  BookModel(
      {this.bookUrl,
      this.coverPhotoUrl,
      this.addedTime,
      this.endPagePhotoUrl,
      this.description,
      this.bookGenre,
      this.isbnNo,
      this.bookId,
      this.addedByUid,
      this.addedBy});

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return new BookModel(
      bookUrl: map['bookUrl'] as String,
      coverPhotoUrl: map['coverPhotoUrl'] as String,
      addedTime: map['addedTime'] as Timestamp,
      endPagePhotoUrl: map['endPagePhotoUrl'] as String,
      description: map['description'] as String,
      bookGenre: List.castFrom(map['bookGenre']),
      isbnNo: map['isbnNo'] as String,
      bookId: map['bookId'] as String,
      addedByUid: map['addedByUid'] as String,
      addedBy: map['addedBy'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'bookUrl': this.bookUrl,
      'coverPhotoUrl': this.coverPhotoUrl,
      'addedTime': this.addedTime,
      'endPagePhotoUrl': this.endPagePhotoUrl,
      'description': this.description,
      'bookGenre': this.bookGenre,
      'isbnNo': this.isbnNo,
      'bookId': this.bookId,
      'addedByUid': this.addedByUid,
      'addedBy': this.addedBy,
    } as Map<String, dynamic>;
  }
}
