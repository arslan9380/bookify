import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickBookGenre extends StatefulWidget {
  @override
  _PickBookGenreState createState() => _PickBookGenreState();
}

class _PickBookGenreState extends State<PickBookGenre> {
  List<String> bookGenre = ["Action", "Adventure", "Classics", "History"];
  List<String> selectedGenre = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Book Genre"),
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: () {
                  Get.back(result: selectedGenre);
                },
                child: Center(
                    child: Container(
                        margin: EdgeInsets.only(right: 16),
                        child: Icon(Icons.check))))
          ],
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: bookGenre.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  if (selectedGenre.contains(bookGenre[index])) {
                    selectedGenre.remove(bookGenre[index]);
                  } else {
                    selectedGenre.add(bookGenre[index]);
                  }
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        bookGenre[index],
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Theme.of(context).primaryColor),
                      ),
                      Spacer(),
                      Checkbox(
                        value: selectedGenre.contains(bookGenre[index]),
                        activeColor: Theme.of(context).primaryColor,
                        checkColor: Colors.white,
                        onChanged: (bool x) {
                          if (selectedGenre.contains(bookGenre[index])) {
                            selectedGenre.remove(bookGenre[index]);
                          } else {
                            selectedGenre.add(bookGenre[index]);
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
