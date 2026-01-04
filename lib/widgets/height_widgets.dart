import 'package:flutter/material.dart';

class HeightWidgets extends StatefulWidget {
  const HeightWidgets({
    super.key,
    required this.height,
    required this.onChanged,
  });

  final int height; // current selected height
  final ValueChanged<int> onChanged;

  static const double itemExtent = 40;
  static const int minHeight = 140;
  static const int maxHeight = 210;

  @override
  State<HeightWidgets> createState() => _HeightWidgetsState();
}

class _HeightWidgetsState extends State<HeightWidgets> {
  late FixedExtentScrollController heightController;

  @override
  void initState() {
    super.initState();
    heightController = FixedExtentScrollController(
      initialItem: widget.height - HeightWidgets.minHeight,
    );
  }

  @override
  void didUpdateWidget(HeightWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.height != widget.height) {
      heightController.jumpToItem(widget.height - HeightWidgets.minHeight);
    }
  }

  @override
  void dispose() {
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // fixed height for the picker
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// CENTER INDICATOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 80),
            ],
          ),

          ////Choose height
          Center(
            child: ListView(
              controller: heightController,
              physics: FixedExtentScrollPhysics(),
            ),
          ),
          
          

          // WHEEL
          Positioned.fill( // constrain ListWheelScrollView
            child: Center(
              child: ListWheelScrollView.useDelegate(
                controller: heightController,
                itemExtent: HeightWidgets.itemExtent,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  widget.onChanged(HeightWidgets.minHeight + index);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount:
                      HeightWidgets.maxHeight - HeightWidgets.minHeight + 1,
                  builder: (context, index) {
                    final value = HeightWidgets.minHeight + index;
                    final isSelected = value == widget.height;

                    return Center(
                      child: Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: isSelected ? 30 : 20,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              // ignore: deprecated_member_use
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
