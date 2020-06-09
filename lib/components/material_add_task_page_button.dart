import 'package:flutter/material.dart';

class MaterialAddTaskPageButton extends StatelessWidget {
  final String title;
  final ValueSetter onTap;
  final BoxDecoration decoration;
  final Color textColor;

  const MaterialAddTaskPageButton({Key key, this.onTap, this.title = "", this.decoration, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(top: 23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: GestureDetector(
          child: Container(
            width: 200,
            height: 50,
            decoration: decoration,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          onTap: () => onTap(true),
        ));
  }
}
