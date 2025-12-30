import 'package:flutter/material.dart';

class GenderWidgets extends StatelessWidget {
  const GenderWidgets({
    super.key, 
    required this.image, 
    required this.text, 
    required this.color,
    required this.onPressed});

    final VoidCallback onPressed;
    final String image;
    final String text;
    final Color color;


    @override
    Widget build(BuildContext context) {
      return ElevatedButton(
              onPressed: onPressed, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(50),
                shape: CircleBorder()  
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(image, width: 100),
                  SizedBox(height: 10),
                  Text(
                    text, 
                    style: TextStyle(
                      color: color, 
                      fontSize: 30, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
    }
}