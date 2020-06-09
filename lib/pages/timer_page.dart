import 'dart:math';
import 'package:deadly_timer/components/timer_component.dart';
import 'package:deadly_timer/components/wave_animation.dart';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  final Task currentTask;
  final List<Task> allTasks;

  const TimerPage({Key key, @required this.currentTask, this.allTasks})
      : assert(currentTask != null),
        super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  bool _isTimerStarted;
  int _seconds = 0;
  AnimationController _controller;
  int _currentTime = 0;
  DateTime taskDuration;
  Task _task;
  List<Task> _allTasks = [];

  @override
  void initState() {
    super.initState();
    _task = widget.currentTask;
    _allTasks = widget.allTasks;
    if (_task?.timer != null) taskDuration = DateTime.fromMillisecondsSinceEpoch(_task.timer);
    _seconds = (taskDuration.hour * 60 * 60) + (taskDuration.minute * 60) + taskDuration.second;
    _isTimerStarted = false;
    _controller = AnimationController(vsync: this, duration: Duration(seconds: _seconds));
  }

//  void _startTimer() {
//    setState(() {
//      (!_isTimerStarted) ? _isTimerStarted = true : _isTimerStarted = false;
//    });
//    Timer.periodic(
//        Duration(seconds: 1),
//            (Timer timer) => setState(() {
//          if (_seconds < 1 || !_isTimerStarted) {
//            timer.cancel() ;
//          } else {
//            _seconds = _seconds - 1;
//          }
//        })
//    );
//  }
  void timerString() {
    Duration duration = (_controller.value != 0) ? _controller.duration * _controller.value : Duration(seconds: _seconds);
    _currentTime = duration.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller.isAnimating) {
          return false;
        } else {
          final duration = Duration(seconds: _currentTime).toString();
          List<int> _totalTime = CommonUtils.convertDurationToList(duration);
          DateTime taskTime = DateTime.fromMillisecondsSinceEpoch(_task.timer);
          int remainingTime = DateTime(taskTime.year, taskTime.month, taskTime.day, _totalTime[0], _totalTime[1], _totalTime[2]).millisecondsSinceEpoch;
          int index = _allTasks.indexWhere((task) => task.id == _task.id);
          if(index != -1) _allTasks[index] = Task(id: _task.id, title: _task.title, description: _task.description, priority: _task.priority, timer: remainingTime);
          CommonUtils.updateCurrentDayTasks(_allTasks);
          _controller.dispose();
          Navigator.pop(context, "refresh");
        }
        return false;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          WaveAnimation(
            numberOfWaves: 4,
            waveHeight: [180, 120, 220, 300],
            waveSpeed: [1.0, 0.9, 1.2, 1.4],
            waveOffset: [0.0, pi, pi / 2, pi / 3],
          ),
          Positioned(
              top: 200,
              width: CommonUtils.calculateWidth(context, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              timerString();
                              return TimerComponent(progressIndicatorHeightOrWidth: 80, totalSeconds: _currentTime);
                            }),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      SizedBox(height: 60),
                      InkWell(
                        child: (!_isTimerStarted)
                            ? Icon(
                                Icons.play_circle_outline,
                                size: 60,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.pause_circle_outline,
                                size: 60,
                                color: Colors.white,
                              ),
                        onTap: () {
                          if (_controller.isAnimating) {
                            _controller.stop();
                            setState(() {
                              _isTimerStarted = false;
                            });
                          } else {
                            _controller.reverse(from: (_controller.value == 0) ? 1.0 : _controller.value);
                            setState(() {
                              _isTimerStarted = true;
                            });
                          }
                        },
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 80, left: 20, right: 10),
                      child: Text(
                        "${_task.title}",
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 15, left: 20, right: 10),
                      child: Text(
                        "Task : ${_task.description ?? ""}",
                        style: TextStyle(color: Colors.white70, fontSize: 17, fontWeight: FontWeight.w500),
                      )),
                ],
              )),
//          Positioned(
//            top: 150,
//            child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 10),
//                child: Text("${widget.currentTask.title.toUpperCase()}" , style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),)),
//          ),
        ]),
      ),
    );
  }
}
