import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../components/animelist/index.dart';

class AnimeListRefresher extends StatelessWidget {
  const AnimeListRefresher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [AnimelistController],
      builder: (context, snapshot) {
        var animeList = snapshot<AnimelistModel>();

        if (animeList.refreshingList) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          );
        }

        return IconButton(
          onPressed: () {
            animeList.controller.refreshAnimeList();
          },
          icon: Icon(Icons.refresh),
        );
      },
    );
  }
}
