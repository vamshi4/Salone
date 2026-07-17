import 'package:flutter/material.dart';

/// A lightweight stand-in for Google's "G" logomark — a gradient-filled
/// glyph in Google's four brand colors, not the official vector artwork
/// (no `flutter_svg` dependency or bundled asset needed for that). Good
/// enough to read as "this is Google" next to "Continue with Google" text.
class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF34A853), Color(0xFFFBBC05), Color(0xFFEA4335)],
        ).createShader(bounds),
        child: Text(
          'G',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: size, color: Colors.white, height: 1),
        ),
      ),
    );
  }
}
