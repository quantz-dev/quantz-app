enum DisplayTitle {
  defaultTitle,
  english,
  japanese,
}

String displayTitleLabel(DisplayTitle displayTitle) {
  switch (displayTitle) {
    case DisplayTitle.defaultTitle:
      return 'Default';
    case DisplayTitle.english:
      return 'English';
    case DisplayTitle.japanese:
      return 'Japanese';
  }
}

enum OrderBy {
  title,
  episodeCount,
  episodeRelease,
  popularity,
  score,
}

String orderByLabel(OrderBy orderBy) {
  switch (orderBy) {
    case OrderBy.title:
      return 'Title';
    case OrderBy.episodeCount:
      return 'Episode Number';
    case OrderBy.episodeRelease:
      return 'Episode Release';
    case OrderBy.popularity:
      return 'Popularity';
    case OrderBy.score:
      return 'Score';
  }
}

enum SortBy {
  asc,
  desc,
}

String sortByLabel(SortBy sortBy) {
  switch (sortBy) {
    case SortBy.asc:
      return 'Ascending';
    case SortBy.desc:
      return 'Descending';
  }
}
