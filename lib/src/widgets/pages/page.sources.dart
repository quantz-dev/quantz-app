import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../components/news/index.dart';
import '../index.dart';
import '../listing/index.dart';
import '../menu_actions/news_guide/index.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sources'),
        backgroundColor: secondaryBackground,
        elevation: 0.80,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showNewsGuide(context);
            },
          ),
        ],
      ),
      body: MomentumBuilder(
        controllers: [NewsController],
        builder: (context, snapshot) {
          var news = snapshot<NewsModel>();
          if (news.loading) {
            return Center(
              child: SizedBox(
                height: 36,
                width: 36,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: newsSourceList.length,
                  // physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = news.newsSubscriptionList[index];
                    return NewsSourceItem(
                      item: item,
                      following: item.following,
                      isLastItem: index == news.newsSubscriptionList.length - 1,
                    );
                  },
                ),
              ),
              AdSourcesTab(),
            ],
          );
        },
      ),
    );
  }
}
