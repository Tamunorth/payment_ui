import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_ui/pages/details_page.dart';
import 'package:payment_ui/pages/home_page.dart';
import 'package:payment_ui/main.dart';
import 'package:payment_ui/widgets/receiver_bottom_sheet.dart';
import 'package:payment_ui/utils.dart';
import 'package:uicons/uicons.dart';

class ReceiverSelector extends StatefulWidget {
  const ReceiverSelector({
    super.key,
    required this.data,
    required this.onSelected,
  });

  final InvoiceData data;
  final void Function(InvoiceData) onSelected;

  @override
  State<ReceiverSelector> createState() => _ReceiverSelectorState();
}

class _ReceiverSelectorState extends State<ReceiverSelector> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: InkWell(
            onTap: () {
              setState(() {
                selected = !selected;
              });
              Future.delayed(const Duration(milliseconds: 400), () {
                widget.onSelected.call(widget.data);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        image: widget.data.image.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(widget.data.image),
                                fit: BoxFit.cover,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.data.receiverName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                Icon(
                  selected ? Icons.radio_button_checked : Icons.circle,
                  size: 32,
                  color: selected
                      ? null
                      : Theme.of(context).hintColor.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).hintColor.withOpacity(0.2),
        ),
      ],
    );
  }
}
