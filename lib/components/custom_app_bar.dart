import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;
  final bool backButtonEnabled;
  final BuildContext context;
  final double height;
  final BorderRadius borderRadius;
  final Color startColor;
  final Color endColor;
  final Widget customWidget;

  @override
  final Size preferredSize;

  CustomAppBar(
      {Key key,
      this.title,
      this.onPressed,
      this.onTitleTapped,
      this.child,
      this.backButtonEnabled = false,
      this.context,
      this.height = 90,
      this.borderRadius,
      this.startColor = Colors.white,
      this.endColor  = Colors.white, this.customWidget,})
      : preferredSize = Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            margin: (backButtonEnabled) ? const EdgeInsets.only(left: 50, bottom: 18) : const EdgeInsets.only(left: 20, bottom: 18),
            child: Align(
                alignment: Alignment.bottomCenter, child: Text(title ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)))),
        if (backButtonEnabled)
          Positioned(
            top: 40,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 26,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (context != null) Navigator.pop(this.context);
                }),
          ),
        if(customWidget != null)
          Positioned(
            top: 200,
            right: CommonUtils.calculateWidth(context, 30),
            child: customWidget,
          ),
      ],
    );
  }
}
