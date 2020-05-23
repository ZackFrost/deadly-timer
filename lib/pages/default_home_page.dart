import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:deadly_timer/model/task.dart';
import 'package:deadly_timer/pages/Home.dart';
import 'package:deadly_timer/pages/Menu.dart';
import 'package:deadly_timer/pages/Tasks.dart';
import 'package:deadly_timer/pages/add_task_page.dart';
import 'package:deadly_timer/utils/common_utils.dart';
import 'package:deadly_timer/utils/database.dart';
import 'package:flutter/material.dart';

class DefaultHomePage extends StatefulWidget {
  const DefaultHomePage({Key key}) : super(key: key);

  @override
  DefaultHomePageState createState() => DefaultHomePageState();
}

class DefaultHomePageState extends State<DefaultHomePage> {
  int _selectedIndex;
  List<Widget> _pages;
  DatabaseHelper databaseInstance;
  List<Task> _allTasks;
  List<Task> _currentDayTasks;
  int _totalDuration = 0;
  bool _isLoading;

  @override
  void initState() {
    _initEverything();
    super.initState();
  }

  void _initEverything(){
    databaseInstance = DatabaseHelper.instance;
    _selectedIndex = 0;
    _pages = [];
    _allTasks = [];
    _currentDayTasks = [];
    _isLoading = false;
    _getAllLocalTasks();
    _initializePages();
  }

  void getTotalDuration() {
    setState(() {
      _allTasks.forEach((task)=> _totalDuration = _totalDuration + task.timer);
    });
  }

  void _getAllLocalTasks() async {
    setState(() {
      _isLoading = true;
    });
    List<Map<String, dynamic>> _locallySavedTasks = await databaseInstance.getAllRows();
    if (_locallySavedTasks != null && _locallySavedTasks.isNotEmpty) {
      _locallySavedTasks.forEach((f) => _allTasks.add(Task.fromJson(f)));
      _allTasks.sort((r1, r2) => r1.priority.compareTo(r2.priority));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _initializePages() {
    _pages = [
      HomePage(
        tmpTasks: _allTasks,
      ),
      TasksPage(
        databaseInstance: databaseInstance,
        allTasks: _allTasks,
        currentDayTasks: _currentDayTasks,
      ),
      MenuPage(),
    ];
  }

  BubbleBottomBarItem _buildBottomNavigationButtons(String iconName, IconData iconData) {
    return BubbleBottomBarItem(
        backgroundColor: Colors.greenAccent,
        icon: Icon(
          iconData,
          color: Colors.teal,
        ),
        activeIcon: Icon(
          iconData,
          color: Colors.greenAccent,
        ),
        title: Text(iconName));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end,
        hasNotch: true,
        hasInk: true,
        inkColor: Colors.black12,
        items: <BubbleBottomBarItem>[
          _buildBottomNavigationButtons("Home", Icons.home),
          _buildBottomNavigationButtons("Tasks", Icons.alarm_on),
          _buildBottomNavigationButtons("Settings", Icons.settings),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Colors.teal, Colors.greenAccent]),
              borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () async {
              String callback = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNotePage(
                            dbHelper: databaseInstance,
                          )));
              if (callback == "refresh")
                setState(() {
                  _getAllLocalTasks();
                });
            },
          )),
      body:   (_isLoading)? Container(
        height: CommonUtils.calculateHeight(context, 100),
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
          ),
        ),
      ) : _pages[_selectedIndex],
    );
  }
}
