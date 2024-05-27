import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:payment_ui/home_page.dart';
import 'package:uicons/uicons.dart';
// import 'package:video_player/video_player.dart';

import 'main.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with AutomaticKeepAliveClientMixin {
  late CachedVideoPlayerController _controller;
  late PageController _pageViewCtrl;

  @override
  void initState() {
    super.initState();
    _pageViewCtrl = PageController();

    _controller = CachedVideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.setPlaybackSpeed(0.5);
        Future.delayed(const Duration(seconds: 2), () async {
          _controller.pause();
        });
      });
  }

  final profileDelayDuration = const Duration(milliseconds: 200);
  final profileAnimationDuration = const Duration(milliseconds: 700);
  final profileCurve = Curves.easeInOut;

  bool showControls = true;

  int selectedIndex = 0;

  final infos = [
    {'All accounts are here': "We will take care of timely payments"},
    {'Pay and send invoices': 'Everything you need is now in one app'},
    {'Simple. Paperless. Secure': 'Keep track of payments and issue invoice'},
  ];

  void _onNextTapped() async {
    if (selectedIndex < (infos.length - 1)) {
      if (!_controller.value.isPlaying) {
        await _controller.play();
      }

      selectedIndex++;
      setState(() {});
      _pageViewCtrl.animateToPage(selectedIndex,
          duration: const Duration(seconds: 2), curve: Curves.easeInOut);

      await _controller.setPlaybackSpeed(2);
      await Future.delayed(const Duration(seconds: 2));
      await _controller.pause();

      return;
    }

    await Future.delayed(Duration.zero).then((value) async {
      await _controller.play();
      await _controller.setPlaybackSpeed(1).then((value) {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            reverseTransitionDuration: const Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) {
              return BasePage(controller: _controller);
            },
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Hero(
            tag: videoUrl,
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black,
                width: double.infinity,
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: 4,
                  child: Transform.translate(
                    offset: const Offset(-100, 0),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CachedVideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            if (selectedIndex == 0) {
                              return;
                            }

                            setState(() {
                              selectedIndex--;
                            });
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: (selectedIndex == 0)
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                  )
                                : Icon(
                                    UIcons.regularRounded.arrow_left,
                                    color: Colors.white,
                                  ),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                            controller: _pageViewCtrl,
                            itemCount: infos.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    infos[index].keys.single,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 42,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    infos[index].values.single,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }),
                      ),
                      Row(
                        children: List.generate(infos.length, (idx) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: AnimatedContainer(
                              width: (selectedIndex == idx) ? 20 : 8,
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (selectedIndex == idx)
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              duration: const Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  15,
                                ),
                              )),
                          onPressed: _onNextTapped,
                          child: Text(
                            selectedIndex == (infos.length - 1)
                                ? "Start"
                                : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
