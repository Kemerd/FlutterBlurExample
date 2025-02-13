import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'frosted_glass.dart';
import 'glassmorphism_test.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const BlurTestApp(),
    ),
  );
}

class BlurTestApp extends StatelessWidget {
  const BlurTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: const BlurTestScreen(),
    );
  }
}

class BlurTestScreen extends StatefulWidget {
  const BlurTestScreen({super.key});

  @override
  State<BlurTestScreen> createState() => _BlurTestScreenState();
}

class _BlurTestScreenState extends State<BlurTestScreen> {
  double _blurAmount = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Checkerboard pattern background to make blur visible
          CustomPaint(
            painter: CheckerboardPainter(),
            size: Size.infinite,
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Original blur implementation
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _blurAmount,
                      sigmaY: _blurAmount,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Original Blur',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Glassmorphic implementation
                GlassmorphicContainer(
                  width: double.infinity,
                  height: 200,
                  borderRadius: 20,
                  blur: _blurAmount,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.2),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.2),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Glassmorphic Blur',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // FrostedGlass implementation
                FrostedGlass(
                  width: double.infinity,
                  height: 200,
                  borderRadius: BorderRadius.circular(20),
                  blurIntensity: _blurAmount,
                  opacity: 0.2,
                  enableGlow: false,
                  child: const Center(
                    child: Text(
                      'FrostedGlass Blur',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Blur amount slider
                Slider(
                  value: _blurAmount,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  label: _blurAmount.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _blurAmount = value;
                    });
                  },
                ),

                Text(
                  'Blur Amount: ${_blurAmount.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Checkerboard pattern painter to make blur effect visible
class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey[300]!;

    const tileSize = 50.0;

    for (var i = 0; i < size.width / tileSize; i++) {
      for (var j = 0; j < size.height / tileSize; j++) {
        if ((i + j) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(i * tileSize, j * tileSize, tileSize, tileSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
