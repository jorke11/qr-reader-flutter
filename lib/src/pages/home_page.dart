
import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scans_bloc.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:qr_reader/src/pages/direcciones_page.dart';
import 'package:qr_reader/src/pages/mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete_forever), onPressed: () {
            scansBloc.borrarScanAll();
          })
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=>_scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Mapas")),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_drop_down_circle), title: Text("Direcciones")),
      ],
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  Widget _callPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionPage();

      default:
        return MapasPage();
    }
  }

  _scanQR(BuildContext context) async {
  
    //google.com
    //geo:3.7750162893051558,-73.03914442500003
    // var result = await BarcodeScanner.scan();

// print(result.type); // The result type (barcode, cancelled, failed)
    // print(result.rawContent); // The barcode content
    // print(result.format); // The barcode format (as enum)
    // print(result.formatNote);

    String futureString = "https://www.google.com";

    if(futureString!=null){
      final scan = new ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);
      
      // final scan2 = new ScanModel(valor: "geo:3.7750162893051558,-73.03914442500003");
      // scansBloc.agregarScan(scan2);

      

      utils.abrirScan(context,scan);
      
    }

  }
}
