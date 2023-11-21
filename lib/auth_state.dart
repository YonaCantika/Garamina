import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  String? costCenter;
  String? costid;
  String? namaUser;
  String? nik;
  String? idPeg;
  String? idLokasi;
  String? lokasi;
  String? status;
  String? foto;
  String? info;
  String? username;
  String? password;

  void setAuthData({
    String? namaUser,
    String? nik,
    String? costCenter,
    String? costid,
    String? idPeg,
    String? idLokasi,
    String? lokasi,
    String? status,
    String? foto,
    String? info,
    String? username,
    String? password
  }) {
    this.namaUser = namaUser;
    this.nik = nik;
    this.costCenter = costCenter;
    this.costid = costid;
    this.idPeg = idPeg;
    this.idLokasi = idLokasi;
    this.lokasi = lokasi;
    this.status = status;
    this.foto = foto;
    this.info = info;
    this.username = username;
    this.password = password;
    notifyListeners();
  }
}
