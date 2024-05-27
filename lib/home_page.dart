import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_ui/main.dart';
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
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: 4,
                      child: Transform.translate(
                        offset: const Offset(-100, 0),
                        child: AspectRatio(
                          aspectRatio: widget.controller.value.aspectRatio,
                          child: CachedVideoPlayer(widget.controller),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _slideAnimation,
                child: BottomColumn(),
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
        ...List.generate(4, (index) => const InvoiceItem()),
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
