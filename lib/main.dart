import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notsapp/cubit/notes_cubit.dart';
import 'package:notsapp/screens/bottomnavescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesCubit()..createDataBase(),
          ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  BottomNavBar(),
      ),
    );
  }
}

