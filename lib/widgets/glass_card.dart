import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_design.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final double blur;
  final EdgeInsetsGeometry? padding;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.blur = 30,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = AppDesign.glassDecoration(context);
    final finalBorderRadius = borderRadius != null 
        ? BorderRadius.circular(borderRadius!) 
        : decoration.borderRadius as BorderRadius;

    return ClipRRect(
      borderRadius: finalBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: decoration.copyWith(
            borderRadius: finalBorderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
