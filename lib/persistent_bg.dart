import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'anim_bg.dart';

/// Logger instance for debugging
final _logger = Logger();

/// Persistent background using StatefulWidget implementation
/// to properly manage animation lifecycle
class PersistentBackground extends StatefulWidget {
  final Widget child;
  // Static key for the background
  static final GlobalKey<AnimatedGradientBackgroundState> backgroundKey =
      GlobalKey();

  const PersistentBackground({
    super.key,
    required this.child,
  });

  @override
  State<PersistentBackground> createState() => _PersistentBackgroundState();
}

class _PersistentBackgroundState extends State<PersistentBackground> {
  @override
  Widget build(BuildContext context) {
    // _logger.d('Building persistent background');
    return Stack(
      fit: StackFit.expand,
      children: [
        // Animated background with continuous animation
        AnimatedGradientBackground(
          key: PersistentBackground.backgroundKey,
          enableMesh: true,
          enableMetaballs: false,
        ),
        // Content layer
        widget.child,
      ],
    );
  }
}
