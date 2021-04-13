import 'package:flutter/material.dart';

class TabBoxItem extends StatelessWidget {
  final String title;
  final int tabIndex, selectedTab;
  final Function onTap;

  TabBoxItem({
    @required this.title,
    @required this.tabIndex,
    @required this.selectedTab,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: tabIndex == selectedTab
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            color: const Color(0xff4c3f58),
          ),
        ),
      ),
    );
  }
}
