
import 'package:fit_go/data/avg_weight.dart';
import 'package:fit_go/helpers/snackbar_helper.dart';
import 'package:fit_go/models/enums.dart';
import 'package:fit_go/service/user_setup_service.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:fit_go/widgets/back_next_button.dart';
import 'package:fit_go/widgets/goal_choice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WeightAvgPage extends StatefulWidget {
  const WeightAvgPage({super.key});

  @override
  State<WeightAvgPage> createState() => _WeightAvgPageState();
}

class _WeightAvgPageState extends State<WeightAvgPage> {
  double bmi = 0;
  AvgWeight selectedAvgWeight = avgList[0];

  GoalType? selectedGoal;

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
      autoSelectGoal();
      print(bmi.toStringAsFixed(1));
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

  void autoSelectGoal() {
    if (bmi < 18.5) {
      selectedGoal = GoalType.gainMuscle;
    } else if (bmi < 25) {
      selectedGoal = GoalType.stayFit;
    } else {
      selectedGoal = GoalType.loseWeight;
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
                    width: 450,
                    padding: const EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
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
                            color: selectedAvgWeight.color,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Choose your options :',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GoalChoice(
                              text: 'Stay Fit',
                              selectedGoal: selectedGoal,
                              goalType: GoalType.stayFit,
                              onPress: () {
                                UserService.saveGoalType(GoalType.stayFit);
                                SnackbarHelper.showInfo(
                                  context,
                                  "You selected stay fit.",
                                );
                                context.go('/setup/schedule');
                              },
                            ),

                            GoalChoice(
                              text: 'Gain muscle',
                              selectedGoal: selectedGoal,
                              goalType: GoalType.gainMuscle,
                              onPress: () {
                                UserService.saveGoalType(GoalType.gainMuscle);
                                SnackbarHelper.showInfo(
                                  context,
                                  "You selected gain muscle",
                                );
                                context.go('/setup/schedule');
                              },
                            ),

                            GoalChoice(
                              text: 'Lost weight',
                              selectedGoal: selectedGoal,
                              goalType: GoalType.loseWeight,
                              onPress: () {
                                UserService.saveGoalType(GoalType.loseWeight);
                                SnackbarHelper.showInfo(
                                  context,
                                  "You selected lost weight",
                                );
                                context.go('/setup/schedule');
                              },
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/bmi/bmi.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        BackNextButton(
                          go_back: true,
                          go_next: true,
                          backRoute: '/setup/weight',
                          onNext: () {

                        
                              UserService.saveBMI(bmi);         
                              return true;
                            
                          

                          },
                          
                          nextRoute: '/setup/schedule',
                          
                        )
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
