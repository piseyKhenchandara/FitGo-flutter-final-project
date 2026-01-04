import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackNextButton extends StatelessWidget {
  const BackNextButton({
    super.key,
    this.go_back = false,
    this.go_next = false,
    this.backRoute,
    this.nextRoute,
    this.onNext,
    this.onBack,
  });

  final bool go_back;
  final bool go_next;
  final String? backRoute;
  final String? nextRoute;
  final dynamic onNext; // ✅ CHANGED: accepts both bool Function() and Future<bool> Function()
  final bool Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          go_back
              ? ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                  onPressed: () {
                    final canGo = onBack?.call() ?? true;
                    if (!canGo) return;
                    
                    if (backRoute != null) {
                      context.go(backRoute!);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              : const SizedBox(),

          go_next
              ? ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  onPressed: () async { // ✅ CHANGED: added async
                    // ✅ HANDLE BOTH SYNC AND ASYNC
                    final result = onNext?.call();
                    final canGo = result is Future<bool> 
                        ? await result 
                        : (result ?? true);

                    if (!canGo) return;

                    if (nextRoute != null) {
                      context.go(nextRoute!);
                    }
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}