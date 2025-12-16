import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_alarm/theme/my_colors.dart';

class MyTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.backgroundWhite,
      elevation: 0,
      centerTitle: true, // center the icon
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: MyColors.backgroundMint,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          SvgPicture.asset(
            'assets/plane-alarm-logo.svg',
            width: 48,
            height: 48,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: MyColors.backgroundMint,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
