import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class RatingManga extends StatefulWidget {
  RatingManga({Key? key, required this.rating, required this.labelVisible})
      : super(key: key);
  double rating;
  bool labelVisible;
  @override
  State<RatingManga> createState() => _RatingMangaState();
}

class _RatingMangaState extends State<RatingManga> {
  @override
  Widget build(BuildContext context) {
    return RatingStars(
      value: widget.rating,
      onValueChanged: (v) {
        //
        setState(() {
          widget.rating = v;
        });
      },
      starBuilder: (index, color) => Icon(
        Icons.star_rate,
        color: color,
      ),
      starCount: 5,
      starSize: widget.labelVisible ? 0.0.r : 20.0.r,
      valueLabelColor: const Color(0xff9b9b9b),
      valueLabelTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 12.0),
      valueLabelRadius: 10.r,
      maxValue: 5,
      starSpacing: 1,
      maxValueVisibility: true,
      valueLabelVisibility: widget.labelVisible,
      animationDuration: const Duration(milliseconds: 1000),
      valueLabelPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.h),
      valueLabelMargin: EdgeInsets.only(right: 4.w),
      starOffColor: const Color(0xffe7e8ea),
      starColor: const Color(0xfffdbf03),
    );
  }
}
