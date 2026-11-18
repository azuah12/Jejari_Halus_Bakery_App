import 'package:flutter/material.dart';

import 'screens/order_type_screen.dart';

void main() {
  runApp(const CrumbTechApp());
}

class CrumbTechApp extends StatelessWidget {
  const CrumbTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jejari Halus Bakery',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFFFFAFA),
      ),
      home: const OrderTypeScreen(),
    );
  }
}
