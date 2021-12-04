import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowTitles extends StatelessWidget {
  final String reference;
  final String value;
  RowTitles({Key? key, required this.reference, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 10.0.w),
          Text(reference,
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.bold)),
        ]);
  }
}
