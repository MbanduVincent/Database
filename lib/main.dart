import 'package:flutter/material.dart';
import 'authentications/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        
          primarySwatch: Colors.blue,
        ),
        routes: {
          'HOME': (BuildContext context) => const Homepage(),
          'login': (BuildContext context) => const LoginScreen(),
        },
        home: const LoginScreen());
  }
}
