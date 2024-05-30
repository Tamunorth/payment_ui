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

import '../pages/details_page.dart';
import 'receiver_selector.dart';

class SelectReceiverBottomSheet extends StatelessWidget {
  const SelectReceiverBottomSheet({
    super.key,
    required this.data,
    required this.controller,
  });

  final InvoiceData data;
  final DraggableScrollableController controller;

  @override
  Widget build(BuildContext context) {
    final receiversList = invoices.value.where((value) => value.id != 'INV001');
    return DraggableScrollableSheet(
      expand: false,
      controller: controller,
      maxChildSize: 0.85,
      initialChildSize: 0.84,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 50,
                height: 10,
                child: Card(
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
              // Container(decoration: BoxDecoration(borderRadius: ),)
              const SizedBox(
                height: 24,
              ),
              Text(
                'Select receiver',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor.withOpacity(0.4),
                  ),
                  prefixIcon: Icon(
                    UIcons.regularRounded.search,
                    size: 20,
                  ),
                  prefixIconColor: Theme.of(context).hintColor.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(
                receiversList.length,
                (index) => ReceiverSelector(
                  data: receiversList.elementAt(index),
                  onSelected: (data) {
                    Navigator.pop(context, data);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
