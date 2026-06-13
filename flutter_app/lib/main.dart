import 'package:flutter/material.dart';
import 'package:flutter_app/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('prediction_history');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Industrial AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      builder: (context, child) {
        return SafeArea(
          child: child ?? const SizedBox(),
        );
      },
      home: const SplashScreen(),
    );
  }
}