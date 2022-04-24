import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import '../../components/animelist/index.dart';

import '../../data/mal-user.animelist.dart';
import '../../data/response.all_anime.dart';
import '../syncing/mal-updater.dart';

class AnimeItemIntegrationAction extends StatelessWidget {
  const AnimeItemIntegrationAction({
    Key? key,
    required this.item,
    required this.fallbackWidget,
  }) : super(key: key);

  final AnimeEntry item;
  final Widget fallbackWidget; // in case the MAL Status object is invalid or something.

  MalUserAnimeListStatus get malstatus => item.malStatus!;

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    IconData icon = Icons.check;
    switch (malstatus.status) {
      case "watching":
        if (malstatus.numEpisodesWatched >= item.latestEpisode) {
          statusColor = Colors.green;
        } else {
          statusColor = Colors.orangeAccent;
          icon = Icons.warning_rounded;
        }
        break;
      case "plan_to_watch":
        statusColor = Colors.lightBlueAccent;
        icon = Icons.info_rounded;
        break;
      case "on_hold":
        statusColor = Colors.orangeAccent;
        icon = Icons.info_rounded;
        break;
      case "dropped":
        statusColor = Colors.redAccent;
        icon = Icons.info_rounded;
        break;
      default:
        return fallbackWidget;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        height: 48,
        width: 48,
        child: TextButton(
          child: Icon(
            icon,
            color: statusColor,
            size: 24,
          ),
          onPressed: () {
            Momentum.controller<AnimelistController>(context).getUserAnimeDetails(item);
            showMalUpdater(context, item.slug);
          },
        ),
      ),
    );
  }
}
