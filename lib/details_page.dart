import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_ui/home_page.dart';
import 'package:payment_ui/main.dart';
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
    with SingleTickerProviderStateMixin {
  final slideTransDuration = const Duration(milliseconds: 800);
  late Animation<Offset> _slideAnimation;

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: slideTransDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
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
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        StatusContainer(status: widget.invoiceData.status)
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Invoice #${widget.invoiceData.id}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).hintColor),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.invoiceData.image),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.invoiceData.receiverName,
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
                    ),
                    SizedBox(height: 32),
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
                    SizedBox(height: 24),
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: 20),
                    SummaryRow(widget: widget),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.widget,
  });

  final DetailsPage widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Subtotal',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
        ),
        Text(
          '\$${widget.invoiceData.subtotal}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
        ),
      ],
    );
  }
}

class InvoiceItem extends StatelessWidget {
  const InvoiceItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=600',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Marcos Avery',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '#0912837628',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'done',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                  Text(
                    '\$37,197.9',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
