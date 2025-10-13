import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'screens/home/home_screen.dart';
import 'screens/inbound/inbound_list_screen.dart';
import 'screens/outbound/outbound_list_screen.dart';
import 'screens/profile/profile_screen.dart';

class InventoryApp extends StatefulWidget {
  const InventoryApp({super.key});

  @override
  State<InventoryApp> createState() => _InventoryAppState();
}

class _InventoryAppState extends State<InventoryApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    InboundListScreen(),
    OutboundListScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InventoryFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: kPrimaryColor,
          secondary: kPrimaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: false,
      ),
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.move_to_inbox_outlined),
              label: 'Inbound',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              label: 'Outbound',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
