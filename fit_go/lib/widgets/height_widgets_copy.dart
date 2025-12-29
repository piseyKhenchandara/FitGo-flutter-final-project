import 'package:flutter/material.dart';

class HeightWidgetsCopy extends StatefulWidget {
  const HeightWidgetsCopy({
    super.key,
    required this.height,
    required this.onChanged
  });

  final int height;
  final ValueChanged<int> onChanged;

  @override
  State<HeightWidgetsCopy> createState() => _HeightWidgetsCopyState();
}

class _HeightWidgetsCopyState extends State<HeightWidgetsCopy> {
  int defaultHeight = 173;
  static const int minHeight = 140;
  static const int maxHeight = 210;

  late int selectedHeight;

  @override
  void initState() {
    super.initState();
    selectedHeight = widget.height;
  }

  void onAdd(){
    setState(() {
      if(defaultHeight < maxHeight){
      defaultHeight++;
    }
    });
  }

  void onMinus(){
    setState(() {
      if(defaultHeight > minHeight){
      defaultHeight--;
    }
    });
  }

  @override
  Widget build(BuildContext context) {
  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue[600], // background for the selector
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          ElevatedButton(
            onPressed: onMinus,
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.blue,
              size: 28,
            ),
          ),

          const SizedBox(width: 20),

          // Height text
          Text(
            "$defaultHeight cm",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 20),

          // Plus button
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.blue,
              size: 28,
            ),
          ),
        ],
      ),
    ),
  );
}

}
