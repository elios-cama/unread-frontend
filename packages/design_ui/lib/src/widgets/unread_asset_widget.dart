import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UnreadAsset extends StatelessWidget {
  const UnreadAsset({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit,
    this.colorFilter,
    this.opacity = 1.0,
    this.package = 'app_ui',
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ColorFilter? colorFilter;
  final double opacity;
  final String package;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }

    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        package: package,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        colorFilter: colorFilter,
      );
    }

    Widget image = Image.asset(
      path,
      package: package,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      opacity: AlwaysStoppedAnimation<double>(opacity),
    );

    if (colorFilter != null) {
      return ColorFiltered(colorFilter: colorFilter!, child: image);
    }

    return image;
  }
}
