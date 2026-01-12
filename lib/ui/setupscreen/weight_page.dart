import 'package:fit_go/domain/models/user_setup_controller.dart';
import 'package:fit_go/ui/helpers/snackbar_helper.dart';
import 'package:fit_go/domain/service/user_setup_service.dart';
import 'package:fit_go/ui/widgets/back_next_button.dart';
import 'package:flutter/material.dart';
import '../widgets/appbar.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});



  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  double selectedWeight = 73.0;
  final double minWeight = 30.0;
  final double maxWeight = 200.0;
  final double step = 0.1; 

  @override
  Widget build(BuildContext context) {
    
    final int itemCount = ((maxWeight - minWeight) / step).round() + 1;

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
                    initialItem: ((selectedWeight - minWeight) / step).round(),
                  ),
                  physics: const FixedExtentScrollPhysics(),
                  itemExtent: 60,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedWeight = minWeight + (index * step);
                      selectedWeight = double.parse(selectedWeight.toStringAsFixed(1)); // Round to 1 decimal
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: itemCount,
                    builder: (context, index) {
                      final value = minWeight + (index * step);
                      final roundedValue = double.parse(value.toStringAsFixed(1));
                      final isSelected = (roundedValue - selectedWeight).abs() < 0.01;

                      return RotatedBox(
                        quarterTurns: 1,
                        child: Center(
                          child: Text(
                            roundedValue.toStringAsFixed(1), // Show 1 decimal place
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

            Text(
              '${selectedWeight.toStringAsFixed(1)} kg',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 120),

            BackNextButton(
              go_back: true,
              go_next: true,
              backRoute: '/setup/height',
              onNext: () {
                UserService.saveWeight(selectedWeight);
                SnackbarHelper.showInfo(
                  context,
                  'You selected weight: ${selectedWeight.toStringAsFixed(1)} kg',
                );
                return true;
              },
              nextRoute: '/setup/weight_avg',
            )
          ],
        ),
      ),
    );
  }
}