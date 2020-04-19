import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:deadly_timer/components/custom_app_bar.dart';
import 'package:deadly_timer/components/time_picker_component.dart';
import 'package:deadly_timer/utils/constants.dart';
import 'package:deadly_timer/utils/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddNotePage extends StatefulWidget {
  final Task task;
  final ValueSetter<bool> onDelete;
  final DatabaseHelper dbHelper;
  final bool isDelete;

  const AddNotePage({this.onDelete, this.dbHelper, this.task, this.isDelete = false}) : assert(dbHelper != null);

  @override
  AddNotePageState createState() => AddNotePageState(dbHelper: dbHelper);
}

class AddNotePageState extends State<AddNotePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<DropdownMenuItem> priorityList = List();
  List<DropdownMenuItem> timeList = List();
  int _selectedPriorityValue;
  String title, description, time;
  int _hour, _minute;
  int _totalDuration;
  DatabaseHelper dbHelper;

  AddNotePageState({this.dbHelper});

  @override
  void initState() {
    super.initState();
    priorityList = CommonUtils().getPriorityOptions();
    _selectedPriorityValue = widget.task?.priority;
    _titleController.text = widget.task?.title ?? '';
    _descriptionController.text = widget.task?.description ?? '';
    List<String> _duration = (widget.task?.timer != null) ? (widget.task.timer / 60).toString().split(".") : [];
    if (_duration != null && _duration.length == 2) {
      _hour = int.parse(_duration[0]);
      _minute = int.parse(_duration[1].substring(0, 1));
    }
  }

  void _insertTask() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: _titleController.text,
      DatabaseHelper.columnDescription: _descriptionController.text,
      DatabaseHelper.columnPriority: _selectedPriorityValue,
      DatabaseHelper.columnTimer: _totalDuration,
    };
    final id = await dbHelper.insert(row);
    if (id != null) {
      print("Successfully inserted $id");
      Navigator.pop(context, REFRESH_PREVIOUS_SCREEN);
    }
  }

  void _deleteTask(Task task) async {
    await dbHelper.delete(task.id);
    print('Successfully deleted ${task.id}');
    Navigator.pop(context, REFRESH_PREVIOUS_SCREEN);
  }

  void _updateTask(Task task) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId : task.id,
      DatabaseHelper.columnTitle: _titleController.text,
      DatabaseHelper.columnDescription: _descriptionController.text,
      DatabaseHelper.columnPriority: _selectedPriorityValue,
      DatabaseHelper.columnTimer: _totalDuration,
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
    Navigator.pop(context, REFRESH_PREVIOUS_SCREEN);
  }

  Widget _buildMaterialButton(String title, {bool isSaveButton = false}) {
    return Card(
        margin: EdgeInsets.only(top: 23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: GestureDetector(
          child: Container(
            width: 200,
            height: 50,
            decoration: (isSaveButton)
                ? BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Colors.greenAccent, Colors.teal]))
                : BoxDecoration(),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: (isSaveButton) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          onTap: () {
            if (isSaveButton) {
              _totalDuration = (_hour == null && _minute == null) ? 0 : _hour * 60 + _minute;
             (widget.task == null)? _insertTask() : _updateTask(widget.task);
            } else if (widget.task != null) {
              _deleteTask(widget.task);
            }
          },
        ));
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
              key: _key,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    controller: _titleController,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Please Enter a Note Title';
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Enter a title',
                        hintText: 'Please enter a title',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(5),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 1,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Enter a description',
                        hintText: 'Please enter a description',
                        focusColor: Colors.redAccent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                          borderRadius: BorderRadius.circular(5),
                        )),
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
                      seconds: null,
                      onTap: (val) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DatePicker.showTimePicker(context, showTitleActions: true, onConfirm: (val) {
                          DateTime _duration = val;
                          setState(() {
                            _hour = _duration.hour;
                            _minute = _duration.minute;
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
                        items: priorityList,
//                        //TODO if the selected value can be null, then remove the default value of initValue
//                        validator: (value) => validator(value ?? initValue),
//                        onSaved: (val) => onSaved(val),
                      ),
                    ),
                  ),
                  _buildMaterialButton((widget.task != null)? "UPDATE" : "SAVE", isSaveButton: true),
                  if(widget.isDelete)
                    _buildMaterialButton("DELETE")
                ],
              )),
        ),
      ),
    );
  }
}
