
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
  final bool Function()? onNext;
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
                  onPressed: () {
                    final canGo = onNext?.call() ?? true;

                    if(!canGo) return;

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
