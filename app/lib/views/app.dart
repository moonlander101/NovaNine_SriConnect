import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lanka_connect/theme/colors.dart';
import 'package:lanka_connect/views/home/screens/test1_view.dart';

import 'home/screens/home_view.dart';
import 'home/screens/profile_view.dart';
import 'home/screens/test2_view.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  final _views = const <Widget>[
    HomeView(),
    Test1View(),
    Test1View(),
    BookingView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.shade50,
      body: _views[_selectedIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        children: [
          BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.blue,
            unselectedItemColor: AppColors.black.shade400,
            elevation: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home_2),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.task_square),
                label: 'Submissions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.dollar_circle),
                label: 'x',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.calendar_1),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeView(),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: const BorderRadius.all(Radius.circular(240)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.shade200,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 2),
                height: 55,
                width: 55,
                child: const Icon(
                  Iconsax.category_25,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
