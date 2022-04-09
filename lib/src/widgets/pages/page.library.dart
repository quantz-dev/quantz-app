import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../components/animelist/index.dart';
import '../../components/integration/index.dart';
import '../index.dart';
import '../listing/index.dart';
import '../menu_actions/filter_bottom_sheet/index.dart';
import '../menu_actions/index.dart';

final searchFocusNode = FocusNode();

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends MomentumState<LibraryPage> with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  TabController? tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var animelistCtrl = Momentum.controller<AnimelistController>(context);
    final initialIndex = animelistCtrl.model.following.isNotEmpty ? 0 : 1;
    tabController = TabController(initialIndex: initialIndex, length: 3, vsync: this);
    searchController.text = animelistCtrl.model.searchQuery;

    animelistCtrl.listen<AnimelistEvent>(
      state: this,
      invoke: (event) {
        if (event.followingCount == 0) {
          tabController?.animateTo(1);
        } else {
          tabController?.animateTo(0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _FunctionalAppBar(searchController: searchController),
      body: Column(
        children: [
          _Header(tabController: tabController),
          Expanded(child: _MainContent(tabController: tabController)),
        ],
      ),
    );
  }
}

class _FunctionalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;

  const _FunctionalAppBar({Key? key, required this.searchController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [AnimelistController],
      builder: (context, snapshot) {
        var model = snapshot<AnimelistModel>();
        return model.searchMode ? _SearchAppBar(searchController: searchController) : _NormalAppBar();
      },
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }
}

class _NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Library'),
      backgroundColor: secondaryBackground,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Momentum.controller<AnimelistController>(context).model.update(searchMode: true);
            searchFocusNode.requestFocus();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.filter_list,
            color: Colors.yellow,
          ),
          onPressed: () {
            showFilterBottomSheet(context);
          },
        ),
        AnimeListRefresher(),
      ],
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }
}

class _SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;

  const _SearchAppBar({Key? key, required this.searchController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listController = Momentum.controller<AnimelistController>(context);
    return AppBar(
      title: TextFormField(
        controller: searchController,
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        onChanged: listController.search,
      ),
      backgroundColor: secondaryBackground,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            listController.model.update(
              searchMode: false,
              searchResults: [],
              searchQuery: '',
            );
            listController.separateList();
            searchController.clear();
            searchController.clearComposing();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryBackground,
        boxShadow: [getShadow(0.5)],
      ),
      child: Center(
        child: TabBar(
          controller: tabController,
          indicatorColor: primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
          ),
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelColor: primary,
          isScrollable: true,
          tabs: [
            Tab(child: Text('Following')),
            Tab(child: Text('Sub')),
            Tab(child: Text('Dub')),
          ],
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [
        AnimelistController,
        IntegrationController,
      ],
      builder: (context, snapshot) {
        var animeList = snapshot<AnimelistModel>();
        var import = snapshot<IntegrationModel>();

        final topicLoading = animeList.controller.isTopicLoading;

        // var loadingList = animeList.loadingList;
        var loadingImport = import.loading;
        // var loading = loadingList || loadingImport;
        var loading = loadingImport;
        return loading
            ? Center(
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      // physics: BouncingScrollPhysics(),
                      children: [
                        AnimeList(list: animeList.following, showType: true, topicLoading: topicLoading),
                        AnimeList(list: animeList.subList, topicLoading: topicLoading),
                        AnimeList(list: animeList.dubList, topicLoading: topicLoading),
                      ],
                    ),
                  ),
                  AdLibraryTab(),
                ],
              );
      },
    );
  }
}
