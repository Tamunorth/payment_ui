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

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Divider(
          color: Theme.of(context).hintColor.withOpacity(0.2),
        )
      ],
    );
  }
}
