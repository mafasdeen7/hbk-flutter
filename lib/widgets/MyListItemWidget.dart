import 'package:flutter/material.dart';

class MyListItemWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onClick;

  MyListItemWidget({this.title, this.subTitle, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2,
        ),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 5.0, color: Theme.of(context).primaryColor),
          ),
        ),
        child: subTitle == null
            ? ListTile(
                title: Text(
                  title,
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: onClick
              )
            : ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(subTitle),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  //Navigator.pushNamed(context, routeName);
                  onClick();
                },
              ),
      ),
    );
  }
}
