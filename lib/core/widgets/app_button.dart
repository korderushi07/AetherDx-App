import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/motion.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AetherMotion.standard,
        reverseCurve: AetherMotion.enter,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    Widget buttonBody = Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: widget.isPrimary ? AppColors.primary : Colors.transparent,
        borderRadius: AppRadius.buttonBorderRadius,
        border: widget.isPrimary ? null : Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          onTapDown: (_) {
            if (!reduced) _controller.forward();
          },
          onTapUp: (_) {
            if (!reduced) _controller.reverse();
          },
          onTapCancel: () {
            if (!reduced) _controller.reverse();
          },
          borderRadius: AppRadius.buttonBorderRadius,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isPrimary ? Colors.white : AppColors.primary,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: widget.isPrimary ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (reduced) {
      return buttonBody;
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: buttonBody,
    );
  }
}
