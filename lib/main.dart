import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'chat_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
        initialRoute: HomePage.id,
        routes: {
          LoginPage.id: (context) => LoginPage(),
          HomePage.id: (context) => HomePage(),
          ChatPage.id: (context) => ChatPage(),

        }
    );
  }
}