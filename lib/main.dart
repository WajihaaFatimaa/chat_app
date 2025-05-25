import 'package:chat_app/chat_list.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/login_screen.dart';
import 'package:chat_app/models/users.dart';
import 'package:chat_app/services/storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? myData = Storage().getUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: myData == null ? LoginScreen() : ChatListScreen(mydata: myData),
      //SignUpScreen(),
      //LoginScreen(), //ChatListScreen(),
    );
  }
}
