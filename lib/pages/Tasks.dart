import 'package:deadly_timer/components/task_list_item.dart';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/pages/add_task_page.dart';
import 'package:deadly_timer/utils/database.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {

  final DatabaseHelper databaseInstance;
  final List<Task> allTasks;
  final List<Task> currentDayTasks;

  const TasksPage({Key key, this.databaseInstance, this.allTasks, this.currentDayTasks}): assert(databaseInstance !=  null), super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  DatabaseHelper databaseInstance;
  List<Task> _tasksList = [];
  List<Task> _currentDayTasks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tasksList = widget.allTasks ?? [];
    if(widget.currentDayTasks != null && widget.currentDayTasks.length > 0)  _currentDayTasks = widget.currentDayTasks;
    databaseInstance = widget.databaseInstance;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 90, bottom: 15),
                alignment: Alignment.topLeft,
                child: Text("Tasks", style:  TextStyle(fontWeight: FontWeight.w700, fontSize: 26),),
              ),
              ListView.builder(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  shrinkWrap: true,
                  itemCount: _tasksList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onTap: () async {
                      String callback = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNotePage(
                                dbHelper: databaseInstance,
                                task: _tasksList[index],
                                isDelete: true,
                              )));
                      if (callback == "refresh")
                        setState(() {
//                        _getLocalNotes();
                        });
                    },
                    onLongPress: (){
                     int value = _currentDayTasks.indexWhere((task) => task.id != _tasksList[index].id);
                     if(value == -1){
                       setState(() {
                         _currentDayTasks.add(_tasksList[index]);
//                         _isSelectionAvailable = true;
                       });
                     }
                    },
                    child: TaskComponent(
                      task: _tasksList[index],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
