import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import '../../components/animelist/index.dart';
import '../../data/mal-user.animelist.dart';

import '../../data/response.all_anime.dart';

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
                          child: Container(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                updateEpisode(status.numEpisodesWatched + 1);
                              },
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
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
                            'You\'re behind $behindEpisodes episodes',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                  ],
                );
              },
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'CLOSE',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateEpisode(int episodeWatched) async {
    final updated = await animelistController.updateUserAnimeDetails(widget.anime, episodeWatched);
    if (updated != null) {
      setState(() {
        _status = updated;
      });
    }
  }
}
