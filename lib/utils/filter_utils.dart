
import 'package:deadly_timer/model/task.dart';

class FilterUtils{

  static void sortPriorityByHighToLow(List<Task> tasks) => tasks.sort((a,b)=> a.priority.compareTo(b.priority));

  static void sortPriorityByLowToHigh(List<Task> tasks) => tasks.sort((a,b)=> b.priority.compareTo(a.priority));

  static void sortTitleByAscending(List<Task> tasks) => tasks.sort((a,b)=> a.title.toLowerCase().compareTo(b.title.toLowerCase()));

  static void sortTitleByDescending(List<Task> tasks) => tasks.sort((a,b)=> b.title.toLowerCase().compareTo(a.title.toLowerCase()));

  static void sortDurationByLowToHigh(List<Task> tasks) => tasks.sort((a,b)=> a.timer.compareTo(b.timer));

  static void sortDurationByHighToLow(List<Task> tasks) => tasks.sort((a,b)=> b.timer.compareTo(a.timer));




}