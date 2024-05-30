import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_ui/home_page.dart';
import 'package:payment_ui/main.dart';
import 'package:payment_ui/receiver_bottom_sheet.dart';
import 'package:payment_ui/utils.dart';
import 'package:uicons/uicons.dart';

enum InvoiceStatus { done, pending, draft, rejected }

class InvoiceData {
  final String id;
  final InvoiceStatus status;
  final String receiverName;
  final String receiverEmail;
  final String image;
  final num subtotal;
  final num tax;

  InvoiceData({
    required this.id,
    required this.image,
    required this.status,
    required this.receiverName,
    required this.receiverEmail,
    required this.subtotal,
    required this.tax,
  });
}

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    super.key,
    required this.invoiceData,
  });

  final InvoiceData invoiceData;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with TickerProviderStateMixin {
  final slideTransDuration = const Duration(milliseconds: 800);
  late Animation<Offset> _slideAnimation;
  late DraggableScrollableController _draggableScrollableController;

  late AnimationController _controller;
  late AnimationController _bottomSheetAnimatoin;
  InvoiceData? _selectedReceiver;

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: slideTransDuration,
    );

    _selectedReceiver = widget.invoiceData;

    _draggableScrollableController = DraggableScrollableController();

    _bottomSheetAnimatoin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final time = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(UIcons.regularRounded.arrow_left)),
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Invoice #${widget.invoiceData.id}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          StatusContainer(status: _selectedReceiver!.status)
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${time.day}.${time.month}.${time.year}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(height: 24),
                      _selectedReceiver!.image.isNotEmpty
                          ? Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.2),
                                    image: _selectedReceiver!.image.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                _selectedReceiver!.image),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedReceiver!.receiverName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      widget.invoiceData.receiverEmail,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).hintColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () async {
                                final result = await showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(
                                        30,
                                      ),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  transitionAnimationController:
                                      _bottomSheetAnimatoin,
                                  builder: (context) =>
                                      SelectReceiverBottomSheet(
                                    data: widget.invoiceData,
                                    controller: _draggableScrollableController,
                                  ),
                                );

                                if (result is InvoiceData) {
                                  setState(() {
                                    _selectedReceiver = result;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.add),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Add a receiver',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(height: 32),
                      Card(
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'UI design Delivery app',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  '- UI design Delivery app',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Theme.of(context).hintColor),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  '- Low-Fi Wireframes(\$400)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Theme.of(context).hintColor),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  '- Design (\$2000)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Theme.of(context).hintColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 20),
                      SummaryRow(
                        title: 'Subtotal',
                        value: '\$${widget.invoiceData.subtotal}',
                      ),
                      SummaryRow(
                        title: 'Tax',
                        value: '\$${widget.invoiceData.tax}',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            "\$${(widget.invoiceData.subtotal + widget.invoiceData.tax)}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, isLoadingValue, child) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 45),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                    onPressed: _selectedReceiver!.image.isEmpty
                        ? null
                        : () async {
                            isLoading.value = true;

                            invoices.value.removeAt(0);

                            invoices.value.insert(
                              0,
                              InvoiceData(
                                id: 'INV001',
                                image: _selectedReceiver?.image ?? '',
                                status: InvoiceStatus.done,
                                receiverName:
                                    _selectedReceiver?.receiverName ?? '',
                                receiverEmail:
                                    _selectedReceiver?.receiverEmail ?? '',
                                subtotal: 100.50,
                                tax: 8.50,
                              ),
                            );

                            await Future.delayed(const Duration(seconds: 2),
                                () {
                              isLoading.value = false;
                              invoices.notifyListeners();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  content: CustomSnackBar(),
                                ),
                              );
                              // Navigator.pop(context);
                            });
                          },
                    child: isLoadingValue
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeCap: StrokeCap.round,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.invoiceData.image.isEmpty
                                ? 'Create'
                                : 'Send Reminder',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              );
            }));
  }
}

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
