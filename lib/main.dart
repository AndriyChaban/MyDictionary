import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:db_service/db_service.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:settings_screen/settings_screen.dart';
import 'package:simple_translation_card/simple_translation_card.dart';
import 'package:user_repository/user_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:components/components.dart';
import 'package:wizz_training_module/wizz_training_module.dart';
import 'package:google_api_service/google_api_service.dart';

import 'package:main_screen/main_screen.dart';
import 'package:translation_screen/translation_screen.dart';
import 'package:wizz_decks_screen/wizz_decks_screen.dart';
import 'package:wizz_cards_screen/wizz_cards_screen.dart';
import 'package:dictionaries_screen/dictionaries_screen.dart';
import 'package:search_word_screen/search_word_screen.dart';
import 'package:flashcards_screen/flashcards_screen.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool requestFocus = true;

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
        .pushNamed(TranslationScreen.routeName, pathParameters: {'word': word});
  }

  void _onAddCardToWizzDeck(BuildContext context, DictionaryDM dictionary) {
    GoRouter.of(context).goNamed(WizzDecksScreen.routeName, extra: dictionary);
  }

  void _pop(BuildContext context, dynamic result) {
    GoRouter.of(context).pop(result);
  }

  // TODO clear history

  void _onAppBarBackPressedInTranslationScreen(BuildContext context) {
    context.goNamed(SearchWordScreen.routeName);
  }

  void _onPressedTranslateWord(BuildContext context) async {
    final response = await _checkAndStopTraining(context);
    if (response && mounted) {
      final context_ = _scaffoldKey.currentState!.context;
      GoRouter.of(context_).goNamed(SearchWordScreen.routeName);
    }
  }

  void _onPressedManageDictionaries(BuildContext context) async {
    final response = await _checkAndStopTraining(context);
    if (response && mounted) {
      final context_ = _scaffoldKey.currentState!.context;
      GoRouter.of(context_).goNamed(DictionariesScreen.routeName);
    }
  }

  void _onPressedWizzDecks(BuildContext context) async {
    final response = await _checkAndStopTraining(context);
    if (response && mounted) {
      final context_ = _scaffoldKey.currentState!.context;
      _goToWizzDeckFromFlashCardsScreen(context_);
    }
  }

  void _onPressedSettings(BuildContext context) async {
    final response = await _checkAndStopTraining(context);
    if (response && mounted) {
      final context_ = _scaffoldKey.currentState!.context;
      GoRouter.of(context_).goNamed(SettingsScreen.routeName);
    }
  }

  void _goToWizzDeckFromFlashCardsScreen(BuildContext context,
      {bool force = false}) {
    GoRouter.of(context).goNamed(WizzDecksScreen.routeName, extra: null);
  }

  Future<bool> _checkAndStopTraining(BuildContext context) async {
    if (GoRouter.of(context).location == '/flash_cards_screen') {
      final response = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ConfirmCancelDialog(
              title: 'Stop training?',
              message: 'All progress will be lost.',
              onCancel: () => _pop(context, false),
              onConfirm: () => _pop(context, true));
        },
      );
      if (response == true && mounted) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  void _backToSearchWordScreen(BuildContext context, String word) {
    requestFocus = false;
    context
        .goNamed(TranslationScreen.routeName, pathParameters: {'word': word});
  }

  void _onPushToSimpleTranslationCard(BuildContext context, dynamic payload) {
    final extra = payload as WizzCardDM;
    GoRouter.of(context).pushNamed(SimpleTranslationCard.routeName,
        extra: extra, pathParameters: {'word': extra.word});
  }

  void _onPushToWizzCardsScreen(BuildContext context, dynamic payload) {
    final WizzDeckDM deck = payload['deck'];
    // final DictionaryDM dictionary = payload['dictionaryFromTranslationScreen'];
    GoRouter.of(context).pushNamed(WizzCardsScreen.routeName,
        extra: payload, pathParameters: {'deck': deck.name});
  }

  void _onPressedStartLearning(
      BuildContext context, WizzDeckDM deck, bool isDirectLearning, int index) {
    GoRouter.of(context).goNamed(FlashCardsScreen.routeName, extra: {
      'deck': deck,
      'isDirectLearning': isDirectLearning,
      'index': index
    });
  }

  Widget _transitionBuilder(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.9, end: 1).animate(animation),
        child: child,
      ),
    );
  }

  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/search_word_screen',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainScreen(
              key: state.pageKey,
              scaffoldKey: _scaffoldKey,
              userRepository: widget.userRepository,
              onPressedManageDictionaries: _onPressedManageDictionaries,
              onPressedTranslateWord: _onPressedTranslateWord,
              onPressedWizzDecks: _onPressedWizzDecks,
              onPressedSettings: _onPressedSettings,
              child: child);
        },
        routes: [
          GoRoute(
            path: '/search_word_screen',
            parentNavigatorKey: _shellNavigatorKey,
            name: SearchWordScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPage(
                  key: state.pageKey,
                  // reverseTransitionDuration: Duration.zero,
                  transitionDuration: const Duration(milliseconds: 200),
                  child: SearchWordScreen(
                      userRepository: widget.userRepository,
                      dictionaryProvider: widget.dictionaryProvider,
                      onWordClicked: _onWordClicked,
                      requestFocus: requestFocus,
                      scaffoldKey: _scaffoldKey,
                      pop: _pop),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return _transitionBuilder(animation, child);
                  });
            },
            routes: [
              GoRoute(
                path: r'word$:word',
                // parentNavigatorKey: _rootNavigatorKey,
                name: TranslationScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return CustomTransitionPage(
                      key: state.pageKey,
                      // reverseTransitionDuration: Duration.zero,
                      transitionDuration: const Duration(milliseconds: 200),
                      child: TranslationScreen(
                        key: state.pageKey,
                        word: state.pathParameters['word']!,
                        dictionaryProvider: widget.dictionaryProvider,
                        userRepository: widget.userRepository,
                        onAppBarBackPressed: () =>
                            _onAppBarBackPressedInTranslationScreen(context),
                        onWordClicked: (word) => _onWordClicked(context, word),
                        onAddCardToWizzDeck: _onAddCardToWizzDeck,
                      ),
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        return _transitionBuilder(animation, child);
                      });
                },
              ),
            ],
          ),
          GoRoute(
              path: '/dictionaries_screen',
              parentNavigatorKey: _shellNavigatorKey,
              name: DictionariesScreen.routeName,
              builder: (context, state) {
                return DictionariesScreen(
                    key: state.pageKey,
                    scaffoldKey: _scaffoldKey,
                    dictionaryProvider: widget.dictionaryProvider,
                    userRepository: widget.userRepository,
                    pop: _pop);
              }),
          GoRoute(
              path: '/wizz_decks',
              // parentNavigatorKey: _rootNavigatorKey,
              parentNavigatorKey: _shellNavigatorKey,
              name: WizzDecksScreen.routeName,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final dictionary = state.extra as DictionaryDM?;
                return CustomTransitionPage(
                    key: state.pageKey,
                    transitionDuration: const Duration(milliseconds: 200),
                    child: WizzDecksScreen(
                        key: state.pageKey,
                        scaffoldKey: _scaffoldKey,
                        wizzTrainingModule: widget.wizzTrainingModule,
                        dictionaryFromTranslationScreen: dictionary,
                        pop: _pop,
                        backToSearchWordScreen: _backToSearchWordScreen,
                        onPressedStartLearning: _onPressedStartLearning,
                        addRouteListener: _addRouteListener,
                        removeRouteListener: _removeRouteListener,
                        pushToWizzCardsScreen: _onPushToWizzCardsScreen),
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return _transitionBuilder(animation, child);
                    });
              },
              routes: [
                GoRoute(
                  path: r'deck$:deck',
                  name: WizzCardsScreen.routeName,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    final extra = state.extra as Map<String, dynamic>;
                    final deck = extra['deck'] as WizzDeckDM;
                    final dictionaryFromTranslationScreen =
                        extra['dictionaryFromTranslationScreen']
                            as DictionaryDM?;
                    return CustomTransitionPage(
                        key: state.pageKey,
                        transitionDuration: const Duration(milliseconds: 200),
                        child: WizzCardsScreen(
                            key: state.pageKey,
                            wizzTrainingModule: widget.wizzTrainingModule,
                            deck: deck,
                            dictionaryFromTranslationScreen:
                                dictionaryFromTranslationScreen,
                            pop: _pop,
                            backToSearchWordScreen: _backToSearchWordScreen,
                            pushToSimpleTranslationCard:
                                _onPushToSimpleTranslationCard),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
                          return _transitionBuilder(animation, child);
                        });
                  },
                )
              ]),
          GoRoute(
              path: '/flash_cards_screen',
              name: FlashCardsScreen.routeName,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final deck = (state.extra as Map)['deck'] as WizzDeckDM;
                final isDirectLearning =
                    (state.extra as Map)['isDirectLearning'] as bool;
                final index = (state.extra as Map)['index'] as int;
                return CustomTransitionPage(
                    key: state.pageKey,
                    transitionDuration: const Duration(milliseconds: 200),
                    child: FlashCardsScreen(
                        key: state.pageKey,
                        deck: deck,
                        isDirectLearning: isDirectLearning,
                        wizzTrainingModule: widget.wizzTrainingModule,
                        index: index,
                        pop: _pop,
                        goToWizzDeckPage: _goToWizzDeckFromFlashCardsScreen,
                        pushToSimpleTranslationCard:
                            _onPushToSimpleTranslationCard,
                        scaffoldKey: _scaffoldKey),
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return _transitionBuilder(animation, child);
                    });
              }),
          GoRoute(
              path: '/settings_screen',
              name: SettingsScreen.routeName,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage(
                    key: state.pageKey,
                    transitionDuration: const Duration(milliseconds: 200),
                    child: SettingsScreen(
                      userRepository: widget.userRepository,
                      scaffoldKey: _scaffoldKey,
                    ),
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return _transitionBuilder(animation, child);
                    });
              }),
        ],
      ),
      GoRoute(
          path: r'/simple-card$:word',
          name: SimpleTranslationCard.routeName,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final card = state.extra as WizzCardDM;
            return SimpleTranslationCard(
              key: state.pageKey,
              card: card,
            );
          },
          pageBuilder: (BuildContext context, GoRouterState state) {
            final card = state.extra as WizzCardDM;
            return CustomTransitionPage(
                key: state.pageKey,
                transitionDuration: const Duration(milliseconds: 200),
                child: SimpleTranslationCard(
                  key: state.pageKey,
                  card: card,
                ),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return _transitionBuilder(animation, child);
                });
          })
    ],
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserPrefsDM>(
        stream: widget.userRepository.getUserPreferences(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isDark;
            if (snapshot.data!.darkMode == DarkModeDM.systemSettings) {
              final brightness =
                  SchedulerBinding.instance.window.platformBrightness;
              isDark = brightness == Brightness.dark;
            } else {
              isDark = snapshot.data!.darkMode == DarkModeDM.alwaysDark;
            }
            // print(snapshot.data);
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'MyDictionary',
              theme: ThemeData(
                  primarySwatch: kPrimaryColor,
                  useMaterial3: true,
                  brightness: isDark ? Brightness.dark : Brightness.light,
                  textTheme: TextTheme(
                    bodyLarge:
                        TextStyle(fontSize: snapshot.data!.fontSize.toDouble()),
                  )),
              routerConfig: _router,
            );
          } else {
            return const CenteredLoadingProgressIndicator();
          }
        });
  }
}
