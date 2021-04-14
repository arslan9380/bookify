import 'dart:io';

import 'package:bookify/controllers/book_controller.dart';
import 'package:bookify/helpers/book_helper.dart';
import 'package:bookify/helpers/image_helper.dart';
import 'package:bookify/models/book_model.dart';
import 'package:bookify/screens/bookshop_owner_screens/pick_book_genre_screen.dart';
import 'package:bookify/screens/widgets/auth_input_field.dart';
import 'package:bookify/screens/widgets/custom_button.dart';
import 'package:bookify/utils/static_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class AddBookScreen extends StatefulWidget {
  final BookModel bookModel;

  AddBookScreen({this.bookModel});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  TextEditingController descriptionCon = TextEditingController();
  FocusNode descriptionNode = FocusNode();
  List<String> selectedGenre = [];
  File pdfBook;
  File coverPhoto;
  File endPagePhoto;

  @override
  void initState() {
    if (widget.bookModel != null) {
      selectedGenre.addAll(widget.bookModel.bookGenre);
      descriptionCon.text = widget.bookModel.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookModel != null ? "Edit Book" : "Add Book"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var file = await pickFile(pickImage: false);
                  if (file != null) {
                    setState(() {
                      pdfBook = file;
                    });
                  }
                },
                child: Container(
                  height: Get.height * 0.3,
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        pdfBook == null && widget.bookModel == null
                            ? Icons.add
                            : Icons.update,
                        color: Theme.of(context).primaryColor,
                        size: 40,
                      ),
                      Text(
                        pdfBook == null && widget.bookModel == null
                            ? "Pick Pdf book"
                            : "Update book",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        var file = await pickFile();
                        if (file != null) {
                          setState(() {
                            coverPhoto = file;
                          });
                        }
                      },
                      child: Container(
                        height: Get.height * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            image: coverPhoto == null &&
                                    widget.bookModel?.coverPhotoUrl == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: coverPhoto != null
                                        ? FileImage(coverPhoto)
                                        : widget.bookModel?.coverPhotoUrl !=
                                                null
                                            ? NetworkImage(
                                                widget.bookModel?.coverPhotoUrl)
                                            : null)),
                        child: coverPhoto != null ||
                                widget.bookModel?.coverPhotoUrl != null
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Theme.of(context).primaryColor,
                                    size: 40,
                                  ),
                                  Text(
                                    "Pick a book cover photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        var file = await pickFile();
                        if (file != null) {
                          setState(() {
                            endPagePhoto = file;
                          });
                        }
                      },
                      child: Container(
                        height: Get.height * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            image: endPagePhoto == null &&
                                    widget.bookModel?.endPagePhotoUrl == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: endPagePhoto != null
                                        ? FileImage(endPagePhoto)
                                        : widget.bookModel?.endPagePhotoUrl !=
                                                null
                                            ? NetworkImage(widget
                                                .bookModel.endPagePhotoUrl)
                                            : null)),
                        child: endPagePhoto != null ||
                                widget.bookModel?.endPagePhotoUrl != null
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Theme.of(context).primaryColor,
                                    size: 40,
                                  ),
                                  Text(
                                    "Pick a book end page photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              AuthInputField(
                maxlines: 8,
                hint: "Type description here",
                controller: descriptionCon,
                focusNode: descriptionNode,
              ),
              SizedBox(height: 10),
              CustomButton(
                  text: selectedGenre.length == 0
                      ? "Select book genre"
                      : "Update book genre",
                  onPressed: () async {
                    descriptionNode?.unfocus();
                    var result = await Get.to(PickBookGenre());
                    if (result != null) {
                      selectedGenre = result;
                      setState(() {});
                    }
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          descriptionNode?.unfocus();
          if (widget.bookModel == null) {
            addBook();
          } else {
            updateBook();
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.check),
      ),
    );
  }

  Future<void> addBook() async {
    if (pdfBook == null) {
      Toast.show("Please pick a book.", context);
      return;
    }
    if (coverPhoto == null && endPagePhoto == null) {
      Toast.show("Please add book images.", context);
      return;
    }
    if (descriptionCon.text.isEmpty) {
      Toast.show("Please type book description.", context);
      return;
    }
    if (selectedGenre.length == 0) {
      Toast.show("Please select atleast one genre.", context);
      return;
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      Toast.show("it seems you don't have internet connection.", context);
      return;
    }
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(
      progressWidget: CircularProgressIndicator(),
      message: "Please wait",
    );
    dialog.show();

    String pdfBookUrl = await ImageHelper().uploadFiles(pdfBook, "Books");
    if (pdfBookUrl == null) {
      Toast.show("Please try again later.", context);
      return;
    }
    String coverPhotoUrl =
        await ImageHelper().uploadFiles(coverPhoto, "CoverPhotos");
    if (coverPhotoUrl == null) {
      Toast.show("Please try again later.", context);
      return;
    }
    String endPagePhotoUrl =
        await ImageHelper().uploadFiles(endPagePhoto, "EndPagePhotos");
    if (endPagePhotoUrl == null) {
      Toast.show("Please try again later.", context);
      return;
    }

    String id = DateTime.now().millisecondsSinceEpoch.toString();
    BookModel bookModel = BookModel(
        bookUrl: pdfBookUrl,
        coverPhotoUrl: coverPhotoUrl,
        endPagePhotoUrl: endPagePhotoUrl,
        description: descriptionCon.text,
        bookGenre: selectedGenre,
        isbnNo: "ISBN-$id",
        bookId: id,
        addedByUid: StaticInfo.user.uid,
        addedBy: StaticInfo.user.name,
        addedTime: Timestamp.now());

    var response = await BookHelper().addBook(bookModel);
    dialog.hide();
    if (response == "success") {
      Get.put(BookController()).myBooks.insert(0, bookModel);
      Get.back();
      Get.snackbar("Hurray!", "Book added successfully",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2));
    } else {
      Get.snackbar("Fail!", "Please try again",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2));
    }
  }

  void updateBook() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      Toast.show("it seems you don't have internet connection.", context);
      return;
    }
    if (descriptionCon.text.isEmpty) {
      Toast.show("Please add short description of book.", context);
      return;
    }
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(
      progressWidget: CircularProgressIndicator(),
      message: "Please wait",
    );
    dialog.show();

    String pdfBookUrl;
    String coverPhotoUrl;
    String endPagePhotoUrl;

    if (pdfBook != null) {
      pdfBookUrl = await ImageHelper().uploadFiles(pdfBook, "Books");
      if (pdfBookUrl == null) {
        Toast.show("Please try again later.", context);
        return;
      }
    }

    if (coverPhoto != null) {
      coverPhotoUrl =
          await ImageHelper().uploadFiles(coverPhoto, "CoverPhotos");
      if (coverPhotoUrl == null) {
        Toast.show("Please try again later.", context);
        return;
      }
    }

    if (endPagePhoto != null) {
      endPagePhotoUrl =
          await ImageHelper().uploadFiles(endPagePhoto, "EndPagePhotos");
      if (endPagePhotoUrl == null) {
        Toast.show("Please try again later.", context);
        return;
      }
    }

    BookModel bookModel = BookModel(
        bookUrl: pdfBookUrl ?? widget.bookModel.bookUrl,
        coverPhotoUrl: coverPhotoUrl ?? widget.bookModel.coverPhotoUrl,
        endPagePhotoUrl: endPagePhotoUrl ?? widget.bookModel.endPagePhotoUrl,
        description: descriptionCon.text,
        bookGenre: selectedGenre,
        isbnNo: widget.bookModel.isbnNo,
        bookId: widget.bookModel.bookId,
        addedByUid: widget.bookModel.addedByUid,
        addedBy: widget.bookModel.addedBy,
        addedTime: widget.bookModel.addedTime);

    var response = await BookHelper().addBook(bookModel);
    dialog.hide();
    if (response == "success") {
      int index = Get.put(BookController())
          .myBooks
          .indexWhere((element) => element.bookId == widget.bookModel.bookId);
      Get.put(BookController()).myBooks[index] = bookModel;
      if (pdfBook != null) {
        BookHelper().deleteFileFromStorage(widget.bookModel.bookUrl);
      }
      if (coverPhoto != null) {
        BookHelper().deleteFileFromStorage(widget.bookModel.coverPhotoUrl);
      }
      if (endPagePhoto != null) {
        BookHelper().deleteFileFromStorage(widget.bookModel.endPagePhotoUrl);
      }
      Get.back();
      Get.snackbar("Hurray!", "Book Updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2));
    } else {
      Get.snackbar("Fail!", "Please try again",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2));
    }
  }

  Future<File> pickFile({bool pickImage = true}) async {
    File pickedFile;
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: pickImage ? ['jpg', 'png'] : ['pdf'],
    );
    if (result != null) {
      Toast.show("picked successfully", context);
      pickedFile = File(result.files.single.path);
    }
    return pickedFile;
  }
}
