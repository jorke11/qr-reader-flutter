import 'dart:async';

import 'package:qr_reader/src/bloc/validator.dart';
import 'package:qr_reader/src/providers/db_provider.dart';

class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._() {
    //obtener los scans de la base de datos
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScan());
  }

  agregarScan(ScanModel scanModel) async {
    await DBProvider.db.nuevoScan(scanModel);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanAll() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
}
