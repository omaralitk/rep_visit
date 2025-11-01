// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mename/screens/base/base_controller.dart';
//
// class CustomCachedNetworkImage extends StatelessWidget {
//   CustomCachedNetworkImage({
//     super.key,
//     this.imageUrl,
//     this.fit,
//     this.errorWidget,
//     this.height,
//     this.width,
//     this.placeholder,
//   });
//
//   final String? imageUrl;
//   final BoxFit? fit;
//   final LoadingErrorWidgetBuilder? errorWidget;
//   final PlaceholderWidgetBuilder? placeholder;
//   final double? height;
//   final double? width;
//   final Map<String, String> headersEmpty = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       height: height,
//       width: width,
//       httpHeaders: Get.isRegistered<BaseController>()
//           ? Get.find<BaseController>().headers
//           : headersEmpty,
//       imageUrl: imageUrl ?? "",
//       fit: fit,
//       placeholder: placeholder,
//       errorWidget: (context, url, error) =>
//       errorWidget?.call(context, url, error) ??
//           const Center(child: Icon(Icons.error)),
//     );
//   }
// }
