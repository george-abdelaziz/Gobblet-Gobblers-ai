import 'package:ai_project/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/shared/bloc_observer.dart';
import 'package:flutter/material.dart';

import 'layout/gobblet/gobblet.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Gobblet(),
      ),
    );
  }
}
