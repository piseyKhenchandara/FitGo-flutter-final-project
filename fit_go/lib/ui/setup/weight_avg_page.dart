import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/data/avg_weight.dart';
import 'package:fit_go/service/user_service.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:flutter/material.dart';

class WeightAvgPage extends StatefulWidget {
  const WeightAvgPage({super.key});

  @override
  State<WeightAvgPage> createState() => _WeightAvgPageState();
}

class _WeightAvgPageState extends State<WeightAvgPage> {
  double bmi = 0;
  AvgWeight selectedAvgWeight = avgList[0];

  @override
  void initState() {
    super.initState();
    calculate();
  }

  void calculate() {
    // Use UserService to get BMI
    final calculatedBMI = UserService.calculateBMI();

    if (calculatedBMI != null) {
      bmi = calculatedBMI;
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
                          style: TextStyle(
                              color: selectedAvgWeight.color, fontSize: 28),
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
