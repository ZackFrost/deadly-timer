import 'package:deadly_timer/components/material_add_task_page_button.dart';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:deadly_timer/components/custom_app_bar.dart';
import 'package:deadly_timer/components/time_picker_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddNotePage extends StatefulWidget {
  final Task task;
  final bool isDelete;

  const AddNotePage({this.task, this.isDelete = false});

  @override
  AddNotePageState createState() => AddNotePageState();
}

class AddNotePageState extends State<AddNotePage> {
  final GlobalKey<FormState> _formValidatorKey = GlobalKey<FormState>();
  List<DropdownMenuItem> priorityList = [];
  int _selectedPriorityValue;
  String _title = "", _description = "";
  int _hour = 0, _minute = 0, _seconds = 0;
  final now = DateTime.now();
  DateTime _taskDuration;

  @override
  void initState() {
    super.initState();
    _taskDuration = (widget.task?.timer != null) ? DateTime.fromMillisecondsSinceEpoch(widget.task?.timer) : DateTime(now.year, now.month, now.day, 0, 0, 0);
    priorityList = CommonUtils().getPriorityOptions();
    _selectedPriorityValue = widget.task?.priority;
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _hour = _taskDuration.hour;
    _minute = _taskDuration.minute;
    _seconds = _taskDuration.second;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Add Task",
        startColor: Colors.greenAccent,
        endColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Form(
              key: _formValidatorKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    validator: (val) => (val == null || val.isEmpty) ? 'Please Enter a Note Title' : null,
                    onChanged: (val) => _title = val,
                    decoration: InputDecoration(labelText: 'Enter a title', hintText: 'Please enter a title'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 1,
                    onChanged: (val) => _description = val,
                    decoration: InputDecoration(labelText: 'Enter a description', hintText: 'Please enter a description'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white30,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: TimePicker(
                      hour: _hour,
                      minutes: _minute,
                      seconds: _seconds,
                      onTap: (val) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DatePicker.showTimePicker(context,
                            currentTime: DateTime(now.year, now.month, now.day, _hour, _minute, _seconds), showTitleActions: true, onConfirm: (val) {
                          setState(() {
                            _hour = val.hour;
                            _minute = val.minute;
                            _seconds = val.second;
                          });
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Theme(
                    data: ThemeData(primaryColor: Colors.black87, accentColor: Colors.black54, hintColor: Colors.black26),
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Priority",
                          labelStyle: TextStyle(fontSize: 14.0, color: Colors.black38),
                          contentPadding: EdgeInsets.only(top: 10, left: 10.0, right: 5.0),
                          border: OutlineInputBorder(),
                          filled: false,
                        ),
                        value: _selectedPriorityValue,
                        onChanged: (val) {
                          setState(() {
                            _selectedPriorityValue = val;
                          });
                        },
//                        validator: (value) => (value != null)? null : "Please set priority",
                        items: priorityList,
                      ),
                    ),
                  ),
                  MaterialAddTaskPageButton(
                    title: (widget.task != null) ? "UPDATE" : "SAVE",
                    decoration: (widget.task != null)
                        ? BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Colors.greenAccent, Colors.teal]))
                        : BoxDecoration(),
                    onTap: (val) {
                      if(_formValidatorKey.currentState.validate()){
                        Task _task = Task(
                            title: _title,
                            description: _description,
                            priority: _selectedPriorityValue,
                            timer: DateTime(now.year, now.month, now.year, _hour, _minute, _seconds).millisecondsSinceEpoch);
                        if (widget.task != null) {
                          _task.id = widget.task.id;
                          CommonUtils.saveUpdateOrDeleteTaskLocally(context, _task, isUpdateTask: true);
                        } else {
                          CommonUtils.saveUpdateOrDeleteTaskLocally(context, _task);
                        }
                      }
                    },
                  ),
                  if (widget.isDelete)
                    MaterialAddTaskPageButton(
                      title: "DELETE",
                      onTap: (val) => CommonUtils.saveUpdateOrDeleteTaskLocally(context, Task(id: widget.task.id), isDeleteTask: true),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
