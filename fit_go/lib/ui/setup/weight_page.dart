import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/appbar.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key, this.height});

  final int? height;

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  int selectedWeight = 73; // default weight (center)
  final int minWeight = 30;
  final int maxWeight = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[400],
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Appbar(),
            ),

            const SizedBox(height: 10),

            const Text(
              'Weight',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 60),

         
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 40,
            ),

            const SizedBox(height: 10),

         
            SizedBox(
              width: double.infinity,
              height: 120,
              child: RotatedBox(
                quarterTurns: -1,
                child: ListWheelScrollView.useDelegate(
                  controller: FixedExtentScrollController(
                    initialItem: selectedWeight - minWeight,
                  ),
                  physics: const FixedExtentScrollPhysics(),
                  itemExtent: 60,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedWeight = minWeight + index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: maxWeight - minWeight + 1,
                    builder: (context, index) {
                      final value = minWeight + index;
                      final isSelected = value == selectedWeight;

                      return RotatedBox(
                        quarterTurns: 1,
                        child: Center(
                          child: Text(
                            value.toString(),
                            style: TextStyle(
                              fontSize: isSelected ? 28 : 20,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Selected weight text
            Text(
              ' kg',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 120,),

            ElevatedButton(
            onPressed: () {
                // Navigate back to the HeightPage using GoRouter
                context.go('/setup/weight_avg',  extra: {
                  'weight': selectedWeight,
                  'height': widget.height,
                });
              },
            child: const Padding(
              padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 50, 
                  color: Colors.blue
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
