import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../components/sources/index.dart';
import '../index.dart';
import '../listing/index.dart';
import '../menu_actions/news_guide/index.dart';

class SourcesPage extends StatelessWidget {
  const SourcesPage({Key? key}) : super(key: key);

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
              showSourcesGuide(context);
            },
          ),
        ],
      ),
      body: MomentumBuilder(
        controllers: [SourcesController],
        builder: (context, snapshot) {
          var sources = snapshot<SourcesModel>();
          if (sources.loading) {
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
                  itemCount: sourcesList.length,
                  // physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = sources.sourcesSubscriptionList[index];
                    return NewsSourceItem(
                      item: item,
                      following: item.following,
                      isLastItem: index == sources.sourcesSubscriptionList.length - 1,
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
