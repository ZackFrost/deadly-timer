import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/material.dart';

class TaskComponent extends StatelessWidget {

  final Task task;

  const TaskComponent({this.task});

  @override
  Widget build(BuildContext context) {

    List<String> _time = CommonUtils.convertDurationToList(Duration(minutes: task?.timer)?.toString());
    String hours = (_time != null && _time.length == 1)? "00" : _time[0];
    String minutes = (_time != null && _time.length == 1)? "00" :  _time[1];
    String seconds =  (_time != null && _time.length == 1)? "00" :  _time[2].split(".")[0];
    Color  priorityColor = CommonUtils.getPriorityColor(task?.priority);
    List<Color>  _gradientColors = CommonUtils.getPriorityGradientColors(task?.priority);
    return Container(
      margin: EdgeInsets.only(bottom: 7),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 60,
              height: 11,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: _gradientColors
                  ),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              task?.title ?? " ",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black,),
                              overflow: TextOverflow.ellipsis,
                            ),
//                            Text(
//                              " ${hours}h ${minutes}m ${seconds}s",
//                              style: TextStyle(fontSize: 13,color: Colors.black38),
//                              overflow: TextOverflow.ellipsis,
//                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          task.description ?? " ",
                          style: TextStyle(fontSize: 14,color: Colors.black,),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}