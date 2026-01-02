import 'package:flutter/material.dart';

class Snackbar extends StatelessWidget {
  const Snackbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a gender')),
                    );
    );
  }
}