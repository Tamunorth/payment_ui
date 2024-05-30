import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_ui/pages/details_page.dart';
import 'package:payment_ui/main.dart';
import 'package:payment_ui/pages/home_page.dart';
import 'package:payment_ui/utils.dart';
import 'package:payment_ui/widgets/invoice_item.dart';
import 'package:uicons/uicons.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.controller});
  final CachedVideoPlayerController controller;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pages = [
      HomePage(
        controller: widget.controller,
      ),
      Container(),
      Container(),
    ];
  }

  List pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.square_sharp,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 55,
              child: FloatingActionButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: CircleBorder(),
                elevation: 0,
                onPressed: null,
                child: Icon(
                  Icons.add,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'Schools',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Schools',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        unselectedItemColor: Theme.of(context).primaryColor.withOpacity(0.2),
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
