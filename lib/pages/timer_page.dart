import 'package:deadly_timer/components/timer_component.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: CommonUtils.calculateHeight(context, 100),
        width: CommonUtils.calculateWidth(context, 100),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ Colors.greenAccent, Colors.teal]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TimerComponent(
              onTap: (val) => null,
            ),
          ],
        ),
      ),
    );
  }
}
