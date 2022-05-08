import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SyncTabScrollPage extends StatefulWidget {
  const SyncTabScrollPage({Key? key}) : super(key: key);

  @override
  State<SyncTabScrollPage> createState() => _SyncTabScrollPageState();
}

class _SyncTabScrollPageState extends State<SyncTabScrollPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool isMoving = false;
  late TabController _tabController;
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      print("didTap Tab");
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    _itemPositionsListener.itemPositions.addListener(() {
      _onListViewScrolled();
    });
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onListViewScrolled);
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('かもめ大学'),
        backgroundColor: const Color(0xff213A9F),
      ),
      body: Column(
        children: [
          _tabBar(),
          Flexible(child: _syncListView()),
        ],
      ),
    );
  }

  Widget _syncListView() {
    return ScrollablePositionedList.builder(
        itemPositionsListener: _itemPositionsListener,
        itemScrollController: _itemScrollController,
        itemCount: 7,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 400,
            child: Text('This is $index'),
          );
        });
  }

  Widget _tabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF8F9F9),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorWeight: 3,
        indicatorColor: const Color(0xff213A9F),
        onTap: (index) async {
          // setState(() {
          //   _currentIndex = index;
          // });
          isMoving = true;
          await _itemScrollController.scrollTo(
              index: index, duration: const Duration(milliseconds: 100));
          isMoving = false;
        },
        tabs: [
          Tab(
            child: Text(
              '学校トップ',
              style: TextStyle(
                color: _currentIndex == 0
                    ? const Color(0xff213A9F)
                    : const Color(0xffCFDFD8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            child: Text(
              '特徴',
              style: TextStyle(
                color: _currentIndex == 1
                    ? const Color(0xff213A9F)
                    : const Color(0xffCFDFD8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            child: Text(
              '学部・学科・コース',
              style: TextStyle(
                color: _currentIndex == 2
                    ? const Color(0xff213A9F)
                    : const Color(0xffCFDFD8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            child: Text(
              '学費',
              style: TextStyle(
                color: _currentIndex == 3
                    ? const Color(0xff213A9F)
                    : const Color(0xffCFDFD8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            child: Text(
              '就職・資格',
              style: TextStyle(
                color: _currentIndex == 4
                    ? const Color(0xff213A9F)
                    : const Color(0xffCFDFD8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            child: Text(
              '先輩記事',
              style: TextStyle(
                color: _currentIndex == 5
                    ? const Color(0xff213A9F)
                    : const Color(0xffCFDFD8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Tab(
            child: Text(
              'お問い合わせ',
              style: TextStyle(
                color: _currentIndex == 6
                    ? const Color(0xff213A9F)
                    : const Color(0xffCFDFD8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onListViewScrolled() async {
    if (isMoving) {
      return;
    }
    var positions = _itemPositionsListener.itemPositions.value;
    positions
        .toList()
        .sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge));
    print(positions);

    /// Target [ScrollView] is not attached to any views and/or has no listeners.
    if (positions.isEmpty) return;

    /// Capture the index of the first [ItemPosition]. If the saved index is same
    /// with the current one do nothing and return.
    var targetIndex = 0;
    var min = 1000.0;
    for (var element in positions) {
      if (element.itemLeadingEdge < min) {
        targetIndex = element.index;
        min = element.itemLeadingEdge;
      }
    }
    final firstIndex = positions.elementAt(0).index;
    // if (_currentIndex == firstIndex) return;
    if (_currentIndex == targetIndex) return;
    setState(() {
      _currentIndex = targetIndex;
    });
    // print("_currentIndex: $_currentIndex}");

    /// A new index has been detected.
    // await _handleTabScroll(firstIndex);
    _tabController.animateTo(_currentIndex);
  }
}
