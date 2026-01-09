import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../Utils/LazyInjected.dart';


class F_ImageView extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  const F_ImageView({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context)
  {
    if (path.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
      );
    }

    // Determine if the path is a remote URL or local file
    final isRemote = path.startsWith('http://') || path.startsWith('https://');

    if (isRemote) {
      return CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, error)
        {
          final loggingService = LazyInjected<ILoggingService>();
          loggingService.Value.LogWarning(error.toString());
          return const Icon(Icons.broken_image, size: 40);
        }
      );
    } else {
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, error, __)
        {
          final loggingService = LazyInjected<ILoggingService>();
          loggingService.Value.LogWarning(error.toString());

          return const Icon(Icons.broken_image, size: 40);
        },
      );
    }
  }
}
