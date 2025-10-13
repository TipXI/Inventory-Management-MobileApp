import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/inbound/inbound_list_screen.dart';
import 'screens/outbound/outbound_list_screen.dart';
import 'screens/scan/scan_product_screen.dart';
import 'screens/profile/profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
  '/inbound': (context) => const InboundListScreen(),
  '/outbound': (context) => const OutboundListScreen(),
  '/scan': (context) => const ScanProductScreen(),
  '/profile': (context) => const ProfileScreen(),
};
