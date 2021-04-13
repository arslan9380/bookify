import 'package:bookify/screens/bookshop_owner_screens/add_book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerHome extends StatefulWidget {
  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookify"),
        centerTitle: true,
      ),
      body: Column(
        children: [Center(child: Text("You have added no books"))],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Get.to(AddBook()),
        child: Icon(Icons.add),
      ),
    );
  }
}
