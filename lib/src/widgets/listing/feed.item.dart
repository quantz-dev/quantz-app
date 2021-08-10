import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/feed/feed.interface.dart';
import '../index.dart';

class FeedItemWidget extends StatelessWidget {
  const FeedItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.title,
      showDuration: Duration(milliseconds: item.tooltipDuration),
      child: ListTile(
        title: Text(
          item.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
          ),
          maxLines: 1,
        ),
        subtitle: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Opacity(
                opacity: 0.5, // don't make the icon standout and distract the user.
                child: Image.asset(
                  item.sourceImage,
                  width: 12,
                  height: 12,
                ),
              ),
            ),
            SizedBox(width: 4),
            Text(
              item.sourceDomain,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            Spacer(),
            Text(
              item.ago,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
        minVerticalPadding: 8,
        onTap: () {
          try {
            launch(item.permalink);
          } catch (e) {
            showToast(e.toString(), error: true);
          }
        },
      ),
    );
  }
}
