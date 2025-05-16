import 'package:flutter/material.dart';

class EmptyTaskView extends StatelessWidget {
  const EmptyTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tidak ada tugas tersedia',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
