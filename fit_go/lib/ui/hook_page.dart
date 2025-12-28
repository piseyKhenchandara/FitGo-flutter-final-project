import 'package:flutter/material.dart';

class HookPage extends StatelessWidget {
  const HookPage({
    super.key,
    required this.image,
    required this.text,
    required this.onNext,
  });

  final String image;
  final String text;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[400],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/fitness.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Fit GO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                      )
                    ),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            text,
                            style: TextStyle(color: Colors.white, fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        ElevatedButton(
                          onPressed: onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),

                            child: const Text(
                              'next',
                              style: TextStyle(fontSize: 50, color: Colors.white),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  )
                ),      
              ],
            ),
          ),
        ],
      ),
    );
  }
}
