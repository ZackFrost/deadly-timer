import 'dart:async';
import 'package:deadly_timer/components/task_list_item.dart';
import 'package:deadly_timer/components/timer_component.dart';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/pages/timer_page.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  final List<Task> tmpTasks;

  const HomePage({Key key, this.tmpTasks}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _currentDayTasks = [];
  int _totalDuration = 0;
  Timer _initializeTimer;
  bool _isSelectionAvailable = false;
  bool _isTimerStarted = false;

  @override
  void initState() {
    super.initState();
    _currentDayTasks = widget.tmpTasks;
    if (_currentDayTasks.isNotEmpty) {
//      _currentDayTasks.forEach((task) => _totalDuration = _totalDuration + task.timer);
      _totalDuration = (_currentDayTasks.length > 0)? (_currentDayTasks[0].timer * 60).toInt() : 0;
    }
  }

  void _startTimer() {
    setState(() {
      (!_isTimerStarted) ? _isTimerStarted = true : _isTimerStarted = false;
    });
    Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(() {
        if (_totalDuration < 1 || !_isTimerStarted) {
          timer.cancel();
        } else {
          _totalDuration = _totalDuration - 1;
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_isTimerStarted){
          return false;
        } else{
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 90),
              child: Text(
                "Deadly Timer",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                "Welcome!",
                style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            TimerComponent(
              totalDuration: _totalDuration,
              isTimerStarted: _isTimerStarted,
              onTap: (val) {
//                _startTimer()
              return Navigator.push(context, MaterialPageRoute(
                builder: (context) => TimerPage(

                )
              ));
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 23),
              child: Text("Today's Tasks", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 26)),
            ),
            SizedBox(height: 20,),
            (_currentDayTasks.length > 0)
                ? Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: _currentDayTasks.length,
                        itemBuilder: (context, index) {
                          return TaskComponent(
                            task: _currentDayTasks[index],
                          );
                        }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
