import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskComponent extends StatelessWidget {

  final Task task;
  final bool isSelected;
  final ValueSetter onLongPress;
  final ValueSetter onTap;
  const TaskComponent({this.task, this.isSelected = false, this.onLongPress, this.onTap});

  @override
  Widget build(BuildContext context) {
    DateTime _taskDuration = (task.timer != null)? DateTime.fromMillisecondsSinceEpoch(task.timer) : DateTime(DateTime.now().year);
    List<Color>  _gradientColors = CommonUtils.getPriorityGradientColors(task?.priority);
    return InkWell(
      onTap: () => onTap(task),
      onLongPress: () => (!isSelected)? onLongPress(task) : null,
      child: Container(
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
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: isSelected? Colors.blue : Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                " ${_taskDuration.hour}h ${_taskDuration.minute}m ${_taskDuration.second}s",
                                style: TextStyle(fontSize: 13,color: isSelected? Colors.blue : Colors.black38, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            task.description ?? " ",
                            style: TextStyle(fontSize: 14,color: isSelected? Colors.blue : Colors.black,),
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
      ),
    );
  }
}