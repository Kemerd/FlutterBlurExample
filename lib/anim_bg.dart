import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:mesh/mesh.dart';
import 'frosted_glass.dart';
import 'app_animations.dart';
// import '../../nav.dart';
// import 'persistent_bg.dart';

/// Extension methods for easier vertex and color operations
extension OVertexLerpExt on OVertex {
  OVertex to(OVertex b, double t) => OVertex(
        lerpDouble(x, b.x, t) ?? x,
        lerpDouble(y, b.y, t) ?? y,
      );
}

extension ColorLerpExt on Color? {
  Color? to(Color? b, double t) => Color.lerp(this, b, t);
}

/// A stunning animated background that combines mesh gradients with metaballs
/// for a mesmerizing, fluid effect. Uses high-performance shaders and custom
/// animations to create an ethereal atmosphere.
class AnimatedGradientBackground extends StatefulWidget {
  final Widget? child;
  final bool enableMetaballs;
  final bool enableMesh;
  final VoidCallback? onAnimationComplete;
  final double blurIntensity;

  const AnimatedGradientBackground({
    super.key,
    this.child,
    this.enableMetaballs = false,
    this.enableMesh = true,
    this.onAnimationComplete,
    this.blurIntensity = 5.0,
  });

  /// Static method to trigger animation from anywhere
  /// [rainbowFlash] determines whether to trigger the rainbow flash animation (true)
  /// or the normal animation (false)
  static void triggerAnimation(BuildContext context,
      {bool rainbowFlash = false}) {
    final state =
        context.findAncestorStateOfType<AnimatedGradientBackgroundState>();
    if (rainbowFlash) {
      state?.triggerRainbowFlash();
    } else {
      state?.triggerAnimation();
    }
  }

  @override
  State<AnimatedGradientBackground> createState() =>
      AnimatedGradientBackgroundState();
}

/// State class for AnimatedGradientBackground
class AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _rainbowFlashController;
  late double _currentBlur; // Will be initialized in initState
  // Store original colors for restoration
  List<Color?>? _originalBaseColors;
  List<Color?>? _originalTargetColors;
  bool _isRainbowFlashing = false;

  // Configuration for metaballs
  static const int _numMetaballs = 8;
  final List<Offset> _metaballPositions = [];
  final List<double> _metaballVelocities = [];

  // Mesh configuration vertices
  final List<OVertex> _baseVertices = [
    // First row (top)
    (-0.2, -0.2).v, (0.3, -0.3).v, (0.7, -0.25).v, (1.2, -0.2).v,
    // Second row
    (-0.15, 0.15).v, (0.25, 0.2).v, (0.65, 0.15).v, (1.15, 0.2).v,
    // Third row
    (-0.1, 0.35).v, (0.3, 0.4).v, (0.7, 0.35).v, (1.1, 0.4).v,
    // Fourth row
    (-0.15, 0.55).v, (0.25, 0.6).v, (0.65, 0.55).v, (1.15, 0.6).v,
    // Fifth row
    (-0.2, 0.75).v, (0.3, 0.8).v, (0.7, 0.75).v, (1.2, 0.8).v,
    // Sixth row
    (-0.1, 0.95).v, (0.35, 1.0).v, (0.75, 0.95).v, (1.1, 1.0).v,
    // Seventh row (new)
    (-0.2, 1.15).v, (0.3, 1.2).v, (0.7, 1.15).v, (1.2, 1.2).v,
    // Eighth row (new, bottom)
    (-0.15, 1.35).v, (0.25, 1.4).v, (0.65, 1.35).v, (1.15, 1.4).v,
  ];

  final List<OVertex> _targetVertices = [
    // First row (animated positions)
    (-0.1, -0.3).v, (0.35, -0.25).v, (0.75, -0.3).v, (1.1, -0.25).v,
    // Second row
    (-0.2, 0.2).v, (0.3, 0.15).v, (0.7, 0.2).v, (1.2, 0.15).v,
    // Third row
    (-0.15, 0.4).v, (0.25, 0.35).v, (0.65, 0.4).v, (1.15, 0.35).v,
    // Fourth row
    (-0.1, 0.6).v, (0.3, 0.55).v, (0.7, 0.6).v, (1.1, 0.55).v,
    // Fifth row
    (-0.2, 0.8).v, (0.35, 0.75).v, (0.75, 0.8).v, (1.15, 0.75).v,
    // Sixth row
    (-0.15, 1.0).v, (0.25, 0.95).v, (0.65, 1.0).v, (1.2, 0.95).v,
    // Seventh row (new)
    (-0.1, 1.2).v, (0.35, 1.15).v, (0.75, 1.2).v, (1.1, 1.15).v,
    // Eighth row (new)
    (-0.2, 1.4).v, (0.3, 1.35).v, (0.7, 1.4).v, (1.2, 1.35).v,
  ];

  // Change from final to non-final for animation purposes
  final List<Color?> _baseColors = [
    // First row
    null,
    const Color.fromARGB(180, 35, 37, 45).withOpacity(0.7), // Muted gunmetal
    const Color.fromARGB(160, 130, 125, 85)
        .withOpacity(0.35), // Desaturated gold
    null,
    // Second row
    const Color.fromARGB(170, 45, 55, 70).withOpacity(0.6), // Deep blue-grey
    const Color.fromARGB(180, 190, 190, 195).withOpacity(0.3), // Aluminum
    const Color.fromARGB(170, 40, 45, 60).withOpacity(0.6), // Muted steel
    const Color.fromARGB(160, 125, 120, 85)
        .withOpacity(0.35), // Desaturated aged gold
    // Third row
    const Color.fromARGB(180, 30, 35, 45).withOpacity(0.7), // Deep gunmetal
    const Color.fromARGB(180, 200, 200, 210)
        .withOpacity(0.25), // Light aluminum
    const Color.fromARGB(170, 35, 40, 55).withOpacity(0.6), // Rich gunmetal
    const Color.fromARGB(160, 120, 115, 85)
        .withOpacity(0.35), // Muted antique gold
    // Fourth row
    const Color.fromARGB(170, 40, 50, 65).withOpacity(0.6), // Steel blue
    const Color.fromARGB(180, 180, 180, 190)
        .withOpacity(0.3), // Brushed aluminum
    const Color.fromARGB(170, 35, 45, 60).withOpacity(0.6), // Deep steel
    const Color.fromARGB(160, 115, 110, 85)
        .withOpacity(0.35), // Deep desaturated gold
    // Fifth row
    null,
    const Color.fromARGB(180, 25, 30, 40).withOpacity(0.7), // Darkest gunmetal
    const Color.fromARGB(160, 110, 105, 85)
        .withOpacity(0.3), // Deepest desaturated gold
    null,
    // Sixth row
    const Color.fromARGB(170, 35, 40, 55).withOpacity(0.6), // Rich gunmetal
    const Color.fromARGB(180, 170, 170, 180).withOpacity(0.25), // Dark aluminum
    const Color.fromARGB(160, 105, 100, 85)
        .withOpacity(0.3), // Deep desaturated gold
    const Color.fromARGB(170, 30, 35, 50).withOpacity(0.6), // Deep steel blue
    // Seventh row (new)
    const Color.fromARGB(180, 20, 25, 35).withOpacity(0.7), // Darkest gunmetal
    const Color.fromARGB(180, 160, 160, 170)
        .withOpacity(0.25), // Darker aluminum
    const Color.fromARGB(160, 100, 95, 85)
        .withOpacity(0.3), // Deepest desaturated gold
    const Color.fromARGB(170, 25, 30, 45)
        .withOpacity(0.6), // Deepest steel blue
    // Eighth row (new)
    null,
    const Color.fromARGB(180, 15, 20, 30).withOpacity(0.7), // Darkest gunmetal
    const Color.fromARGB(160, 95, 90, 85)
        .withOpacity(0.25), // Most desaturated gold
    null,
  ];

  // Change from final to non-final for animation purposes
  final List<Color?> _targetColors = [
    // First row
    null,
    const Color.fromARGB(180, 30, 35, 45).withOpacity(0.7), // Deep gunmetal
    const Color.fromARGB(180, 185, 185, 195)
        .withOpacity(0.3), // Bright aluminum
    null,
    // Second row
    const Color.fromARGB(170, 40, 50, 65).withOpacity(0.6), // Steel blue
    const Color.fromARGB(160, 120, 115, 85)
        .withOpacity(0.3), // Desaturated vintage gold
    const Color.fromARGB(180, 195, 195, 205)
        .withOpacity(0.25), // Light aluminum
    const Color.fromARGB(160, 115, 110, 85)
        .withOpacity(0.35), // Muted vintage gold
    // Third row
    const Color.fromARGB(180, 25, 30, 40).withOpacity(0.7), // Darkest gunmetal
    const Color.fromARGB(160, 110, 105, 85)
        .withOpacity(0.3), // Desaturated dark gold
    const Color.fromARGB(180, 175, 175, 185).withOpacity(0.3), // Steel aluminum
    const Color.fromARGB(160, 105, 100, 85)
        .withOpacity(0.35), // Deep desaturated gold
    // Fourth row
    const Color.fromARGB(170, 35, 45, 60).withOpacity(0.6), // Steel blue
    const Color.fromARGB(160, 100, 95, 85)
        .withOpacity(0.3), // Deepest desaturated gold
    const Color.fromARGB(180, 165, 165, 175).withOpacity(0.25), // Dark aluminum
    const Color.fromARGB(160, 95, 90, 85)
        .withOpacity(0.35), // Darkest desaturated gold
    // Fifth row
    null,
    const Color.fromARGB(180, 20, 25, 35).withOpacity(0.7), // Darkest gunmetal
    const Color.fromARGB(180, 155, 155, 165)
        .withOpacity(0.25), // Muted aluminum
    null,
    // Sixth row
    const Color.fromARGB(170, 30, 35, 50).withOpacity(0.6), // Deep steel blue
    const Color.fromARGB(180, 150, 150, 160)
        .withOpacity(0.25), // Darker aluminum
    const Color.fromARGB(160, 90, 85, 80)
        .withOpacity(0.3), // Most desaturated gold
    const Color.fromARGB(170, 25, 30, 45)
        .withOpacity(0.6), // Deepest steel blue
    // Seventh row (new)
    const Color.fromARGB(180, 15, 20, 30).withOpacity(0.7), // Darkest gunmetal
    const Color.fromARGB(180, 145, 145, 155)
        .withOpacity(0.25), // Darkest aluminum
    const Color.fromARGB(160, 85, 80, 75)
        .withOpacity(0.3), // Most desaturated gold
    const Color.fromARGB(170, 20, 25, 40)
        .withOpacity(0.6), // Deepest steel blue
    // Eighth row (new)
    null,
    const Color.fromARGB(180, 10, 15, 25).withOpacity(0.7), // Darkest gunmetal
    const Color.fromARGB(160, 80, 75, 70)
        .withOpacity(0.25), // Most desaturated gold
    null,
  ];

  // Saturation value for rainbow flash colors (35% of full saturation)
  static const double _rainbowSaturation = 0.6;

  // Rainbow gradient colors with Apple-inspired vibrancy
  final List<List<Color?>> _rainbowColors = [
    [
      // First set - Super vibrant flash colors (desaturated)
      HSLColor.fromColor(Colors.red)
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.7),
      HSLColor.fromColor(Colors.orange)
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.65),
      HSLColor.fromColor(Colors.yellow)
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.6),
      HSLColor.fromColor(Colors.green)
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.65),
      HSLColor.fromColor(Colors.blue)
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.7),
      HSLColor.fromColor(Colors.purple)
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.65),
    ],
    [
      // Second set - Electric neon flash (desaturated)
      HSLColor.fromColor(const Color(0xFFFF1493))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.65), // Deep pink
      HSLColor.fromColor(const Color(0xFFFF4500))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.6), // Orange red
      HSLColor.fromColor(const Color(0xFFFFD700))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.55), // Golden
      HSLColor.fromColor(const Color(0xFF00FF00))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.6), // Lime
      HSLColor.fromColor(const Color(0xFF1E90FF))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.65), // Dodger blue
      HSLColor.fromColor(const Color(0xFF8A2BE2))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.6), // Blue violet
    ],
    [
      // Third set - Intense metallic (desaturated)
      HSLColor.fromColor(const Color(0xFFFF69B4))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.6), // Hot pink
      HSLColor.fromColor(const Color(0xFFFFA500))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.55), // Orange
      HSLColor.fromColor(const Color(0xFFFFF000))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.5), // Yellow
      HSLColor.fromColor(const Color(0xFF32CD32))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.55), // Lime green
      HSLColor.fromColor(const Color(0xFF4169E1))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.6), // Royal blue
      HSLColor.fromColor(const Color(0xFF9370DB))
          .withSaturation(_rainbowSaturation)
          .toColor()
          .withOpacity(0.55), // Medium purple
    ],
  ];

  /// Triggers the animation by resetting the controller
  void triggerAnimation() {
    _controller
      ..reset()
      ..forward().then((_) {
        widget.onAnimationComplete?.call();
      });
  }

  @override
  void initState() {
    super.initState();
    _currentBlur = widget.blurIntensity;

    // Initialize main animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    // Initialize rainbow flash controller with shorter duration
    _rainbowFlashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Add listeners after initialization
    _rainbowFlashController.addListener(_updateRainbowFlash);
    if (widget.enableMetaballs) {
      _controller.addListener(_updateMetaballs);
    }

    // Initialize metaball positions and velocities with golden ratio spacing
    _initializeMetaballs();
  }

  void _initializeMetaballs() {
    final random = math.Random();
    const goldenRatio = 1.618033988749895;
    for (var i = 0; i < _numMetaballs; i++) {
      _metaballPositions.add(Offset(
        math.sin(i * goldenRatio) * 300,
        math.cos(i * goldenRatio) * 300,
      ));
      _metaballVelocities.add(random.nextDouble() * 2 - 1);
    }
  }

  @override
  void didUpdateWidget(AnimatedGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blurIntensity != widget.blurIntensity) {
      setState(() => _currentBlur = widget.blurIntensity);
    }
    // Handle changes in metaball state
    if (widget.enableMetaballs != oldWidget.enableMetaballs) {
      if (widget.enableMetaballs) {
        _controller.addListener(_updateMetaballs);
      } else {
        _controller.removeListener(_updateMetaballs);
      }
    }
  }

  void _updateMetaballs() {
    setState(() {
      for (var i = 0; i < _numMetaballs; i++) {
        final pos = _metaballPositions[i];
        final vel = _metaballVelocities[i];

        // Update positions with smooth sinusoidal motion and spring effect
        _metaballPositions[i] = Offset(
          pos.dx +
              math.sin(_controller.value * math.pi * 2 + i) *
                  vel *
                  AppAnimations.containerSpring.transform(_controller.value) *
                  2,
          pos.dy +
              math.cos(_controller.value * math.pi * 2 + i) *
                  vel *
                  AppAnimations.containerSpring.transform(_controller.value) *
                  2,
        );
      }
    });
  }

  /// Triggers a stunning rainbow flash animation
  void triggerRainbowFlash() {
    if (_isRainbowFlashing || !mounted) {
      print(
          "🌈 Early return - isFlashing: $_isRainbowFlashing, mounted: $mounted");
      return;
    }
    _isRainbowFlashing = true;

    // Store original colors if not already stored
    _originalBaseColors ??= List<Color?>.from(_baseColors);
    _originalTargetColors ??= List<Color?>.from(_targetColors);

    // Store original animation state
    final originalDuration = _controller.duration;
    final currentValue = _controller.value;

    // Speed up the background movement dramatically during flash
    // but maintain the back-and-forth motion
    _controller
      ..stop() // Stop the current animation
      ..duration = const Duration(milliseconds: 500) // Speed up
      ..forward(from: currentValue) // Continue from current position
      ..repeat(reverse: true); // Keep the back-and-forth motion but faster

    // Start the rainbow flash animation
    _rainbowFlashController
      ..reset()
      ..forward().then((_) {
        if (!mounted) return;

        // Create a secondary animation for smooth color restoration
        final fadeOutController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 150),
        );

        final fadeOutAnimation = CurvedAnimation(
          parent: fadeOutController,
          curve: Curves.easeInOut,
        );

        // Store the current rainbow colors
        final currentBaseColors = List<Color?>.from(_baseColors);
        final currentTargetColors = List<Color?>.from(_targetColors);

        // Animate the fade out
        fadeOutAnimation.addListener(() {
          if (!mounted) return;
          final t = fadeOutAnimation.value;

          // Interpolate between rainbow and original colors
          for (int i = 0; i < _baseColors.length; i++) {
            if (_baseColors[i] != null) {
              _baseColors[i] = Color.lerp(
                currentBaseColors[i],
                _originalBaseColors![i],
                t,
              );
              _targetColors[i] = Color.lerp(
                currentTargetColors[i],
                _originalTargetColors![i],
                t,
              );
            }
          }
          setState(() {});
        });

        fadeOutController.forward().then((_) {
          // Clean up
          fadeOutController.dispose();
          _isRainbowFlashing = false;

          // Get the current position in the back-and-forth cycle
          final currentCycle = _controller.value;

          // Restore original animation state and resume normal animation
          // from wherever the fast back-and-forth ended up
          _controller
            ..stop()
            ..duration = originalDuration
            ..forward(from: currentCycle) // Continue from current position
            ..repeat(reverse: true); // Resume normal back-and-forth animation
        });
      });
  }

  void _updateRainbowFlash() {
    if (!_isRainbowFlashing || !mounted) return;

    final double t = _rainbowFlashController.value;

    // Update blur intensity using sine curve for smooth in/out
    _currentBlur =
        5.0 + (math.sin(t * math.pi) * 10.0); // Oscillate between 5 and 20

    // Calculate indices safely to prevent range errors
    final int maxIndex = _rainbowColors.length - 1;
    final int colorSetIndex = (t * maxIndex).floor().clamp(0, maxIndex);
    final List<Color?> currentRainbowSet = _rainbowColors[colorSetIndex];
    final List<Color?> nextRainbowSet =
        _rainbowColors[math.min(colorSetIndex + 1, maxIndex)];

    // Calculate interpolation factor between current and next set
    final double setProgress = (t * maxIndex) - colorSetIndex;

    if (mounted) {
      setState(() {
        // Create a mesmerizing rainbow pattern with smooth transitions
        for (int i = 0; i < _baseColors.length; i++) {
          if (_baseColors[i] != null) {
            final rainbowIndex = i % currentRainbowSet.length;
            final nextIndex = (rainbowIndex + 1) % currentRainbowSet.length;

            // Make colors more vibrant during flash
            final double flashIntensity =
                math.sin(t * math.pi) * 0.5 + 0.5; // Pulsing effect

            // Interpolate between current and next rainbow sets with increased vibrancy
            final currentColor = Color.lerp(
              currentRainbowSet[rainbowIndex],
              nextRainbowSet[rainbowIndex],
              setProgress,
            )?.withOpacity(0.9 * flashIntensity); // More opacity for visibility

            final nextColor = Color.lerp(
              currentRainbowSet[nextIndex],
              nextRainbowSet[nextIndex],
              setProgress,
            )?.withOpacity(0.9 * flashIntensity); // More opacity for visibility

            _baseColors[i] = currentColor;
            _targetColors[i] = nextColor;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // Remove listeners first
    _rainbowFlashController.removeListener(_updateRainbowFlash);
    if (widget.enableMetaballs) {
      _controller.removeListener(_updateMetaballs);
    }

    // Then dispose controllers
    _rainbowFlashController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Animated mesh gradient background
        if (widget.enableMesh)
          SizedBox.expand(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final dt = _controller.value;
                return OMeshGradient(
                  tessellation: 32,
                  size:
                      MediaQuery.of(context).size * 1.2, // Increase size by 20%
                  mesh: OMeshRect(
                    width: 3,
                    height: 8,
                    colorSpace: OMeshColorSpace.lab,
                    fallbackColor: Colors.transparent,
                    vertices: List.generate(
                      24,
                      (i) => _baseVertices[i].to(_targetVertices[i], dt),
                    ),
                    colors: List.generate(
                      _baseColors.length,
                      (i) => _baseColors[i]?.to(_targetColors[i], dt),
                    ),
                  ),
                );
              },
            ),
          ),

        // Content layer
        if (widget.child != null) widget.child!,

        // Frosted glass overlay with animated blur
        Positioned.fill(
          child: FrostedGlass(
            width: double.infinity,
            height: double.infinity,
            blurIntensity: _currentBlur,
            opacity: 0.2,
            enableGlow: false,
            enableBorder: false,
            enableCorners: false,
            bCornersRounded: false,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
