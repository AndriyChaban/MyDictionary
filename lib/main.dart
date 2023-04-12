import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:db_service/db_service.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wizz_training_module/wizz_training_module.dart';
import 'package:google_api_service/google_api_service.dart';

import 'package:main_screen/main_screen.dart';
import 'package:translation_screen/translation_screen.dart';
import 'package:wizz_decks_screen/wizz_decks_screen.dart';
import 'package:wizz_cards_screen/wizz_cards_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyValueStorage = KeyValueStorage();
  final dbService = DBService();
  final googleApiService = GoogleAPIService();
  final userRepository = UserRepository(keyValueStorage: keyValueStorage);

  final dictionaryProvider = await DictionaryProvider.initializeProvider(
      keyValueStorage: keyValueStorage,
      dbService: dbService,
      googleApiService: googleApiService);
  final wizzTrainingModule = WizzTrainingModule(
    keyValueStorage: keyValueStorage,
    dictionaryProvider: dictionaryProvider,
  );

  runApp(MyDictionaryApp(
    dictionaryProvider: dictionaryProvider,
    userRepository: userRepository,
    wizzTrainingModule: wizzTrainingModule,
  ));
}

// TODO make stateless if necessary

class MyDictionaryApp extends StatefulWidget {
  const MyDictionaryApp({
    required this.dictionaryProvider,
    Key? key,
    required this.userRepository,
    required this.wizzTrainingModule,
  }) : super(key: key);

  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;
  final WizzTrainingModule wizzTrainingModule;

  @override
  State<MyDictionaryApp> createState() => _MyDictionaryAppState();
}

class _MyDictionaryAppState extends State<MyDictionaryApp> {
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  @override
  void initState() {
    super.initState();
  }

  void _addRouteListener(BuildContext context, VoidCallback function) {
    GoRouter.of(context).addListener(function);
  }

  void _removeRouteListener(BuildContext context, VoidCallback function) {
    GoRouter.of(context).removeListener(function);
  }

  void _onWordClicked(BuildContext context, String word) {
    GoRouter.of(context)
        .pushNamed(TranslationScreen.routeName, params: {'word': word});
  }

  void _onAddCardToWizzDeck(BuildContext context, DictionaryDM dictionary) {
    // print(dictionary.name);
    GoRouter.of(context)
        .pushNamed(WizzDecksScreenPage.routeName, extra: dictionary);
  }

  void _pop(BuildContext context, dynamic result) {
    GoRouter.of(context).pop(result);
  }

  // TODO repair unstable focusing
  // TODO clear history

  void _pushToNamed(BuildContext context, String routeName, {dynamic payload}) {
    //TODO fjx stacking dictViews
    // print('location: ${GoRouter.of(context).location}');
    // print('route: ${context.namedLocation(routeName)}');
    // print('!!! push');
    if (routeName == WizzCardsScreen.routeName) {
      final WizzDeckDM deck = payload['deck'];
      // final DictionaryDM dictionary = payload['dictionaryFromTranslationScreen'];
      GoRouter.of(context)
          .pushNamed(routeName, extra: payload, params: {'deck': deck.name});
    } else {
      if (context.namedLocation(routeName) == GoRouter.of(context).location) {
        Scaffold.of(context).closeDrawer();
        return;
      }
      GoRouter.of(context).pushNamed(routeName, extra: payload);
    }
    // print('location: ${GoRouter.of(context).location}');
    // print('route: ${context.namedLocation(DictionariesView.routeName)}');
  }

  void _goToNamed(BuildContext context, String routeName, {dynamic payload}) {
    if (routeName == WizzCardsScreen.routeName) {
      final WizzDeckDM deck = payload;
      GoRouter.of(context)
          .goNamed(routeName, extra: deck, params: {'deck': deck.name});
    } else {
      if (context.namedLocation(routeName) == GoRouter.of(context).location) {
        Scaffold.of(context).closeDrawer();
        return;
      }
      GoRouter.of(context).goNamed(routeName, extra: payload);
    }
    // print('location: ${GoRouter.of(context).location}');
    // print('route: ${context.namedLocation(routeName)}');
    // print('!!! go');
    // GoRouter.of(context).goNamed(routeName, extra: payload);
    // print('location: ${GoRouter.of(context).location}');
  }

  void _onAppBarBackPressed(BuildContext context) {
    context.goNamed(SearchView.routeName);
  }

  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/search_view',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainScreen(
              key: state.pageKey,
              dictionaryProvider: widget.dictionaryProvider,
              userRepository: widget.userRepository,
              pushToNamed: _pushToNamed,
              goToNamed: _goToNamed,
              child: child);
        },
        routes: [
          GoRoute(
            path: '/search_view',
            name: SearchView.routeName,
            builder: (BuildContext context, GoRouterState state) {
              // print(state.location);
              return SearchView(onWordClicked: _onWordClicked);
            },
            routes: [
              GoRoute(
                path: r'word$:word',
                parentNavigatorKey: _rootNavigatorKey,
                name: TranslationScreen.routeName,
                builder: (context, state) {
                  print(state.location);
                  return TranslationScreen(
                    word: state.params['word']!,
                    dictionaryProvider: widget.dictionaryProvider,
                    userRepository: widget.userRepository,
                    onAppBarBackPressed: () => _onAppBarBackPressed(context),
                    onWordClicked: (word) => _onWordClicked(context, word),
                    onAddCardToWizzDeck: _onAddCardToWizzDeck,
                  );
                },
              ),
            ],
          ),
          GoRoute(
              path: '/dictionaries_view',
              name: DictionariesView.routeName,
              builder: (context, state) {
                // print(state.location);
                return const DictionariesView();
              }),
        ],
      ),
      GoRoute(
          path: '/wizz_decks',
          parentNavigatorKey: _rootNavigatorKey,
          name: WizzDecksScreenPage.routeName,
          builder: (context, state) {
            // print(state.location);

            final dictionary = state.extra as DictionaryDM?;
            return WizzDecksScreenPage(
                key: state.pageKey,
                wizzTrainingModule: widget.wizzTrainingModule,
                dictionaryFromTranslationScreen: dictionary,
                // dictionaryProvider: widget.dictionaryProvider,
                // userRepository: widget.userRepository,
                pushToNamed: _pushToNamed,
                goToNamed: _goToNamed,
                pop: _pop,
                addRouteListener: _addRouteListener,
                removeRouteListener: _removeRouteListener);
          },
          routes: [
            GoRoute(
                path: r'deck$:deck',
                name: WizzCardsScreen.routeName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>;
                  final deck = extra['deck'] as WizzDeckDM;
                  final dictionaryFromTranslationScreen =
                      extra['dictionaryFromTranslationScreen'] as DictionaryDM?;
                  // print('Go');
                  return WizzCardsScreen(
                    key: state.pageKey,
                    wizzTrainingModule: widget.wizzTrainingModule,
                    deck: deck,
                    dictionaryFromTranslationScreen:
                        dictionaryFromTranslationScreen,
                    pushToNamed: _pushToNamed,
                    goToNamed: _goToNamed,
                    pop: _pop,
                  );
                })
          ])
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      routerConfig: _router,
    );
  }
}
