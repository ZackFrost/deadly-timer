import 'dart:convert';
import 'package:deadly_timer/components/task_list_item.dart';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/pages/timer_page.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:deadly_timer/utils/constants.dart';
import 'package:deadly_timer/utils/filter_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  SharedPreferences preferences;
  List<Task> _currentDayTasks = [];
  List<bool> _isTaskSelected = [];
  List<Task> _deleteTasks = [];
  int _totalDuration = 0;
  List<String> _totalTime = [];
  String hours = "00", minutes = "00", seconds = "00";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCurrentDayTasks();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: print("-----------inactive-----------"); break;
      case AppLifecycleState.paused:print("-----------paused-----------"); break;
      case AppLifecycleState.detached: print("-----------detached-----------"); break;
      case AppLifecycleState.resumed: print("-----------resumed-----------"); break;
    }
  }

  void _initializeFields(){
    _currentDayTasks = [];
    _isTaskSelected = [];
    _deleteTasks = [];
    _totalDuration = 0;
    hours = "00";
    minutes = "00";
    seconds = "00";
  }

  void _initializeCurrentDayTasks() async {
    _initializeFields();
    _showLoader(true);
    preferences = await SharedPreferences.getInstance();
    if (preferences != null) {
      List<String> _tasks = preferences.getStringList(KEY_CURRENT_DAY_TASKS);
      if (_tasks != null && _tasks.isNotEmpty)
        _tasks.forEach((task) {
          _currentDayTasks.add(Task.fromJson(json.decode(task)));
        });
      if (_currentDayTasks.isNotEmpty) {
        _currentDayTasks.forEach((task) {
          _isTaskSelected.add(false);
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
    _showLoader(false);
  }

  void _addTasksToBeDeleted(int index, Task val) {
    setState(() {
      _isTaskSelected[index] = !_isTaskSelected[index];
      (_deleteTasks.any((task) => task.id == val.id)) ? _deleteTasks.removeWhere((task) => task.id == val.id) : _deleteTasks.add(val);
    });
  }

  void _showLoader(bool val){
    setState(() {
      _isLoading = val;
    });
  }

  @override
  Widget build(BuildContext context) {
   if(_currentDayTasks != null) FilterUtils.sortPriorityByHighToLow(_currentDayTasks);
    return Scaffold(
      backgroundColor: Colors.white,
      body: (!_isLoading)
          ? Stack(
              children: <Widget>[
                Container(
                  width: CommonUtils.calculateWidth(context, 100),
                  height: CommonUtils.calculateHeight(context, 100),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: CommonUtils.appMaterialLinearGradient()),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Today",
                              style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            if (_deleteTasks.length > 0)
                              GestureDetector(
                                onTap: () async{
                                 bool _result = await CommonUtils.deleteCurrentDayTasks(_deleteTasks);
                                 if(_result){
                                   _initializeCurrentDayTasks();
                                   Fluttertoast.showToast(msg: "Successfully deleted Tasks");
                                 } else{
                                   Fluttertoast.showToast(msg: "Failed to deleted Tasks");
                                 }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6), gradient: LinearGradient(colors: [Colors.teal, Colors.greenAccent])),
                                  child: Text(
                                    " Delete ${_deleteTasks.length} Tasks",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
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
                                            isSelected: _isTaskSelected[index],
                                            onTap: (val) async {
                                              if (_deleteTasks.isEmpty) {
                                               dynamic callback = await Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) => TimerPage(allTasks: _currentDayTasks ,currentTask: _currentDayTasks[index])));
                                               if(callback == "refresh") _initializeCurrentDayTasks();
                                              } else {
                                                _addTasksToBeDeleted(index, val);
                                              }
                                            },
                                            onLongPress: (val) {
                                              if (_deleteTasks.isEmpty) {
                                                _addTasksToBeDeleted(index, val);
                                              }
                                            },
                                          );
                                        }),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )),
              ],
            )
          : CommonUtils.genericLoader(context),
    );
  }
}
