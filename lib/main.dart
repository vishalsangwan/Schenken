import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const AppView());
}

Future allImages() async {
  firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref().listAll();
  List<Widget> allImageBox = [];

  for (var ref in result.items) {
    var url = await ref.getDownloadURL();
    allImageBox.add(
      Container(
        padding: const EdgeInsets.all(8),
        child: Image.network(url),
        color: Colors.green[300],
      ),
    );
  }

  return CustomScrollView(
    primary: false,
    slivers: <Widget>[
      SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverGrid.count(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: allImageBox,
        ),
      ),
    ],
  );
}






class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late Future _value;

  @override
  initState() {
    super.initState();
    _value = allImages();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("All Items"),
            ),
            body: FutureBuilder(
                future: _value,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data;
                  } else {
                    return const Text('Empty data');
                  }
                })));
  }
}
