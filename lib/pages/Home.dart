import 'package:deadly_timer/components/task_list_item.dart';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/pages/timer_page.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  final List<Task> tmpTasks;

  const HomePage({Key key, this.tmpTasks}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _currentDayTasks = [];
  int _totalDuration = 0;
  List<String> _totalTime = [];
  String hours = "00", minutes =  "00", seconds =  "00";

  @override
  void initState() {
    super.initState();
    _currentDayTasks = widget.tmpTasks;
    if (_currentDayTasks.isNotEmpty) {
      _currentDayTasks.forEach((task){
        DateTime _taskDuration = DateTime.fromMillisecondsSinceEpoch(task.timer);
       _totalDuration += _taskDuration.hour * 60 * 60 + _taskDuration.minute * 60 + _taskDuration.second;
      });
      //Converting the total duration in minutes to seconds
      _totalTime = CommonUtils.getTotalSecondsInHours(_totalDuration);
      if (_totalTime.length == 3) {
        hours = _totalTime[0];
        minutes = _totalTime[1];
        seconds = _totalTime[2];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: CommonUtils.calculateWidth(context, 100),
            height: CommonUtils.calculateHeight(context, 100),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: CommonUtils.appMaterialLinearGradient()),
          ),
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 80, left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Deadly Timer", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30, color: Colors.white)),
//                          InkWell(
//                            onTap: () {
//                              dynamic callbackValue = Navigator.push(context,
//                                  MaterialPageRoute(builder: (context) => TimerPage(currentTask: _currentDayTasks, isTimerStarted: _isTimerStarted)));
//                              if (callbackValue != null)
//                                setState(() {
//                                  _isTimerStarted = false;
//                                });
//                            },
//                            child: Icon(Icons.timer, color: Colors.white),
//                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          "Welcome!",
                          style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Total Time : ",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    " ${hours.toString()}h ${minutes.toString()}m ${seconds.toString()}s",
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Total Tasks : ",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    "${_currentDayTasks.length}",
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
              top: 260,
              child: Card(
                margin: EdgeInsets.only(bottom: 0),
                elevation: 9,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45))),
              )),
          Positioned.fill(
              top: 290,
              child: Column(
                children: <Widget>[
                  Text(
                    "Today",
                    style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 3,
                    width: 43,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
//                        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.greenAccent, Colors.teal]),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  (_currentDayTasks.length > 0)
                      ? Expanded(
                          child: SizedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                color: Colors.black12,
                              ))),
                              margin: EdgeInsets.only(right: 8, left: 8),
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 8),
                                  itemCount: _currentDayTasks.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return TaskComponent(
                                      task: _currentDayTasks[index],
                                      onTap: (val) => Navigator.push(
                                          context, MaterialPageRoute(builder: (BuildContext) => TimerPage(currentTask: _currentDayTasks[index]))),
                                    );
                                  }),
                            ),
                          ),
                        )
                      : Container(),
                ],
              )),
        ],
      ),
    );
  }
}
