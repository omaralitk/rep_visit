import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/asset_images.dart';
class CachedImage extends StatelessWidget {
  final String url;
   const CachedImage({super.key,required this.url});

  @override
  Widget build(BuildContext context) {
    log("dldddddddddddd ${url}");
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary100),
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: Padding(padding: const EdgeInsets.all(12),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.mainColor,
          ),
          ),
        ),
        errorWidget: (context, url, error) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            AssetImages.emptyImage, // your fallback SVG or PNG
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
