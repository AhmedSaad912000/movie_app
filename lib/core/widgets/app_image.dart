import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImage extends StatelessWidget {
  final String url;
  final double? height, width;
  final Color? color;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  const AppImage(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.scaleDown,
    this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    if (url.endsWith('svg')) {
      return SvgPicture.asset(
        'assets/svg/$url',
        height: height,
        width: width,
        fit: fit,
        colorFilter: colorFilter,
      );
    } else if (url.startsWith('http')) {
      return Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) => AppImage(
          'https://static.thenounproject.com/png/505166-200.png',
          height: height,
          width: width,
        ),
      );
    } else {
      return Image.asset("assets/images/$url",
          height: height,
          width: width,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) => AppImage(
                'https://static.thenounproject.com/png/505166-200.png',
                height: height,
                width: width,
              ));
    }
  }
}
