import 'package:flutter/material.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

abrirScan(context, ScanModel scanModel) async {
  if (scanModel.tipo == 'http') {
    final url = scanModel.valor;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } else {
    Navigator.pushNamed(context, "mapa",arguments: scanModel);
  }
}
