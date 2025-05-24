import 'package:flutter/material.dart';

class FrsModel {
  final String namaMatakuliah;
  final String status;
  final String pengajar;
  final String waktu;
  final String kelas;
  final Color statusColor;

  FrsModel({
    required this.namaMatakuliah,
    required this.status,
    required this.pengajar,
    required this.waktu,
    required this.kelas,
    this.statusColor = const Color.fromARGB(255, 183, 40, 40),
  });
}