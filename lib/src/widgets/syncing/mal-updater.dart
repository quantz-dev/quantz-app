import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:quantz/src/widgets/icon_button.dart';
import '../../components/animelist/index.dart';
import '../../data/mal-user.animelist.dart';

import '../../data/response.all_anime.dart';
import '../button.dart';

showMalUpdater(BuildContext context, AnimeEntry anime) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: _MalUpdater(anime: anime),
      );
    },
  );
}

class _MalUpdater extends StatefulWidget {
  const _MalUpdater({
    Key? key,
    required this.anime,
  }) : super(key: key);

  final AnimeEntry anime;

  @override
  __MalUpdaterState createState() => __MalUpdaterState();
}

class __MalUpdaterState extends State<_MalUpdater> {
  MalUserAnimeListStatus? _status;

  MalUserAnimeListStatus get status => _status!;

  String statusText = '';

  AnimelistController? _animelistController;

  AnimelistController get animelistController => _animelistController!;

  String get latestEpisode {
    if (widget.anime.latestEpisode > 0) {
      return '${widget.anime.latestEpisode}';
    }
    return '?';
  }

  int get behindEpisodes {
    final latest = widget.anime.latestEpisode;
    if (latest > 0 && latest > status.numEpisodesWatched) {
      return (latest - status.numEpisodesWatched).toInt();
    }
    return 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _status = widget.anime.malStatus;
    _animelistController = Momentum.controller<AnimelistController>(context);
    updateStatusText(_status);
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
                      widget.anime.displayTitle,
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
                            statusText,
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
                    text: widget.anime.following ? 'Unfollow' : 'Follow',
                    color: Colors.transparent,
                    onPressed: () {
                      Momentum.controller<AnimelistController>(context).toggleTopic(
                        widget.anime,
                        status: !widget.anime.following,
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
    final updated = await animelistController.updateUserAnimeDetails(widget.anime, episodeWatched);
    if (updated != null) {
      _status = updated;
      updateStatusText(_status);
      if (mounted) {
        setState(() {});
      }
    }
  }

  void updateStatusText(MalUserAnimeListStatus? statusDetails) {
    switch (statusDetails?.status) {
      case "plan_to_watch":
        statusText = "You\'re still planning to watch this.";
        break;
      case "completed":
        statusText = "You already finished watching this.";
        break;
      case "dropped":
        statusText = "You've stopped watching this.";
        break;
      case null:
        statusText = "There was an error getting details.";
        break;
      default:
        statusText = 'You\'re behind $behindEpisodes episode${behindEpisodes <= 1 ? "" : "s"}';
    }
  }
}
