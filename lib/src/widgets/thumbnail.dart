import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ThumbnailImg extends StatelessWidget {
  const ThumbnailImg({
    Key? key,
    required this.url,
    this.background,
    required this.size,
  }) : super(key: key);

  final String url;
  final Color? background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: url,
        height: size,
        width: size,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      ),
    );
  }
}
