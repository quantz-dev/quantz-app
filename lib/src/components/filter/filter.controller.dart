import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import '../animelist/index.dart';
import 'index.dart';

class FilterController extends MomentumController<FilterModel> {
  @override
  FilterModel init() {
    return FilterModel(
      this,
      displayTitle: DisplayTitle.defaultTitle,
      sortBy: SortBy.desc,
      orderBy: OrderBy.episodeRelease,
      showOngoing: true,
      showUpcoming: true,
    );
  }

  AnimelistController get animeListCtrl => controller<AnimelistController>();

  void setDisplayTitle(DisplayTitle displayTitle) {
    model.update(displayTitle: displayTitle);
    animeListCtrl.flagEntries();
    animeListCtrl.arrangeList();
    animeListCtrl.separateList();
  }

  void setOrderBy(OrderBy orderBy) {
    model.update(orderBy: orderBy);
    animeListCtrl.flagEntries();
    animeListCtrl.arrangeList();
    animeListCtrl.separateList();
  }

  void setSortBy(SortBy sortBy) {
    model.update(sortBy: sortBy);
    animeListCtrl.arrangeList();
    animeListCtrl.separateList();
  }

  int compare(AnimeEntry a, AnimeEntry b) {
    switch (model.sortBy) {
      case SortBy.asc:
        return _compareOrder(a, b);
      case SortBy.desc:
        return _compareOrder(b, a);
    }
  }

  int _compareOrder(AnimeEntry x, AnimeEntry y) {
    switch (model.orderBy) {
      case OrderBy.title:
        return _compareTitle(x, y);
      case OrderBy.episodeCount:
        return x.latestEpisode.compareTo(y.latestEpisode);
      case OrderBy.episodeRelease:
        return x.episodeTimestamp.compareTo(y.episodeTimestamp);
      case OrderBy.popularity:
        return x.malTotalUsers.compareTo(y.malTotalUsers);
      case OrderBy.score:
        return x.malScore.compareTo(y.malScore);
    }
  }

  int _compareTitle(AnimeEntry x, AnimeEntry y) {
    switch (model.displayTitle) {
      case DisplayTitle.defaultTitle:
        return x.title.compareTo(y.title);
      case DisplayTitle.english:
        return x.malTitleEnglish.compareTo(y.malTitleEnglish);
      case DisplayTitle.japanese:
        return x.malTitleJapanese.compareTo(y.malTitleJapanese);
    }
  }

  void toggleOngoing() {
    model.update(showOngoing: !model.showOngoing);
    animeListCtrl.arrangeList();
    animeListCtrl.separateList();
  }

  void toggleUpcoming() {
    model.update(showUpcoming: !model.showUpcoming);
    animeListCtrl.arrangeList();
    animeListCtrl.separateList();
  }
}
