import 'package:flutter/material.dart';

import '../../data/index.dart';
import '../index.dart';
import 'index.dart';

const _itemHeight = 66.0;

class AnimeList extends StatelessWidget {
  const AnimeList({
    Key? key,
    required this.list,
    this.showType = false,
    required this.topicLoading,
  }) : super(key: key);

  final List<AnimeEntry> list;
  final bool showType;
  final bool Function(String topic) topicLoading;

  @override
  Widget build(BuildContext context) {
    // await Momentum.controller<AnimelistController>(context).loadList();
    return list.isEmpty
        ? EmptyList()
        : ListView.builder(
            itemCount: list.length,
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemExtent: _itemHeight,
            cacheExtent: _itemHeight * 10,
            itemBuilder: (context, index) {
              var item = list[index];
              return AnimeItem(
                item: item,
                following: item.following,
                showType: showType,
                topicLoading: topicLoading(item.slug),
              );
            },
          );
  }
}
