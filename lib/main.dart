import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_10/screen/splash.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCBTVN_xFg6PfGjzG0rmrSEpgu-z1bWkLQ",
            authDomain: "student-list-2049e.firebaseapp.com",
            projectId: "student-list-2049e",
            storageBucket: "student-list-2049e.appspot.com",
            messagingSenderId: "1072190240094",
            appId: "1:1072190240094:web:ad2a7c69147383223acbcf",
            measurementId: "G-HPR8TN4LKE"));
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: const splashScreen(),
    );
  }
}
