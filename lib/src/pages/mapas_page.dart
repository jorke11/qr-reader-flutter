import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scans_bloc.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:qr_reader/src/utils/utils.dart';

class MapasPage extends StatelessWidget {
  final scanBlock = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scanBlock.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
        stream: scanBlock.scansStream,
        builder: (context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(
              child: Text("No hay informacion"),
            );
          }

          return ListView.builder(
              itemCount: scans.length,
              itemBuilder: (context, i) => Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direccion) => scanBlock.borrarScan(scans[i].id),
                  child: ListTile(
                    leading: Icon(Icons.map,
                        color: Theme.of(context).primaryColor),
                    title: Text(scans[i].valor),
                    subtitle: Text("${scans[i].id}"),
                    trailing:
                        Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                        onTap: ()=>abrirScan(context,scans[i]),
                  )));
        });
  }
}
