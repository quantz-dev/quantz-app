class NewsSource {
  const NewsSource({
    required this.name,
    required this.iconAssetPath,
    required this.firebaseTopic,
    required this.following,
    required this.links,
  });

  final String name;
  final String iconAssetPath;
  final String firebaseTopic;
  final bool following;
  final List<NewsSourceLink> links;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconAssetPath': iconAssetPath,
      'firebaseTopic': firebaseTopic,
      'following': following,
      'links': links.map((x) => x.toMap()).toList(),
    };
  }

  factory NewsSource.fromMap(Map<String, dynamic> map) {
    return NewsSource(
      name: map['name'],
      iconAssetPath: map['iconAssetPath'],
      firebaseTopic: map['firebaseTopic'],
      following: map['following'],
      links: List<NewsSourceLink>.from(map['links']?.map((x) => NewsSourceLink.fromMap(x))),
    );
  }

  NewsSource copyWith({
    String? name,
    String? iconAssetPath,
    String? firebaseTopic,
    bool? following,
    List<NewsSourceLink>? links,
  }) {
    return NewsSource(
      name: name ?? this.name,
      iconAssetPath: iconAssetPath ?? this.iconAssetPath,
      firebaseTopic: firebaseTopic ?? this.firebaseTopic,
      following: following ?? this.following,
      links: links ?? this.links,
    );
  }
}

class NewsSourceLink {
  const NewsSourceLink(this.name, this.url);

  final String name;
  final String url;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory NewsSourceLink.fromMap(Map<String, dynamic> map) {
    return NewsSourceLink(
      map['name'],
      map['url'],
    );
  }
}

const sourcesList = [
  const NewsSource(
    name: 'AnimeNewsNetwork',
    iconAssetPath: 'assets/sources-icons/ann.png',
    firebaseTopic: 'anime_news_network',
    following: false,
    links: [
      const NewsSourceLink('Homepage', 'https://www.animenewsnetwork.com/'),
    ],
  ),
  const NewsSource(
    name: 'Livechart Headlines',
    iconAssetPath: 'assets/sources-icons/livechart.png',
    firebaseTopic: 'livechart_headlines',
    following: false,
    links: [
      const NewsSourceLink('Recent Anime Headlines', 'https://www.livechart.me/headlines'),
    ],
  ),
  const NewsSource(
    name: 'MyAnimeList',
    iconAssetPath: 'assets/sources-icons/mal.png',
    firebaseTopic: 'my_anime_list',
    following: false,
    links: [
      const NewsSourceLink('All News', 'https://myanimelist.net/news'),
      const NewsSourceLink('New Anime', 'https://myanimelist.net/news/tag/new_anime'),
    ],
  ),
  const NewsSource(
    name: 'r/anime - Subreddit',
    iconAssetPath: 'assets/sources-icons/reddit.png',
    firebaseTopic: 'r_anime_feed',
    following: false,
    links: [
      const NewsSourceLink('News', 'https://www.reddit.com/r/anime?f=flair_name:"News"'),
      const NewsSourceLink('Official Media', 'https://www.reddit.com/r/anime?f=flair_name:"Official Media"'),
    ],
  ),
];
