import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/helpers/snackbar_helper.dart';
import 'package:fit_go/service/user_local_storage_service.dart';
import 'package:fit_go/service/user_service.dart';
import 'package:fit_go/service/validation_service.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:fit_go/widgets/back_next_button.dart';
import 'package:fit_go/widgets/day_checkbox.dart'; 
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  
  Set<String> selectedDays = {};

    void _handleDayChange(String day, bool? value) {
    setState(() {
      if (value == true) {
        if (day == 'everyday') {
          selectedDays.clear();
        } else {
          selectedDays.remove('everyday');
        }
        selectedDays.add(day);
      } else {
        selectedDays.remove(day);
      }
    });
  }


  List<String> _processDays() {
    if (selectedDays.contains('everyday')) {
      return [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday'
      ];
    }
    return selectedDays.toList();
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
            Expanded(
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 450,
                      padding: const EdgeInsets.all(30),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Schedule",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "select day",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                       
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           
                              Expanded(
                                child: Column(
                                  children: [
                                    DayCheckbox(
                                      day: 'monday',
                                      isSelected: selectedDays.contains('monday'),
                                      onChanged: (value) => _handleDayChange('monday', value),
                                    ),
                                    DayCheckbox(
                                      day: 'tuesday',
                                      isSelected: selectedDays.contains('tuesday'),
                                      onChanged: (value) => _handleDayChange('tuesday', value),
                                    ),
                                    DayCheckbox(
                                      day: 'wednesday',
                                      isSelected: selectedDays.contains('wednesday'),
                                      onChanged: (value) => _handleDayChange('wednesday', value),
                                    ),
                                    DayCheckbox(
                                      day: 'thursday',
                                      isSelected: selectedDays.contains('thursday'),
                                      onChanged: (value) => _handleDayChange('thursday', value),
                                    ),
                                  ],
                                ),
                              ),

                         
                              Expanded(
                                child: Column(
                                  children: [
                                    DayCheckbox(
                                      day: 'friday',
                                      isSelected: selectedDays.contains('friday'),
                                      onChanged: (value) => _handleDayChange('friday', value),
                                    ),
                                    DayCheckbox(
                                      day: 'saturday',
                                      isSelected: selectedDays.contains('saturday'),
                                      onChanged: (value) => _handleDayChange('saturday', value),
                                    ),
                                    DayCheckbox(
                                      day: 'sunday',
                                      isSelected: selectedDays.contains('sunday'),
                                      onChanged: (value) => _handleDayChange('sunday', value),
                                    ),
                                    DayCheckbox(
                                      day: 'everyday',
                                      isSelected: selectedDays.contains('everyday'),
                                      onChanged: (value) => _handleDayChange('everyday', value),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rules:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "• Minimum 3 days",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "• If Everyday → internally convert to 5–6 workout days",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          BackNextButton(
                            go_back: true,
                            go_next: true,
                            backRoute: '/setup/weight_avg',
                            onNext: () async {
                              final error = ValidationService.validateSchedule(
                                selectedDays.toList(),
                              );

                              if (error != null) {
                                SnackbarHelper.showError(context, error);
                                return false;
                              }

                              List<String> finalSchedule = _processDays();
                              UserService.saveSchedule(finalSchedule);

                              await UserLocalStorageService.saveUserSetup();

                              return true;
                            },
                            nextRoute: '/home',
                          ),
                        ],
                      ),
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