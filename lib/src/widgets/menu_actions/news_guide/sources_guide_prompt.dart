import 'package:flutter/material.dart';

import 'index.dart';

void showSourcesGuide(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return _SourcesGuidePrompt();
    },
  );
}

class _SourcesGuidePrompt extends StatelessWidget {
  const _SourcesGuidePrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GuideItem(
              title: 'AnimeNewsNetwork',
              body: 'Updates for anime, manga, the industry and also covid-19 updates related to anime or manga.',
            ),
            Divider(),
            GuideItem(
              title: 'Livechart Headlines',
              body: 'Anime news from many different sources curated by the LiveChart.me team to be quickly browsable.',
            ),
            Divider(),
            GuideItem(
              title: 'MyAnimeList',
              body: 'News about new anime announcement, original, manga, or light novel adaptations. Also includes news about manga and people like authors, voice actors or staffs.',
            ),
            Divider(),
            GuideItem(
              title: 'r/anime - Subreddit',
              body: 'Notifies for "News" and "Official Media" flair post from the subreddit. There are curated list of trusted users to notify while untrusted users get awaited for 1 hour for post deletion.',
            ),
          ],
        ),
      ),
    );
  }
}
