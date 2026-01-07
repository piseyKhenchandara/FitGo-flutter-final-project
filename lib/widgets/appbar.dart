import 'dart:ui';
import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
         
          backgroundColor: Colors.white.withOpacity(0.1),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          title: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/fitness.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              const Text(
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}