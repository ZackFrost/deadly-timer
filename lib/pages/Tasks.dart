import 'package:deadly_timer/components/task_list_item.dart';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/pages/add_task_page.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> _tasksList = [];
  List<Task> _currentDayTasks = [];
  List<bool> _isSelected = [];
  int count = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeTasks();
  }

  void _refreshPage(bool val){
    setState(() {
      _isLoading = val;
    });
  }

  void _initializeTasks() async{
    _refreshPage(true);
    _tasksList = await CommonUtils.fetchAllLocallySavedTasks();
    if(_tasksList != null && _tasksList.isNotEmpty){
      _tasksList.forEach((task) => _isSelected.add(false));
    }
    _refreshPage(false);
  }

  void _addTaskToCurrentDayList(int index, Task val){
    setState(() {
      _isSelected[index] = !_isSelected[index];
        (_currentDayTasks.any((task) => task.id == val.id))? _currentDayTasks.removeWhere((task) => task.id == val.id) : _currentDayTasks.add(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: (!_isLoading)? SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 90, bottom: 15),
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Tasks", style:  TextStyle(fontWeight: FontWeight.w700, fontSize: 26)),
                    if(_currentDayTasks.length > 0)
                    GestureDetector(
                      onTap: () => CommonUtils.saveCurrentDayTasks(_currentDayTasks),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 13,horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.greenAccent]
                          )
                        ),
                        child: Text(" +Add ${_currentDayTasks.length} Tasks", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  shrinkWrap: true,
                  itemCount: _tasksList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => TaskComponent(
                    task: _tasksList[index],
                    isSelected: _isSelected[index],
                    onTap: (val) async {
                     if(_currentDayTasks.isEmpty){
                       dynamic callback = await CommonUtils.navigateToPageWithResult(context, AddNotePage(task: val, isDelete: true));
                       if (callback == "refresh") _initializeTasks();
                     } else{
                       _addTaskToCurrentDayList(index,val);
                     }
                    },
                    onLongPress: (val) => (_currentDayTasks.isEmpty)? _addTaskToCurrentDayList(index, val) : null,
                  )),
            ],
          ),
        ),
      )  : CommonUtils.genericLoader(context),
    );
  }
}
