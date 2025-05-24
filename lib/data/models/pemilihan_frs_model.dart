import 'package:get/get.dart';

class PemilihanFrsModel {
  String id;
  String nama;
  int sks;
  String dosen;
  String kelas;
  String jadwal;
  RxBool isSelected;

  PemilihanFrsModel({
    required this.id,
    required this.nama,
    required this.sks,
    required this.dosen,
    required this.jadwal,
    required this.kelas,
    bool isSelected = false,
  }) : isSelected = isSelected.obs;
}