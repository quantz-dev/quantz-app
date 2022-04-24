import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:quantz/src/widgets/icon_button.dart';
import '../../components/animelist/index.dart';
import '../../data/mal-user.animelist.dart';

import '../../data/response.all_anime.dart';
import '../button.dart';

showMalUpdater(BuildContext context, String slug) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: _MalUpdater(slug: slug),
      );
    },
  );
}

class _MalUpdater extends StatefulWidget {
  const _MalUpdater({
    Key? key,
    required this.slug,
  }) : super(key: key);

  final String slug;

  @override
  __MalUpdaterState createState() => __MalUpdaterState();
}

class __MalUpdaterState extends State<_MalUpdater> {
  MalUserAnimeListStatus get status => anime.malStatus ?? MalUserAnimeListStatus();

  AnimelistController? _animelistController;

  AnimelistController get animelistController => _animelistController!;

  AnimeEntry get anime {
    return animelistController.getAnimeItem(widget.slug);
  }

  String get latestEpisode {
    if (anime.latestEpisode > 0) {
      return '${anime.latestEpisode}';
    }
    return '?';
  }

  int get behindEpisodes {
    final latest = anime.latestEpisode;
    if (latest > 0 && latest > status.numEpisodesWatched) {
      return (latest - status.numEpisodesWatched).toInt();
    }
    return 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animelistController = Momentum.controller<AnimelistController>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(12),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MomentumBuilder(
              controllers: [AnimelistController],
              builder: (context, snapshot) {
                final model = snapshot<AnimelistModel>();
                if (model.loadingUserAnimeDetails) {
                  return Center(
                    child: SizedBox(
                      height: 36,
                      width: 36,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      anime.displayTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 99,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                updateEpisode(status.numEpisodesWatched - 1);
                              },
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${status.numEpisodesWatched} / $latestEpisode',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 99,
                        ),
                        Expanded(
                          child: CustomIconButton(
                            color: Colors.transparent,
                            icon: Icons.add,
                            iconColor: Colors.blueAccent,
                            onPressed: () {
                              updateEpisode(status.numEpisodesWatched + 1);
                            },
                          ),
                        ),
                      ],
                    ),
                    behindEpisodes == 0
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : Text(
                            getStatusText(status),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                  ],
                );
              },
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    textColor: Colors.blueAccent,
                    text: anime.following ? 'Unfollow' : 'Follow',
                    color: Colors.transparent,
                    onPressed: () {
                      Momentum.controller<AnimelistController>(context).toggleTopic(
                        anime,
                        status: !anime.following,
                        flagEntry: true,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    textColor: Colors.redAccent,
                    text: 'CLOSE',
                    color: Colors.transparent,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateEpisode(int episodeWatched) async {
    final updated = await animelistController.updateUserAnimeDetails(anime, episodeWatched);
    if (updated != null) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  String getStatusText(MalUserAnimeListStatus? statusDetails) {
    switch (statusDetails?.status) {
      case "plan_to_watch":
        return "You\'re still planning to watch this.";
      case "completed":
        return "You already finished watching this.";
      case "dropped":
        return "You've stopped watching this.";
      case null:
        return "There was an error getting details.";
      default:
        return 'You\'re behind $behindEpisodes episode${behindEpisodes <= 1 ? "" : "s"}';
    }
  }
}
