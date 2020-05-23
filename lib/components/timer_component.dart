import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/material.dart';

class TimerComponent extends StatelessWidget {
  final int totalSeconds;
  final double progressIndicatorHeightOrWidth;

  const TimerComponent({Key key, this.totalSeconds = 0, this.progressIndicatorHeightOrWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String hours = '00', minutes = '00', seconds = '00';
    double hourProgress, minuteProgress, secondProgress;
//
    List<String> _totalTime = (totalSeconds != null)? CommonUtils.getTotalSecondsInHours(totalSeconds) : [];
   if(_totalTime.length == 3){
     hours = _totalTime[0];
     minutes = _totalTime[1];
     seconds = _totalTime[2];
     hourProgress = int.parse(_totalTime[0]) / 60;
     minuteProgress = int.parse(_totalTime[1])/60;
     secondProgress = int.parse(_totalTime[2])/60;
   }
    Widget _circularProgressIndicator(double progressValue, String time, String duration, Color progressColor){
      return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: progressIndicatorHeightOrWidth ?? 70,
                height: progressIndicatorHeightOrWidth ?? 70,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black12,
                  strokeWidth: 7,
                  value: progressValue,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(duration, style: TextStyle(color: progressColor,fontSize: 24, fontWeight: FontWeight.w700))),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _circularProgressIndicator(hourProgress, "Hours", hours, Colors.white),
        SizedBox(width: 10),
        _circularProgressIndicator(minuteProgress, "Minutes", minutes, Colors.white),
        SizedBox(width: 10),
        _circularProgressIndicator(secondProgress, "Seconds", seconds, Colors.white),
      ],
    );
  }
}
