import 'package:flutter/material.dart';

class ProductDetailWidget extends StatefulWidget {
  

   const ProductDetailWidget({Key? key, required this.imageUrl}) : super(key: key);
 final String imageUrl;
  @override
  _ProductDetailWidgetState createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: const [],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            color: Color(0xFFEEEEEE),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  'Location',  
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
