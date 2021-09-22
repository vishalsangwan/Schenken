

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe

//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:vershenken/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: HomePageWidget()));
}



  
