import 'package:flutter/material.dart';

class TimerComponent extends StatelessWidget {
  
  final ValueSetter<bool> onTap;
  final bool isTimerStarted;
  final int totalDuration;

  const TimerComponent({Key key, this.onTap, this.isTimerStarted = false, this.totalDuration = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String hours = '', minutes = '', seconds = '';
    double hourProgress, minuteProgress, secondProgress;
    List<String> _totalTime = Duration(seconds: totalDuration).toString().split(":");
   if(_totalTime.length == 3){
     hours = (_totalTime[0].length == 1)? ('0' + _totalTime[0]) : _totalTime[0];
     minutes = (_totalTime[1].length == 1)? ('0' + _totalTime[1]) : _totalTime[1];
    seconds = (_totalTime[2].length == 1)? ('0' + (_totalTime[2].split('.')[0])) : _totalTime[2].split('.')[0];
     hourProgress = int.parse(hours) / 60;
     minuteProgress = int.parse(minutes)/60;
     secondProgress = int.parse(seconds)/60;
   }


    Widget _circularProgressIndicator(double progressValue, String time, String duration, Color progressColor){
      return  Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black12,
                  strokeWidth: 7,
                  value: progressValue,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              Positioned(
                top: 23,
                left: 20,
                child: Text(duration, style: TextStyle(color: progressColor,fontSize: 24, fontWeight: FontWeight.w700),),
              )
            ],
          ),
          SizedBox(height: 12,),
          Text(
            time,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,fontSize: 17),
          )
        ],
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.greenAccent]
        )
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _circularProgressIndicator(hourProgress, "Hours", hours, Colors.white),
              SizedBox(width: 10),
              _circularProgressIndicator(minuteProgress, "Minutes", minutes, Colors.white),
              SizedBox(width: 10),
              _circularProgressIndicator(secondProgress, "Seconds", seconds, Colors.white),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            child: isTimerStarted ? Icon(
              Icons.pause_circle_outline,
              size: 40,
              color: Colors.white,
            )  : Icon(
              Icons.play_circle_outline,
              size: 40,
              color: Colors.white,
            ),
            onTap: () => onTap(true),
          )
        ],
      ),
    );
  }
}
