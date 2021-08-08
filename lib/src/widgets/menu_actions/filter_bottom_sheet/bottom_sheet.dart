import 'package:flutter/material.dart';

import '../../index.dart';
import 'index.dart';

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _BottomSheetWidget();
    },
  );
}

const _radius = BorderRadius.only(
  topLeft: Radius.circular(7),
  topRight: Radius.circular(7),
);

class _BottomSheetWidget extends StatefulWidget {
  const _BottomSheetWidget({Key? key}) : super(key: key);

  @override
  __BottomSheetWidgetState createState() => __BottomSheetWidgetState();
}

class __BottomSheetWidgetState extends State<_BottomSheetWidget> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TabController get tabController => _tabController!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: background,
        borderRadius: _radius,
      ),
      child: Column(
        children: [
          _TabHeader(tabController: tabController),
          Expanded(child: _TabContent(tabController: tabController)),
        ],
      ),
    );
  }
}

class _TabHeader extends StatelessWidget {
  const _TabHeader({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryBackground,
        borderRadius: _radius,
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: primary,
        tabs: [
          Tab(
            text: 'Title',
          ),
          Tab(
            text: 'Order by',
          ),
          Tab(
            text: 'Sort by',
          ),
          Tab(
            text: 'Status',
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        DisplayOption(),
        OrderByOption(),
        SortByOption(),
        StatusOption(),
      ],
    );
  }
}
