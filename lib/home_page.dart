import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_ui/details_page.dart';
import 'package:payment_ui/main.dart';
import 'package:payment_ui/utils.dart';
import 'package:uicons/uicons.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.controller});
  final CachedVideoPlayerController controller;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pages = [
      HomePage(
        controller: widget.controller,
      ),
      Container(),
      Container(),
    ];
  }

  List pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          enableFeedback: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.square_sharp,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 55,
                child: FloatingActionButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: CircleBorder(),
                  elevation: 0,
                  onPressed: null,
                  child: Icon(
                    Icons.add,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              label: 'Schools',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'Schools',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          unselectedItemColor: Theme.of(context).primaryColor.withOpacity(0.2),
          selectedItemColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

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
                child: const TopColumn(),
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
                child: const BottomColumn(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomColumn extends StatelessWidget {
  const BottomColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
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
        ...List.generate(
          invoices.length,
          (index) => InvoiceItem(
            data: invoices[index],
          ),
        ),
      ],
    );
  }
}

class TopColumn extends StatelessWidget {
  const TopColumn({
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
          height: 32,
        ),
      ],
    );
  }
}

class InvoiceItem extends StatelessWidget {
  const InvoiceItem({
    super.key,
    required this.data,
  });

  final InvoiceData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailsPage(
                    invoiceData: data,
                  )));
        },
        child: Card(
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                        image: DecorationImage(
                          image: NetworkImage(data.image),
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
                          data.receiverName,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '#${data.id}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
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
                    StatusContainer(status: data.status),
                    Text(
                      '\$${(data.subtotal + data.tax)}',
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
      ),
    );
  }
}

class StatusContainer extends StatelessWidget {
  const StatusContainer({
    super.key,
    required this.status,
  });

  final InvoiceStatus status;

  Color _getTextColor() {
    switch (status) {
      case InvoiceStatus.draft:
        return Colors.grey;
      case InvoiceStatus.done:
        return Colors.green;
      case InvoiceStatus.rejected:
        return Colors.red;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getTextColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.name,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: _getTextColor(),
            ),
      ),
    );
  }
}
