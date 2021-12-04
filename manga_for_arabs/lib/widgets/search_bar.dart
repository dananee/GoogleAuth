import 'package:arabic_manga_readers/constants/colors.dart';
import 'package:arabic_manga_readers/controller/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 23.0.h),
      child: GestureDetector(
        onTap: () {
          showSearch(
            context: context,
            delegate: SearchForManga(),
          );
        },
        child: Container(
          height: 50.0.h,
          width: 340.0.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 10.0.h, right: 20.0.w, bottom: 10.0.h, left: 15.0.r),
                child: const Icon(
                  Icons.search,
                  color: kGreyColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 10.0.h, right: 20.0.w, bottom: 10.0.h, left: 15.0.w),
                child: Text(
                  '..بحث عن',
                  style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    color: kGreyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
