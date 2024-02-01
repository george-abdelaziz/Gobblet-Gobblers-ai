import 'package:ai_project/shared/bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() {
  // Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
