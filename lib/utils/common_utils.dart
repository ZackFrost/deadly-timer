import 'dart:ui';
import 'package:deadly_timer/utils/colors.dart';
import 'package:deadly_timer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonUtils {
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

  static List<String> convertDurationToList(String duration) {
    return duration.toString().split(":");
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

  static LinearGradient appMaterialLinearGradient() => LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.greenAccent, Colors.teal]);

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
