import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_ui/pages/details_page.dart';
import 'package:payment_ui/main.dart';
import 'package:payment_ui/utils.dart';
import 'package:payment_ui/widgets/invoice_item.dart';
import 'package:uicons/uicons.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.controller,
  });
  final CachedVideoPlayerController controller;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: const _TopColumn(),
              ),
              Hero(
                tag: videoUrl,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 200,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Transform.scale(
                          scale: 4,
                          child: Transform.translate(
                            offset: const Offset(80, -60),
                            child: AspectRatio(
                              aspectRatio: widget.controller.value.aspectRatio,
                              child: CachedVideoPlayer(widget.controller),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 24.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Balance',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: const Color(0xff939494),
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  Icon(
                                    UIcons.boldRounded.menu_dots,
                                    color: Colors.white,
                                    size: 29,
                                  )
                                ],
                              ),
                              Text(
                                '\$3719.98',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      height: -0.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Text(
                                '.3815',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: const Color(0xff939494),
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _slideAnimation,
                child: const _BottomColumn(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomColumn extends StatelessWidget {
  const _BottomColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Invoices',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Icon(
              UIcons.regularRounded.arrow_right,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ValueListenableBuilder(
            valueListenable: invoices,
            builder: (context, invoicesValue, child) {
              return Column(
                children: List.generate(
                  invoicesValue.take(3).length,
                  (index) => InvoiceItem(
                    data: invoicesValue[index],
                  ),
                ),
              );
            })
      ],
    );
  }
}

class _TopColumn extends StatelessWidget {
  const _TopColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Icon(UIcons.regularRounded.bell),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Welcome back',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          'Max Griffin',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
