import 'package:fit_go/data/avg_weight.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class WeightAvgPage extends StatefulWidget {
  const WeightAvgPage({super.key, this.height, this.weight});

  final int? height;
  final int? weight;

  @override
  State<WeightAvgPage> createState() => _WeightAvgPageState();
}

class _WeightAvgPageState extends State<WeightAvgPage> {
  double bmi = 0;
  AvgWeight selectedAvgWeight = avgList[0];
  Set<int> selectedChoices = {};


  final List<Map<String, dynamic>> mcqChoices = [
    {'text': 'Arms', 'value': 'arms'},
    {'text': 'Legs', 'value': 'legs'},
    {'text': 'Chest', 'value': 'chest'},
    {'text': 'Back', 'value': 'back'},
    {'text': 'Neck', 'value': 'neck'},
    {'text': 'Glute', 'value': 'glute'},
    {'text': 'Shoulder', 'value': 'shoulder'},
    {'text': 'Abs', 'value': 'abs'},
  ];

  @override
  void initState() {
    super.initState();
    calculate();
  }

  void calculate() {
    if (widget.weight != null && widget.height != null) {
      final heightInMeters = widget.height! / 100;
      bmi = widget.weight! / (heightInMeters * heightInMeters);
      compareWithAverage();
    }
  }

  void compareWithAverage() {
    for (int i = 0; i < avgList.length; i++) {
      if (i == avgList.length - 1 || bmi < avgList[i].avgWeight) {
        selectedAvgWeight = avgList[i];
        break;
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      color: Colors.blue[400],
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: Appbar(),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      const Text(
                        "Weight Average",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
          
                      const SizedBox(height: 20),
          
                      // BMI Value
                      Text(
                        bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: selectedAvgWeight.color,
                        ),
                      ),
                      Text(
                        selectedAvgWeight.comment,
                        style: TextStyle(color: selectedAvgWeight.color, fontSize: 28),
                      ),
          
                      const SizedBox(height: 30),
          
                      // Choose option
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Choose your option",
                          style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
          
                      const SizedBox(height: 15),
          
                      // Options (checkbox style)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: mcqChoices.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                        ),
                        itemBuilder: (context, index) {
                          final isSelected = selectedChoices.contains(index);
          
                          return Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      selectedChoices.add(index);
                                    } else {
                                      selectedChoices.remove(index);
                                    }
                                  });
                                },
                              ),
                              Text(
                                mcqChoices[index]['text'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          );
                        },
                      ),
          
          
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: selectedChoices.isNotEmpty
                            ? () {
                                final selectedTexts = selectedChoices
                                    .map((i) => mcqChoices[i]['text'])
                                    .join(', ');
          
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('You selected: $selectedTexts'),
                                  ),
                                );
                              }
                            : null,
                        child: const Text('Submit'),
                      ),
          
                    ],
                  ),
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
