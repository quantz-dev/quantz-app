import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import '../listing/ad.feed_tab.dart';

import '../../components/feed/index.dart';
import '../colors.dart';
import '../listing/feed.item.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        backgroundColor: secondaryBackground,
        elevation: 0,
      ),
      body: MomentumBuilder(
        controllers: [FeedController],
        builder: (context, snapshot) {
          final feed = snapshot<FeedModel>();
          return feed.loading
              ? Center(
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: feed.feedItems.length,
                        itemBuilder: (context, index) {
                          return FeedItemWidget(item: feed.feedItems[index]);
                        },
                      ),
                  ),
                  AdFeedTab(),
                ],
              );
        },
      ),
    );
  }
}
