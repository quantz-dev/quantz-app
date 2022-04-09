import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/feed/index.dart';
import '../colors.dart';
import '../listing/ad.feed_tab.dart';
import '../listing/feed.item.dart';

class FeedPage extends StatelessWidget {
  FeedPage({Key? key}) : super(key: key);

  final RefreshController controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        backgroundColor: secondaryBackground,
        elevation: 0.80,
      ),
      body: MomentumBuilder(
        controllers: [FeedController],
        builder: (context, snapshot) {
          final feed = snapshot<FeedModel>();
          final items = feed.feed.items;
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
                      child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        physics: BouncingScrollPhysics(),
                        header: WaterDropMaterialHeader(
                          backgroundColor: secondaryBackground,
                        ),
                        onRefresh: () async {
                          await feed.controller.loadInitial(refresh: true);
                          controller.refreshCompleted();
                        },
                        onLoading: () async {
                          await feed.controller.loadMore();
                          controller.loadComplete();
                        },
                        controller: controller,
                        child: ListView.builder(
                          itemCount: items.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FeedItemWidget(item: items[index]);
                          },
                        ),
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
