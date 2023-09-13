import 'package:flutter/material.dart';

class AbsenState extends ChangeNotifier {
  String? checkStatusPegawai;
  String? checkStatusSPPD;
  String? checkStatusDetasering;
  String? checkStatus;
  String? checkShiftM;
  String? koordinat;
  bool? statusCuti;
  String? jarakKantor;
  bool? status;
  String? msg;

  void setAbsenData({
    String? checkStatusPegawai,
    String? checkStatusSPPD,
    String? checkStatusDetasering,
    String? checkStatus,
    String? checkShiftM,
    String? koordinat,
    bool? statusCuti,
    String? jarakKantor,
    bool? status,
    String? msg,
  }) {
    this.checkStatusPegawai = checkStatusPegawai;
    this.checkStatusSPPD = checkStatusSPPD;
    this.checkStatusDetasering = checkStatusDetasering;
    this.checkStatus = checkStatus;
    this.checkShiftM = checkShiftM;
    this.koordinat = koordinat;
    this.statusCuti = statusCuti;
    this.jarakKantor = jarakKantor;
    this.status = status;
    this.msg = msg;

    notifyListeners();
  }
}
