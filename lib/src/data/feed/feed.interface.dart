import 'package:timeago/timeago.dart' as timeago;

abstract class FeedItem {
  String get title;

  /// Open browser with this link when clicked.
  String get permalink;

  /// For UI list sorting.
  int get utcTimestampSeconds;

  /// For UI to indicate where is this feed item coming from.
  String get sourceImage;

  /// For UI to indicate where is this feed item coming from.
  String get sourceDomain {
    var d = permalink.replaceAll('http://', '');
    d = d.replaceAll('https://', '');
    final index = d.indexOf('/');
    return d.substring(0, index);
  }

  /// For UI to indicate when did the news got posted by the source.
  String get ago {
    return timeago.format(DateTime.fromMillisecondsSinceEpoch(utcTimestampSeconds * 1000));
  }

  int get tooltipDuration {
    return title.length * 70; // 100ms per character
  }
}
