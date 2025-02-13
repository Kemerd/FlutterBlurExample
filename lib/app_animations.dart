import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sprung/sprung.dart';

/// Standardized animation constants following Apple/Google design principles
class AppAnimations {
  /// Standard durations
  static const Duration fast = Duration(milliseconds: 300);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);

  /// Standard delays for staggered animations
  static const Duration staggerFirst = Duration(milliseconds: 50);
  static const Duration staggerSecond = Duration(milliseconds: 100);
  static const Duration staggerThird = Duration(milliseconds: 150);
  static const Duration staggerFourth = Duration(milliseconds: 200);
  static const Duration staggerFifth = Duration(milliseconds: 250);
  static const Duration staggerSixth = Duration(milliseconds: 300);

  /// Standard slide offsets
  static const double subtleSlide = 0.15;
  static const double normalSlide = 0.2;
  static const double dramaticSlide = 0.3;

  /// Premium feeling spring curve for container animations
  /// Using Sprung with custom parameters for smooth, natural movement
  static final Curve containerSpring = Sprung.custom(
    mass: 1.0,
    stiffness: 135.0, // Softer spring for smooth movement
    damping: 15.0, // Light damping for natural bounce
  );

  /// Snappier spring curve for child elements
  /// Using Sprung with slightly stiffer parameters for more responsive feel
  static final Curve elementSpring = Sprung.custom(
    mass: 1.0,
    stiffness: 150.0, // Slightly stiffer for responsiveness
    damping: 17.0, // Balanced damping
  );
}

/// Extension methods for easier animation application
extension AnimateExtension on Widget {
  /// Apply standard container animation
  Widget withStandardAnimation() {
    return animate()
        .fadeIn(
          duration: AppAnimations.fast,
          curve: AppAnimations.containerSpring,
        )
        .slideX(
          begin: AppAnimations.subtleSlide,
          end: 0,
          duration: AppAnimations.normal,
          curve: AppAnimations.containerSpring,
        );
  }

  /// Apply staggered child animation
  Widget withStaggeredAnimation({Duration delay = Duration.zero}) {
    return animate(delay: delay)
        .fadeIn(
          duration: AppAnimations.fast,
          curve: AppAnimations.elementSpring,
        )
        .slideX(
          begin: AppAnimations.subtleSlide,
          end: 0,
          duration: AppAnimations.normal,
          curve: AppAnimations.elementSpring,
        );
  }

  /// Apply slide animation only
  Widget withSlideAnimation({Duration delay = Duration.zero}) {
    return animate(delay: delay).slideX(
      begin: AppAnimations.subtleSlide,
      end: 0,
      duration: AppAnimations.normal,
      curve: AppAnimations.containerSpring,
    );
  }

  /// Apply fade animation only
  Widget withFadeAnimation({Duration delay = Duration.zero}) {
    return animate(delay: delay).fadeIn(
      duration: AppAnimations.fast,
      curve: AppAnimations.containerSpring,
    );
  }
}
