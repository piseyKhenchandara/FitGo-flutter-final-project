import 'package:fit_go/widgets/appbar.dart';
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

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        duration: const Duration(days: 1), // stays until Next clicked
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onNext();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: Text(
                  'NEXT',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show snackbar AFTER build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnackBar(context);
    });

    return Scaffold(
      body: Container(
        color: Colors.blue[400],
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Appbar(),
            ),
            Expanded(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
