import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:vershenken/display_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref().listAll();

  result.items.forEach((firebase_storage.Reference ref) {
    print('Found file: $ref');
  });

  result.prefixes.forEach((firebase_storage.Reference ref) {
    print('Found directory: $ref');
  });
  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Items"),
          ),
          body: App())));
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Text("Vishal has error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
      
          return gallery;
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Text("vishal");

      },
    );
  }
}

