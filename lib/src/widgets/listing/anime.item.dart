import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/animelist/index.dart';
import '../../data/index.dart';
import '../index.dart';
import '../inputs/index.dart';
import 'anime.item-integration.dart';

final buttonStyle = ButtonStyle(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  padding: MaterialStateProperty.all(EdgeInsets.zero),
  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
);

class AnimeItem extends StatelessWidget {
  const AnimeItem({
    Key? key,
    required this.item,
    this.following = false,
    this.showType = false,
    this.topicLoading = false,
  }) : super(key: key);

  final AnimeEntry item;
  final bool following;
  final bool showType;
  final bool topicLoading;

  @override
  Widget build(BuildContext context) {
    final switchWidget = ButtonSwith(
      value: following,
      loading: topicLoading,
      onChanged: (value) async {
        final controller = Momentum.controller<AnimelistController>(context);
        await controller.toggleTopic(item, flagEntry: true);
      },
    );
    return TextButton(
      onPressed: () {
        try {
          final id = item.livechartId;
          if (id > 0) {
            launch('https://www.livechart.me/anime/$id/streams?hide_unavailable=true');
          } else {
            showToast('Missing from LiveChart.me', error: true);
          }
        } catch (e) {
          print(e);
        }
      },
      style: buttonStyle,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ThumbnailImg(
              url: item.thumbnailUrl,
              size: 42,
            ),
            SizedBox(width: 12),
            Expanded(child: _AnimeEntryDetails(item: item, showType: showType)),
            _AnimeItemOrderLabel(item: item),
            item.malStatus != null && !topicLoading
                ? AnimeItemIntegrationAction(
                    item: item,
                    fallbackWidget: switchWidget,
                  )
                : switchWidget,
          ],
        ),
      ),
    );
  }
}

class _AnimeEntryDetails extends StatelessWidget {
  const _AnimeEntryDetails({
    Key? key,
    required this.item,
    required this.showType,
  }) : super(key: key);

  final AnimeEntry item;
  final bool showType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnimeEntryName(item: item),
        SizedBox(height: 4),
        _AnimeItemInfo(showType: showType, item: item),
      ],
    );
  }
}

class _AnimeEntryName extends StatelessWidget {
  const _AnimeEntryName({
    Key? key,
    required this.item,
  }) : super(key: key);

  final AnimeEntry item;

  @override
  Widget build(BuildContext context) {
    return Text(
      item.displayTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
}

class _AnimeItemInfo extends StatelessWidget {
  const _AnimeItemInfo({
    Key? key,
    required this.showType,
    required this.item,
  }) : super(key: key);

  final bool showType;
  final AnimeEntry item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        !showType ? SizedBox() : _AnimeEntryType(item: item),
        item.hasEpisode ? _AnimeEpisodeNum(item: item) : SizedBox(),
        !item.hasEpisodeSchedule ? SizedBox() : _AnimeEpisodeTime(item: item),
        item.hasEpisode || item.hasEpisodeSchedule ? SizedBox() : TextBadge(item.status),
      ],
    );
  }
}

class _AnimeEpisodeNum extends StatelessWidget {
  const _AnimeEpisodeNum({
    Key? key,
    required this.item,
  }) : super(key: key);

  final AnimeEntry item;

  @override
  Widget build(BuildContext context) {
    return Text(
      'EP ${item.latestEpisode.toString()}',
      style: TextStyle(
        fontSize: 12,
        color: primary,
      ),
    );
  }
}

class _AnimeEntryType extends StatelessWidget {
  const _AnimeEntryType({
    Key? key,
    required this.item,
  }) : super(key: key);

  final AnimeEntry item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: TextBadge(
        item.type.toUpperCase(),
        size: 8,
        color: item.isSub ? Colors.green : Colors.purple,
      ),
    );
  }
}

class _AnimeEpisodeTime extends StatelessWidget {
  const _AnimeEpisodeTime({
    Key? key,
    required this.item,
  }) : super(key: key);

  final AnimeEntry item;

  @override
  Widget build(BuildContext context) {
    return Text(
      // '  ${timeago.format(DateTime.fromMillisecondsSinceEpoch(item.latestEpisodeTimestamp))}',
      '  ${item.episodeTime}', // optimized (compare with above line).
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.4),
      ),
    );
  }
}

class _AnimeItemOrderLabel extends StatelessWidget {
  const _AnimeItemOrderLabel({
    Key? key,
    required this.item,
  }) : super(key: key);

  final AnimeEntry item;

  @override
  Widget build(BuildContext context) {
    return item.orderLabel.isEmpty
        ? SizedBox()
        : TextBadge(
            item.orderLabel,
            color: Colors.grey,
            size: 11,
          );
  }
}
