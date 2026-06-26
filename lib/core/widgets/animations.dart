import 'package:flutter/material.dart';
import '../theme/motion.dart';
import '../theme/colors.dart';
import 'app_card.dart';

class FadeSlideWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double slideDistance;

  const FadeSlideWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideDistance = AetherMotion.slideDistanceSmall,
  });

  @override
  State<FadeSlideWidget> createState() => _FadeSlideWidgetState();
}

class _FadeSlideWidgetState extends State<FadeSlideWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AetherMotion.normal,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AetherMotion.enter),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, widget.slideDistance),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: AetherMotion.enter),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class AnimatedAppCard extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AnimatedAppCard({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.backgroundColor = AppColors.cardBg,
    this.width,
    this.height,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideWidget(
      delay: delay,
      slideDistance: AetherMotion.slideDistanceSmall,
      child: AppCard(
        backgroundColor: backgroundColor,
        width: width,
        height: height,
        padding: padding,
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class AnimatedProgressBar extends StatefulWidget {
  final double value;
  final double minHeight;
  final Color? backgroundColor;
  final Color? valueColor;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.minHeight = 4.0,
    this.backgroundColor,
    this.valueColor,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _prevValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: AetherMotion.enter),
    );
    _controller.forward();
    _prevValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: _prevValue, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: AetherMotion.enter),
      );
      _controller.reset();
      _controller.forward();
      _prevValue = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      return LinearProgressIndicator(
        value: widget.value,
        minHeight: widget.minHeight,
        backgroundColor: widget.backgroundColor,
        valueColor: widget.valueColor != null ? AlwaysStoppedAnimation<Color>(widget.valueColor!) : null,
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _animation.value,
          minHeight: widget.minHeight,
          backgroundColor: widget.backgroundColor,
          valueColor: widget.valueColor != null ? AlwaysStoppedAnimation<Color>(widget.valueColor!) : null,
        );
      },
    );
  }
}

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
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
    if (reduced) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1.0, 0.0),
              end: Alignment(_animation.value + 1.0, 0.0),
              colors: const [
                Color(0xFFE2E8F0),
                Color(0xFFEDF2F7),
                Color(0xFFE2E8F0),
              ],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }
}

class StaggeredColumn extends StatelessWidget {
  final List<Widget> children;
  final Duration baseDelay;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const StaggeredColumn({
    super.key,
    required this.children,
    this.baseDelay = Duration.zero,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced || children.length > 20) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(children.length, (index) {
        final delay = baseDelay + (AetherMotion.staggerStep * index);
        return FadeSlideWidget(
          delay: delay,
          slideDistance: AetherMotion.slideDistanceSmall,
          child: children[index],
        );
      }),
    );
  }
}

class PageTransitionBuilder extends PageTransitionsBuilder {
  const PageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced) {
      return child;
    }

    final double slideDistance = AetherMotion.slideDistanceNormal;

    final Animation<double> opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: AetherMotion.enter,
      ),
    );

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: Offset(0.0, slideDistance),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: AetherMotion.enter,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.translate(
            offset: slideAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
