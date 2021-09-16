import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref().listAll();
  List<Widget> allImageBox = [];
  for (var ref in result.items) {
    var URL = await ref.getDownloadURL();
    
    allImageBox.add(
      Container(
        padding: const EdgeInsets.all(8),
        child:  Image.network(URL),
        color: Colors.green[300],
      ),
    );
  }



  runApp(MaterialApp(
      home: Scaffold(
    appBar: AppBar(
      title: const Text("All Items"),
    ),
    body: CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: allImageBox,
          ),
        ),
      ],
    )

    )
  )
  );
}

