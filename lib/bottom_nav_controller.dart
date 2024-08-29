import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bottom_nav_pages/cart.dart';
import 'bottom_nav_pages/favourite.dart';
import 'bottom_nav_pages/home.dart';
import 'bottom_nav_pages/profile.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  final _pages = [
    const Home(),
    const Favourite(),
    const Cart(),
    const Profile(),
  ];
  var _currentIndex = 0;
  exitApp() {
    SystemNavigator.pop();
  }

  mobileScreen() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 25,
        selectedItemColor: Colors.orange.shade700,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: "Favourite"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Person",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (kDebugMode) {
              print(_currentIndex);
            }
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }

  desktopScreen() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        elevation: 25,
        selectedItemColor: Colors.orange.shade700,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: "Favourite"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Person",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (kDebugMode) {
              print(_currentIndex);
            }
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    showExitAlert() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit this App?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => exitApp(),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showExitAlert();
      },
      child: SafeArea(
        child: screenWidth < 600 ? mobileScreen() : desktopScreen(),
      ),
    );
  }
}
