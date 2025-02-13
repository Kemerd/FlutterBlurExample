import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'glassmorphism_test.dart';
import 'app_animations.dart';
import 'theme.dart';

/// A collection of customizable frosted glass effects following Apple HIG
/// Provides various shapes and styles with configurable blur and glow effects
/// Enhanced with animated gradients for a more dynamic appearance
class FrostedGlass extends StatefulWidget {
  // Core parameters
  final Widget? child;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  // Blur parameters
  final double blurIntensity;
  final double opacity;

  // Glow parameters
  final Color upperLeftGlow;
  final Color bottomRightGlow;
  final double glowIntensity;
  final bool enableGlow;
  final bool overrideGlowColors;

  // Shape parameters
  final FrostedGlassShape shape;
  final double? circleRadius;

  // Border parameters
  final bool enableBorder;
  final bool enableCorners;
  final bool bCornersRounded; // Whether to use rounded corners or sharp edges

  // Animation parameters
  final Duration animationDuration;
  final bool enableAnimatedGradient;

  // Logger instance
  static final _logger = Logger();

  /// Creates a frosted glass effect container with optional animated gradients
  const FrostedGlass({
    super.key,
    this.child,
    required this.width,
    required this.height,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
    this.blurIntensity = 10,
    this.opacity = 0.5,
    this.upperLeftGlow =
        AppTheme.glassGlowGunmetalLight, // Default gunmetal glow
    this.bottomRightGlow = AppTheme.glassGlowGoldLight, // Default gold glow
    this.glowIntensity = 0.1,
    this.enableGlow = true,
    this.shape = FrostedGlassShape.rectangle,
    this.circleRadius,
    this.enableBorder = true,
    this.enableCorners = true,
    this.bCornersRounded = true, // Default to rounded corners
    this.animationDuration = const Duration(seconds: 240),
    this.enableAnimatedGradient = true,
    this.overrideGlowColors = false,
  });

  /// Creates a circular frosted glass effect
  factory FrostedGlass.circle({
    required double radius,
    Widget? child,
    double blurIntensity = 10,
    double opacity = 0.7,
    Color upperLeftGlow = AppTheme.glassGlowGunmetalLight,
    Color bottomRightGlow = AppTheme.glassGlowGoldLight,
    double glowIntensity = 0.5,
    bool enableGlow = true,
    EdgeInsets padding = const EdgeInsets.all(16),
    Duration animationDuration = const Duration(seconds: 3),
    bool enableAnimatedGradient = true,
  }) {
    return FrostedGlass(
      width: radius * 2,
      height: radius * 2,
      shape: FrostedGlassShape.circle,
      circleRadius: radius,
      blurIntensity: blurIntensity,
      opacity: opacity,
      upperLeftGlow: upperLeftGlow,
      bottomRightGlow: bottomRightGlow,
      glowIntensity: glowIntensity,
      enableGlow: enableGlow,
      padding: padding,
      animationDuration: animationDuration,
      enableAnimatedGradient: enableAnimatedGradient,
      child: child,
    );
  }

  /// Creates a frosted glass button with hover effects
  factory FrostedGlass.button({
    required Widget child,
    required VoidCallback onPressed,
    double width = 200,
    double height = 60,
    BorderRadius? borderRadius,
    double blurIntensity = 10,
    double opacity = 0.7,
    Color upperLeftGlow = AppTheme.glassGlowGunmetalLight,
    Color bottomRightGlow = AppTheme.glassGlowGoldLight,
    double glowIntensity = 0.5,
    bool enableGlow = true,
    EdgeInsets padding = const EdgeInsets.all(16),
    Duration animationDuration = const Duration(seconds: 3),
    bool enableAnimatedGradient = true,
  }) {
    return FrostedGlass(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      blurIntensity: blurIntensity,
      opacity: opacity,
      upperLeftGlow: upperLeftGlow,
      bottomRightGlow: bottomRightGlow,
      glowIntensity: glowIntensity,
      enableGlow: enableGlow,
      padding: padding,
      animationDuration: animationDuration,
      enableAnimatedGradient: enableAnimatedGradient,
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: child,
      ),
    );
  }

  @override
  State<FrostedGlass> createState() => _FrostedGlassState();
}

class _FrostedGlassState extends State<FrostedGlass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientProgress;
  // Random values for unique instance behavior
  late final double _randomStart;
  late Color _randomizedUpperGlow;
  late Color _randomizedBottomGlow;

  @override
  void initState() {
    super.initState();

    // Generate random starting point and color variations
    final random = math.Random();
    _randomStart = random.nextDouble() * math.pi * 2;

    _updateGlowColors();

    // Using spring animation from our custom animations
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )
      ..forward(from: _randomStart / (math.pi * 2))
      ..repeat(reverse: true);

    // Smooth spring animation with overshoot for premium feel
    _gradientProgress = CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.containerSpring,
    ).drive(
      Tween<double>(begin: 0.0, end: 1.0)
        ..chain(CurveTween(curve: Curves.easeInOutSine)),
    );
  }

  /// Updates glow colors based on whether we're overriding or using randomized values
  void _updateGlowColors() {
    if (widget.overrideGlowColors) {
      _randomizedUpperGlow = widget.upperLeftGlow;
      _randomizedBottomGlow = widget.bottomRightGlow;
    } else {
      final random = math.Random();
      // Create slight random variations of the glow colors
      _randomizedUpperGlow = HSLColor.fromColor(widget.upperLeftGlow)
          .withHue((HSLColor.fromColor(widget.upperLeftGlow).hue +
                  (random.nextDouble() * 20 - 10)) %
              360)
          .toColor();
      _randomizedBottomGlow = HSLColor.fromColor(widget.bottomRightGlow)
          .withHue((HSLColor.fromColor(widget.bottomRightGlow).hue +
                  (random.nextDouble() * 20 - 10)) %
              360)
          .toColor();
    }
  }

  @override
  void didUpdateWidget(FrostedGlass oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update glow colors if they changed and we're overriding
    if (widget.overrideGlowColors &&
        (widget.upperLeftGlow != oldWidget.upperLeftGlow ||
            widget.bottomRightGlow != oldWidget.bottomRightGlow)) {
      _updateGlowColors();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Debug log blur values
    FrostedGlass._logger.d('Blur values - intensity: ${widget.blurIntensity}, '
        'actual sigmaX/Y: ${widget.blurIntensity}/${widget.blurIntensity * 2}');

    return LayoutBuilder(
      builder: (context, constraints) {
        // Clamp dimensions to parent constraints with safety checks
        final effectiveWidth =
            (widget.width.isInfinite ? constraints.maxWidth : widget.width)
                .clamp(0, constraints.maxWidth);

        final effectiveHeight =
            (widget.height.isInfinite ? constraints.maxHeight : widget.height)
                .clamp(0, constraints.maxHeight);

        //FrostedGlass._logger
        //    .i('Building FrostedGlass with effective dimensions: '
        //        '${effectiveWidth.toStringAsFixed(1)} x '
        //        '${effectiveHeight.toStringAsFixed(1)}');

        return ClipRRect(
          borderRadius: widget.shape == FrostedGlassShape.circle
              ? BorderRadius.circular(widget.circleRadius ?? effectiveWidth / 2)
              : widget.bCornersRounded
                  ? (widget.borderRadius ?? BorderRadius.circular(16))
                  : BorderRadius.zero,
          child: SizedBox(
            width: effectiveWidth.toDouble(),
            height: effectiveHeight.toDouble(),
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                // Glassmorphism base
                GlassmorphicContainer(
                  width: effectiveWidth.toDouble(),
                  height: effectiveHeight.toDouble(),
                  borderRadius: widget.shape == FrostedGlassShape.circle
                      ? (widget.circleRadius ?? effectiveWidth / 2).toDouble()
                      : widget.bCornersRounded
                          ? (widget.borderRadius?.topLeft.x ?? 16).toDouble()
                          : 0,
                  blur: widget.blurIntensity,
                  alignment: Alignment.center,
                  border: widget.enableBorder ? 1.5 : 0,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CupertinoTheme.of(context)
                          .primaryColor
                          .withOpacity(widget.enableCorners ? 0.05 : 0),
                      CupertinoTheme.of(context)
                          .primaryColor
                          .withOpacity(widget.enableCorners ? 0.02 : 0),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(widget.enableBorder ? 0.6 : 0),
                      Colors.white.withOpacity(widget.enableBorder ? 0.2 : 0),
                    ],
                  ),
                ),

                if (widget.enableGlow && widget.enableAnimatedGradient)
                  AnimatedBuilder(
                    animation: _gradientProgress,
                    builder: (context, child) {
                      final double animatedValue =
                          (_gradientProgress.value * math.pi * 2) +
                              _randomStart;

                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(
                              math.cos(animatedValue) * 1.2,
                              math.sin(animatedValue) * 1.2,
                            ),
                            end: Alignment(
                              -math.cos(animatedValue) * 1.2,
                              -math.sin(animatedValue) * 1.2,
                            ),
                            colors: [
                              _randomizedUpperGlow.withValues(
                                  alpha: _randomizedUpperGlow.a *
                                      widget.glowIntensity),
                              _blendColors(
                                _randomizedUpperGlow,
                                _randomizedBottomGlow,
                                _gradientProgress.value,
                              ).withOpacity(widget.glowIntensity * 0.7),
                              _randomizedBottomGlow.withValues(
                                  alpha: _randomizedBottomGlow.a *
                                      widget.glowIntensity),
                            ],
                            stops: const [0.2, 0.5, 0.8],
                            transform: GradientRotation(animatedValue),
                          ),
                        ),
                      );
                    },
                  )
                else if (widget.enableGlow) ...[
                  // Static glow effects
                  Positioned(
                    left: -effectiveWidth * 0.2,
                    top: -effectiveHeight * 0.2,
                    child: Container(
                      width: effectiveWidth * 0.8,
                      height: effectiveHeight * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.5,
                          colors: [
                            widget.upperLeftGlow.withValues(
                                alpha: widget.upperLeftGlow.a *
                                    widget.glowIntensity),
                            widget.upperLeftGlow.withValues(alpha: 0),
                          ],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -effectiveWidth * 0.2,
                    bottom: -effectiveHeight * 0.2,
                    child: Container(
                      width: effectiveWidth * 0.8,
                      height: effectiveHeight * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.5,
                          colors: [
                            widget.bottomRightGlow.withValues(
                                alpha: widget.bottomRightGlow.a *
                                    widget.glowIntensity),
                            widget.bottomRightGlow.withValues(alpha: 0),
                          ],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                  ),
                ],

                // Content with padding
                Padding(
                  padding: widget.padding,
                  child: widget.child ?? const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this helper method in the _FrostedGlassState class
  Color _blendColors(Color a, Color b, double progress) {
    return Color.lerp(a, b, progress)!.withOpacity(
      (a.a + b.a) * 0.5 * widget.glowIntensity,
    );
  }
}

/// Available shapes for the frosted glass effect
enum FrostedGlassShape {
  rectangle,
  circle,
}

/// Extension to create frosted glass effects on any widget
extension FrostedGlassX on Widget {
  Widget withFrostedGlass({
    required double width,
    required double height,
    BorderRadius? borderRadius,
    double blurIntensity = 10,
    double opacity = 0.7,
    Color upperLeftGlow = AppTheme.glassGlowGunmetalLight,
    Color bottomRightGlow = AppTheme.glassGlowGoldLight,
    double glowIntensity = 0.5,
    bool enableGlow = true,
    EdgeInsets padding = const EdgeInsets.all(16),
    Duration animationDuration = const Duration(seconds: 3),
    bool enableAnimatedGradient = true,
  }) {
    return FrostedGlass(
      width: width,
      height: height,
      borderRadius: borderRadius,
      blurIntensity: blurIntensity,
      opacity: opacity,
      upperLeftGlow: upperLeftGlow,
      bottomRightGlow: bottomRightGlow,
      glowIntensity: glowIntensity,
      enableGlow: enableGlow,
      padding: padding,
      animationDuration: animationDuration,
      enableAnimatedGradient: enableAnimatedGradient,
      child: this,
    );
  }
}
