import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';
import 'core/theme.dart';
import 'features/home/screens/product_details_by_id_screen.dart';
import 'features/splash/screens/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _initLinks();
  }

  Future<void> _initLinks() async {
    // التطبيق كان مقفول وفتح من اللينك
    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      // ننتظر أول frame عشان الـ Navigator يكون جاهز
      WidgetsBinding.instance.addPostFrameCallback((_) => _handle(initial));
    }
    // التطبيق شغال والمستخدم ضغط على لينك
    _sub = _appLinks.uriLinkStream.listen(_handle);
  }

  void _handle(Uri uri) {
    final seg = uri.pathSegments; // ['products', '5']
    if (seg.length == 2 && seg[0] == 'products') {
      final id = int.tryParse(seg[1]);
      if (id == null) return;
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ProductDetailsByIdScreen(productId: id),
        ),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}