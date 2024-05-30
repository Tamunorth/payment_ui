import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_ui/pages/home_page.dart';
import 'package:payment_ui/main.dart';
import 'package:payment_ui/widgets/receiver_bottom_sheet.dart';
import 'package:payment_ui/utils.dart';
import 'package:uicons/uicons.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 75),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'You created a new invoice',
            style: TextStyle(color: Colors.black),
          ),
          Icon(
            UIcons.regularRounded.x,
            color: Colors.grey.withOpacity(0.7),
            size: 12,
          ),
        ],
      ),
    );
  }
}
