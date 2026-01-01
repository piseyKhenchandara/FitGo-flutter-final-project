
import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/appbar.dart';

class HeightPage extends StatefulWidget {
  const HeightPage({super.key});

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  int selectedHeight = 173; // default value

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
              'Height',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 40),

          

            // WHEEL
            SizedBox(
              height: 250, // fixed height
              child: ListWheelScrollView.useDelegate(
                controller: FixedExtentScrollController(
                  initialItem: selectedHeight - 140,
                ),
                itemExtent: 40,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedHeight = 140 + index;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 71, // 140 to 210
                  builder: (context, index) {
                    final value = 140 + index;
                    final isSelected = value == selectedHeight;
                    return Center(
                      child: Text(
                        '$value cm',
                        style: TextStyle(
                          fontSize: isSelected ? 26 : 20,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 120),

            ElevatedButton(
            onPressed: () {
                UserService.saveHeight(selectedHeight);
                context.go('/setup/weight');
              },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
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
