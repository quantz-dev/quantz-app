import 'package:flutter/material.dart';

import 'index.dart';

class TabviewWidget extends StatefulWidget {
  const TabviewWidget({
    Key? key,
    required this.views,
    required this.tabs,
  }) : super(key: key);

  final List<Widget> views;
  final List<Widget> tabs;

  @override
  _TabviewWidgetState createState() => _TabviewWidgetState();
}

class _TabviewWidgetState extends State<TabviewWidget> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabController = TabController(initialIndex: 0, length: widget.views.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: widget.views,
          ),
        ),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: secondaryBackground,
            boxShadow: [getShadow(-0.5)],
          ),
          child: TabBar(
            controller: tabController,
            tabs: widget.tabs,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.transparent,
            labelPadding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            labelColor: primary,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicator: BoxDecoration(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
