import 'package:flutter/material.dart';
import 'explore.dart';
import 'mytrip.dart';
import 'chat.dart';
import 'profile.dart';

/// ================= MAIN CONTAINER =================

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ExploreScreen(),
    const MyTripsPage(),
    const ChatScreen(),
    const ProductCatalogPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00D1B2),
        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: "Explore",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on),
            label: "My Trips",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: "Chat",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: "Products",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

/// ================= PRODUCT PAGE =================

class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Products comming soon..."),
        centerTitle: true,
      ),

      body: const Center(
        child: Text("Product Catalog Content comming soon..."),
      ),
    );
  }
}