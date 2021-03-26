import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final mapController = new MapController();

  String tipoMapa = "streets";

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Coordenadas"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                mapController.move(scan.getLatLng(), 7);
              })
        ],
      ),
      body: _crearFlutterMap(context, scan),
      floatingActionButton: _crearBotonFLotante(context),
    );
  }

  Widget _crearFlutterMap(context, ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(center: scan.getLatLng(), zoom: 7),
      layers: [_crearMap(), _crearMarcadores(context, scan)],
    );
  }

  _crearMap() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1Ijoiam9ya2UxMSIsImEiOiJjazlmajM5cDgwZGo3M2VudWhidG03aHBpIn0.-R_TmRIS6Krr84PYVixk9Q',
          'id': 'mapbox.$tipoMapa'
          //dark,light,outdoors,satellite
        });
  }

  _crearMarcadores(context, ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100,
          height: 100,
          point: scan.getLatLng(),
          builder: (context) => Container(
                child: Icon(Icons.location_on,
                    size: 70, color: Theme.of(context).primaryColor),
              ))
    ]);
  }

  Widget _crearBotonFLotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        //dark,light,outdoors,satellite,streets
        if (tipoMapa == 'streets') {
          tipoMapa = 'dark';
        } else if (tipoMapa == 'dark') {
          tipoMapa = 'light';
        } else if (tipoMapa == 'light') {
          tipoMapa = 'satellite';
        } else{
          tipoMapa = 'streets';
        }
        print(tipoMapa);
        setState(() {});
      },
    );
  }
}
