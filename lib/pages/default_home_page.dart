import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:deadly_timer/pages/Home.dart';
import 'package:deadly_timer/pages/Menu.dart';
import 'package:deadly_timer/pages/Tasks.dart';
import 'package:deadly_timer/pages/add_task_page.dart';
import 'package:flutter/material.dart';

class DefaultHomePage extends StatefulWidget {
  const DefaultHomePage({Key key}) : super(key: key);

  @override
  DefaultHomePageState createState() => DefaultHomePageState();
}

class DefaultHomePageState extends State<DefaultHomePage> {
  int _selectedIndex;
  List<Widget> _pages;

  @override
  void initState() {
    _initEverything();
    super.initState();
  }

  void _initEverything(){
    _selectedIndex = 0;
    _pages = [];
    _initializePages();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _initializePages() {
    _pages = [
      HomePage(),
      TasksPage(),
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage())),
          )),
      body: _pages[_selectedIndex],
    );
  }
}
