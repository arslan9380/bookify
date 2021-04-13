import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookify/controllers/book_controller.dart';
import 'package:bookify/helpers/book_helper.dart';
import 'package:bookify/models/book_model.dart';
import 'package:bookify/screens/bookshop_owner_screens/add_book_screen.dart';
import 'package:bookify/utils/static_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class BookWidget extends StatefulWidget {
  final BookModel book;
  final String heroId;

  BookWidget(this.book, {this.heroId = "1"});

  @override
  _BookWidgetState createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget>
    with SingleTickerProviderStateMixin {
  BookController _controller = Get.put(BookController());
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xff707070))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  if (StaticInfo.user.accountType != "owner") {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi) {
                    } else {
                      Get.snackbar("Network Error",
                          "You need network connection to visit profile",
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: Colors.white,
                          backgroundColor: Colors.black,
                          duration: Duration(seconds: 2));
                    }
                  } else {}
                },
                child: Container(
                  height: 70,
                  width: 70,
                  //  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)),
                  child: ClipOval(
                      clipBehavior: Clip.antiAlias, child: profileImage()),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: Get.width * 0.50,
                            child: AutoSizeText(
                              widget.book.addedBy.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 12,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: const Color(0xff4c3f58),
                                fontWeight: FontWeight.w900,
                              ),
                            )),
                        Row(
                          children: [
                            Timeago(
                              builder: (_, value) => Text(
                                value == "now" ? value : value,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 8,
                                  color: const Color(0xff7b7b7b),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              date: widget.book.addedTime.toDate(),
                              locale: "en",
                              allowFromNow: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              StaticInfo.user.accountType == "owner"
                  ? PopupMenuButton(
                      onSelected: (String value) async {
                        if (value == "Delete") {
                          Get.defaultDialog(
                              title:
                                  "Are you sure you want to delete this Post?",
                              middleText:
                                  "it will be no more visible in your's and others feeds",
                              buttonColor: Theme.of(context).primaryColor,
                              cancelTextColor: Theme.of(context).primaryColor,
                              confirmTextColor: Colors.white,
                              onCancel: () {
                                Get.back();
                              },
                              textConfirm: "  Delete  ",
                              onConfirm: () async {
                                Get.back();
                                _controller.myBooks.remove(widget.book);
                                await BookHelper().deleteBookById(widget.book);
                              });
                        } else if (value == 'Edit') {
                          Get.to(AddBookScreen(bookModel: widget.book,));
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                      child: Container(
                        height: Get.width * 0.18,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.more_vert)),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          Get.defaultDialog(
                              title:
                                  "Are you sure you want to Save it offline?",
                              middleText: "",
                              buttonColor: Theme.of(context).primaryColor,
                              confirmTextColor: Colors.white,
                              onCancel: () {
                                Get.back();
                              },
                              textConfirm: "  Save  ",
                              onConfirm: () {
                                Get.back();
                              });
                        } else {
                          Get.snackbar("Network Error",
                              "You need network connection to save post",
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: Colors.white,
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 2));
                        }
                      },
                      child: Container(
                          height: Get.width * 0.18,
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.download_sharp))),
                    ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 4),
            child: ReadMoreText(
              widget.book.description,
              trimLines: 2,
              colorClickableText: Colors.red,
              trimMode: TrimMode.Line,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: const Color(0xff4c3f58),
              ),
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          widget.book.coverPhotoUrl != "" || widget.book.endPagePhotoUrl != ""
              ? Container(
                  margin: EdgeInsets.only(top: 4),
                  height: Get.width * 0.6,
                  width: Get.width,
                  child: Stack(
                    children: [
                      ClipRect(
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: Stack(children: <Widget>[
                              Container(
                                height: Get.width * 0.6,
                                width: Get.width,
                                child: CachedNetworkImage(
                                  imageUrl: widget.book.coverPhotoUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned.fill(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: imageWidget(),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget imageWidget() {
    return CachedNetworkImage(
      imageUrl: widget.book.coverPhotoUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  profileImage() {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl:
          "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png",
      placeholder: (context, url) => Image.asset(
        "assets/image-loader.gif",
        fit: BoxFit.fill,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
