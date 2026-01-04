import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[400],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/fitness.png',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onStart,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
              child: Text(
                'Start',
                style: TextStyle(fontSize: 50, color: Colors.blue[400]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
