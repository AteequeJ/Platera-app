import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_design.dart';

class OrganicBackground extends StatelessWidget {
  const OrganicBackground({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      color: AppColors.background(context),
      child: Stack(
        children: [
          _Blob(
            color: (isDark ? const Color(0xFFD1FF82) : const Color(0xFFA8E6CF)).withOpacity(isDark ? 0.08 : 0.15),
            size: 300,
            initialOffset: const Offset(-100, -100),
            duration: 15.seconds,
          ),
          _Blob(
            color: (isDark ? const Color(0xFF3BCEAC) : const Color(0xFFD1FF82)).withOpacity(isDark ? 0.08 : 0.12),
            size: 400,
            initialOffset: const Offset(200, 400),
            duration: 20.seconds,
          ),
          _Blob(
            color: (isDark ? const Color(0xFFD1FF82) : const Color(0xFF3BCEAC)).withOpacity(isDark ? 0.05 : 0.1),
            size: 250,
            initialOffset: const Offset(100, 100),
            duration: 12.seconds,
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  final Offset initialOffset;
  final Duration duration;

  const _Blob({
    required this.color,
    required this.size,
    required this.initialOffset,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: initialOffset.dx,
      top: initialOffset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 100,
              spreadRadius: 100,
            ),
          ],
        ),
      )
      .animate(onPlay: (c) => c.repeat(reverse: true))
      .move(
        begin: Offset.zero,
        end: Offset(Random().nextDouble() * 100, Random().nextDouble() * 100),
        duration: duration,
        curve: Curves.easeInOutSine,
      ),
    );
  }
}
