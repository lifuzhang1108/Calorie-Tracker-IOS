import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/app/home/account/account_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/cupertino_home_scaffold.dart';
import 'package:starter_architecture_flutter_firebase/app/home/entries/entries_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/recipes/recipes_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.recipes;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.recipes: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.recipes: (_) => RecipesPage(),
      TabItem.entries: (_) => EntriesPage(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !(await navigatorKeys[_currentTab]!.currentState?.maybePop() ??
              false),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
