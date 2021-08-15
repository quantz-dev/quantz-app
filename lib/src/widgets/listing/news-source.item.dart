import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/sources/index.dart';
import '../inputs/index.dart';

class NewsSourceItem extends StatelessWidget {
  const NewsSourceItem({
    Key? key,
    required this.item,
    required this.isLastItem,
    required this.following,
  }) : super(key: key);

  final NewsSource item;
  final bool isLastItem;
  final bool following;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: _SiteDetails(item: item)),
            ButtonSwith(
              value: following,
              onChanged: (value) {
                Momentum.controller<SourcesController>(context).toggleNews(item, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SiteDetails extends StatelessWidget {
  const _SiteDetails({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NewsSource item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ItemHeader(item: item),
        SizedBox(height: 4),
        _UrlMenu(item: item),
      ],
    );
  }
}

class _ItemHeader extends StatelessWidget {
  const _ItemHeader({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NewsSource item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SiteIcon(item: item),
        SizedBox(width: 6),
        _SiteName(item: item),
      ],
    );
  }
}

class _SiteIcon extends StatelessWidget {
  const _SiteIcon({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NewsSource item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Image.asset(
        item.iconAssetPath,
        width: 18,
        height: 18,
      ),
    );
  }
}

class _SiteName extends StatelessWidget {
  const _SiteName({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NewsSource item;

  @override
  Widget build(BuildContext context) {
    return Text(
      item.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
}

class _UrlMenu extends StatelessWidget {
  const _UrlMenu({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NewsSource item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: item.links
          .map(
            (e) => _LinkItem(
              name: e.name,
              link: e.url,
            ),
          )
          .toList(),
    );
  }
}

class _LinkItem extends StatelessWidget {
  const _LinkItem({
    Key? key,
    required this.name,
    required this.link,
  }) : super(key: key);

  final String name;
  final String link;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        try {
          launch(link);
        } catch (e) {
          print(e);
        }
      },
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 6),
        ),
        alignment: Alignment.centerLeft,
        minimumSize: MaterialStateProperty.all(Size.zero),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(width: 4),
          Icon(
            Icons.open_in_new,
            size: 12,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
