import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget cachedImages(
    {required String image, required double height, required double width}) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (context, imageProvider) => Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        image: DecorationImage(
          image: Image(image: CachedNetworkImageProvider(image)).image,
          fit: BoxFit.fill,
        ),
      ),
    ),
    placeholder: (context, url) => Container(
      height: 150.0.h,
      width: 125.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          bottomLeft: Radius.circular(10.r),
        ),
      ),
      child: Center(
          child: CircularProgressIndicator(
        strokeWidth: 10.0.w,
        color: Colors.amber,
      )),
    ),
    errorWidget: (context, url, error) => Center(
        child: Icon(
      Icons.error,
      size: 20.0.r,
    )),
  );
}
