import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

void main() {
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const FractionallySizedBox(
                  heightFactor: 0.5,
                  widthFactor: 0.5,
                  child: WebCam(),
                );
              });
        },
        // tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WebCam extends StatefulWidget {
  const WebCam({Key? key}) : super(key: key);

  @override
  _WebCamState createState() => _WebCamState();
}

class _WebCamState extends State<WebCam> {
  static final html.VideoElement _webcamVideoElement = html.VideoElement();

  @override
  void initState() {
    super.initState();

    // Register a webcam
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('webcamVideoElement',
        (int viewId) {
      getMedia();
      return _webcamVideoElement;
    });
  }

  getMedia() {
    html.window.navigator.mediaDevices!
        .getUserMedia({"video": true}).then((streamHandle) {
      _webcamVideoElement
        ..srcObject = streamHandle
        ..autoplay = true;
    }).catchError((onError) {
      print(onError);
    });
  }

  switchCameraOff() {
    if (_webcamVideoElement.srcObject != null &&
        _webcamVideoElement.srcObject!.active!) {
      var tracks = _webcamVideoElement.srcObject!.getTracks();

      //stopping tracks and setting srcObject to null to switch camera off
      _webcamVideoElement.srcObject = null;

      tracks.forEach((track) {
        track.stop();
      });
    }
  }

  @override
  void dispose() {
    switchCameraOff();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: new HtmlElementView(
            key: UniqueKey(),
            viewType: 'webcamVideoElement',
          )),
          Container(
            child: Column(
              children: [
                RaisedButton(
                  child: Text('Play/Pause'),
                  onPressed: () async {
                    if (_webcamVideoElement.paused) {
                      _webcamVideoElement.play();
                    } else {
                      _webcamVideoElement.pause();
                    }
                  },
                ),
                RaisedButton(
                  child: Text('Switch off'),
                  onPressed: () {
                    switchCameraOff();
                  },
                ),
                RaisedButton(
                  child: Text('Switch on'),
                  onPressed: () {
                    if (_webcamVideoElement.srcObject == null) getMedia();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}