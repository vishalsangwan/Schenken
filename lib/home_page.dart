

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vershenken/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  Future allImages() async {
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref().listAll();
    List allURl = [];
    for (var ref in result.items) {
      var url = await ref.getDownloadURL();
      allURl.add(url);
    }
    return allURl;
  }

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  
  late File _imageFile;
  void _openCamera(BuildContext context) async {
  final pickedFile = await ImagePicker().getImage(
    source: ImageSource.camera,
  );
  _imageFile =  File(pickedFile!.path);
    await firebase_storage.FirebaseStorage.instance
        .ref('/fromcamera.png')
        .putFile(_imageFile);
setState(() {
  _value=widget.allImages();
});

}

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future _value;

  @override
  initState() {
    super.initState();
    _value = widget.allImages();
  }

  @override
  Widget build(BuildContext context) {
    var allchildren = <Widget>[];
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Vershenken'),
        actions: const [],
        centerTitle: true,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _openCamera(context);
        },
        icon: const Icon(
          Icons.add_a_photo_outlined,
        ),
        elevation: 8,
        label: const Text(
          'Add Picture',
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _value,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                for (var i in snapshot.data) {
                  allchildren.add(Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailWidget(
                                imageUrl: i,
                              ),
                            ),
                          );
                        },
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          Expanded(
                            child: Image.network(
                              i,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          const Text(
                            'Location',
                          ),
                        ]),
                      )));
                }
        
                
                return GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    scrollDirection: Axis.vertical,
                    children: allchildren);
              } else {
                return const Text('Empty data');
              }
            }),
      ),
    );
  }
}



