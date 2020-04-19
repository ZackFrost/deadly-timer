import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {

  final ValueSetter<bool> onTap;
  final int hour;
  final int minutes;
  final int seconds;

  TimePicker({this.onTap, this.hour, this.minutes, this.seconds});

  Widget _timeComponent(int time, String title){
    bool _isNotNull = time is int;
    return Column(
      children: <Widget>[
        Text( _isNotNull? "$time" : "00", style: TextStyle(fontSize: 45,color: Colors.black54,fontWeight: FontWeight.w700)),
        Text(title, style: TextStyle(fontSize: 14,color: Colors.black54)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 45),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _timeComponent(hour,"HOURS"),
                _timeComponent(minutes,"MINUTES"),
                _timeComponent(seconds,"SECONDS"),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 4,
              child: GestureDetector(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "Choose Timer",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                onTap: () => onTap(true),
              ),
            ),
          ],
        )
    );
  }
}

