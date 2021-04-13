import 'package:bookify/controllers/book_controller.dart';
import 'package:bookify/helpers/book_helper.dart';
import 'package:bookify/screens/bookshop_owner_screens/add_book_screen.dart';
import 'package:bookify/screens/widgets/book_widget.dart';
import 'package:bookify/utils/static_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerHomeScreen extends StatefulWidget {
  @override
  _OwnerHomeScreenState createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  BookController bookController = Get.put(BookController());
  String message = "You have added no books";
  bool loading = true;

  @override
  void initState() {
    fetchMyBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookify"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: loading == true
            ? Center(child: CircularProgressIndicator())
            : Obx(
                () => Column(
                  children: [
                    bookController.myBooks.length == 0
                        ? Center(
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 30),
                                child: Text(message)))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: bookController.myBooks.length,
                            itemBuilder: (_, index) {
                              return BookWidget(bookController.myBooks[index]);
                            }),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Get.to(AddBookScreen()),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchMyBooks() async {
    var response = await BookHelper().getBooksByUid(StaticInfo.user.uid);
    if (response == null) {
      message = "Error in fetching books";
    } else {
      bookController.myBooks.addAll(response);
    }
    loading = false;
    setState(() {});
  }
}
