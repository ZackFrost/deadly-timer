import 'dart:convert';
import 'dart:ui';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/utils/colors.dart';
import 'package:deadly_timer/utils/constants.dart';
import 'package:deadly_timer/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtils {

  static Future<SharedPreferences> getSharedPreferences() async => await SharedPreferences.getInstance();

  static DatabaseHelper getDatabaseInstance() => DatabaseHelper.instance;

  static Color getPriorityColor(int number) {
    Color _color;
    switch (number) {
      case PRIORITY_HIGH:
        _color = Colors.red;
        break;
      case PRIORITY_MEDIUM:
        _color = Colors.green;
        break;
      case PRIORITY_LOW:
        _color = Colors.indigo;
        break;
      default:
        _color = Colors.grey;
        break;
    }
    return _color;
  }

  static List<Color> getPriorityGradientColors(int number) {
    List<Color> _color = [];
    switch (number) {
      case PRIORITY_HIGH:
        _color.add(priorityHighStartColor);
        _color.add(priorityHighEndColor);
        break;
      case PRIORITY_MEDIUM:
        _color.add(priorityMediumStartColor);
        _color.add(priorityMediumEndColor);
        break;
      case PRIORITY_LOW:
        _color.add(priorityLowStartColor);
        _color.add(priorityLowEndColor);
        break;
      default:
        _color.add(Colors.black26);
        _color.add(Colors.black26);
        break;
    }
    return _color;
  }

  static Future<List<Task>> fetchAllLocallySavedTasks() async {
    DatabaseHelper databaseInstance = getDatabaseInstance();
    List<Task> _allTasks = [];
    List<Map<String, dynamic>> _localTasks = await databaseInstance.getAllRows();
    if (_localTasks != null && _localTasks.isNotEmpty) {
      _localTasks.forEach((task) => _allTasks.add(Task.fromJson(task)));
    }
    return _allTasks;
  }

  static List<String> encodeTasks(List<Task> decodedTasks){
    List<String> _encodedTask = [];
    if(decodedTasks != null && decodedTasks.isNotEmpty)
      decodedTasks.forEach((task) => _encodedTask.add(json.encode(task)));
    return _encodedTask;
  }

  static List<Task> decodeTasks(List<String> encodedTasks){
    List<Task> _decodedTask = [];
    if(encodedTasks != null && encodedTasks.isNotEmpty)
      encodedTasks.forEach((task) => _decodedTask.add(Task.fromJson(json.decode(task))));
    return _decodedTask;
  }

  static List<String> getCurrentLocalTasks(SharedPreferences preferences) => preferences.getStringList(KEY_CURRENT_DAY_TASKS) ?? [];

  static Future<bool> deleteCurrentDayTasks(List<Task> tasksToDelete) async{
    bool result;
    SharedPreferences preferences = await getSharedPreferences();
    List<Task> _localCurrentDayTasks = decodeTasks(getCurrentLocalTasks(preferences));
    if(_localCurrentDayTasks != null && _localCurrentDayTasks.isNotEmpty && tasksToDelete != null && tasksToDelete.isNotEmpty){
      tasksToDelete.forEach((deleteTask){

        int index = _localCurrentDayTasks.indexWhere((localTask) => localTask.id == deleteTask.id);
        if(index != -1) _localCurrentDayTasks.removeAt(index);
      });
      result = await preferences.setStringList(KEY_CURRENT_DAY_TASKS, encodeTasks(_localCurrentDayTasks));
    }
    return result;
  }

  static void updateCurrentDayTasks(List<Task> currentTasks) async{
    SharedPreferences preferences = await getSharedPreferences();
    bool result = await preferences.setStringList(KEY_CURRENT_DAY_TASKS, encodeTasks(currentTasks));
    print(result);
  }

  static void saveCurrentDayTasks(List<Task> currentTasks) async {
    SharedPreferences preferences = await getSharedPreferences();
    List<String> _localCurrentDayTasks = getCurrentLocalTasks(preferences);
    _localCurrentDayTasks.addAll(encodeTasks(currentTasks));
    bool result = await preferences.setStringList(KEY_CURRENT_DAY_TASKS, _localCurrentDayTasks);
    print(result);
  }

  static Future<dynamic> navigateToPageWithResult( BuildContext context, Widget page) async =>
      await Navigator.push(context, MaterialPageRoute(builder: (context) => page));

  static void navigateToPage(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (context) => page));

  static void saveUpdateOrDeleteTaskLocally(BuildContext context, Task task, {bool isUpdateTask = false, bool isDeleteTask = false, bool popScreen = true}) async {
    int result;
    String message = "";
    DatabaseHelper databaseHelper = getDatabaseInstance();
    if (!isDeleteTask) {
      Map<String, dynamic> row = {
        if (isUpdateTask) DatabaseHelper.columnId: task.id,
        DatabaseHelper.columnTitle: task.title,
        DatabaseHelper.columnDescription: task.description,
        DatabaseHelper.columnPriority: task.priority,
        DatabaseHelper.columnTimer: task.timer,
      };
      result = (isUpdateTask) ? await databaseHelper.update(row) : await databaseHelper.insert(row);
      message = isUpdateTask ? "updated" : "inserted";
    } else {
      result = await databaseHelper.delete(task.id);
      message = "deleted";
    }
    if (result != null) {
      Fluttertoast.showToast(msg: "Successfully $message");
      if(popScreen) Navigator.pop(context, REFRESH_PREVIOUS_SCREEN);
    }
  }

  static Widget genericLoader(BuildContext context) => Container(
    height: CommonUtils.calculateHeight(context, 100),
    color: Colors.white, child: Center(child: CircularProgressIndicator()),
  );

  static Future<List<Task>> fetchCurrentDayTasks() async {
    SharedPreferences preferences = await getSharedPreferences();
    List<String> _locallySavedTasks = [];
    List<Task> _currentDayTasks = [];
    if (preferences != null) {
      _locallySavedTasks = preferences.getStringList(KEY_CURRENT_DAY_TASKS);
      if (_locallySavedTasks != null && _locallySavedTasks.isNotEmpty) {
        _locallySavedTasks.forEach((task) => _currentDayTasks.add(Task.fromJson(json.decode(task))));
      }
    }
    return _currentDayTasks;
  }

  static int stringToInteger(String val) => int.parse(val);

  static List<int> convertDurationToList(String duration) {
    List<String> _tmp = duration.toString().split(":");
    if (_tmp != null && _tmp.length == 3) {
      _tmp[2] = _tmp[2].split(".")[0];
    }
    List<int> _tmpIntegerList = [];
    _tmp.forEach((val) {
      _tmpIntegerList.add(stringToInteger(val));
    });
    return _tmpIntegerList;
  }

  List<DropdownMenuItem> getPriorityOptions() => [
        _buildPriorityMenuItem(PRIORITY_HIGH, "High"),
        _buildPriorityMenuItem(PRIORITY_MEDIUM, "Medium"),
        _buildPriorityMenuItem(PRIORITY_LOW, "Low"),
      ];

  DropdownMenuItem _buildPriorityMenuItem(int priority, String text) {
    return DropdownMenuItem(
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              width: 8.0,
              height: 16.0,
              decoration:
                  BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: getPriorityGradientColors(priority))),
            ),
            Text(text),
          ],
        ),
        value: priority);
  }

  static LinearGradient appMaterialLinearGradient() =>
      LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.greenAccent, Colors.teal]);

  static List<String> getTotalSecondsInHours(int totalDurationInSeconds) {
    String hours = '', minutes = '', seconds = '';
    List<String> _totalTime = Duration(seconds: totalDurationInSeconds).toString().split(":");
    if (_totalTime.length == 3) {
      hours = (_totalTime[0].length == 1) ? ('0' + _totalTime[0]) : _totalTime[0];
      minutes = (_totalTime[1].length == 1) ? ('0' + _totalTime[1]) : _totalTime[1];
      seconds = (_totalTime[2].length == 1) ? ('0' + (_totalTime[2].split('.')[0])) : _totalTime[2].split('.')[0];
    }
    return [hours, minutes, seconds];
  }

  static double calculateWidth(BuildContext context, double percentage) => (MediaQuery.of(context).size.width) * percentage / 100;

  static double calculateHeight(BuildContext context, double percentage) => (MediaQuery.of(context).size.height) * percentage / 100;

  static void setStatusBarIconAndColor() => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, // status bar color
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light));
}
