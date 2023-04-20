import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:db_service/db_service.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:simple_translation_card/simple_translation_card.dart';
import 'package:user_repository/user_repository.dart';
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
        .pushNamed(TranslationScreen.routeName, params: {'word': word});
  }

  void _onAddCardToWizzDeck(BuildContext context, DictionaryDM dictionary) {
    // print(dictionary.name);
    GoRouter.of(context).goNamed(WizzDecksScreen.routeName, extra: dictionary);
  }

  void _pop(BuildContext context, dynamic result) {
    GoRouter.of(context).pop(result);
  }

  // TODO clear history

  void _onAppBarBackPressed(BuildContext context) {
    context.goNamed(SearchWordScreen.routeName);
  }

  void _onPressedManageDictionaries(BuildContext context) {
    GoRouter.of(context).goNamed(DictionariesScreen.routeName);
  }

  void _onPressedTranslateWord(BuildContext context) {
    GoRouter.of(context).goNamed(SearchWordScreen.routeName);
  }

  void _onPressedWizzDecks(BuildContext context) {
    GoRouter.of(context).goNamed(WizzDecksScreen.routeName);
  }

  void _backToSearchWordScreen(BuildContext context, String word) {
    // GoRouter.of(context)
    //     .pushNamed(routeName, extra: payload, params: {'word': word});
    requestFocus = false;
    context.goNamed(TranslationScreen.routeName, params: {'word': word});
  }

  void _onPushToSimpleTranslationCard(BuildContext context, dynamic payload) {
    final extra = payload as WizzCardDM;
    GoRouter.of(context).pushNamed(SimpleTranslationCard.routeName,
        extra: extra, params: {'word': extra.word});
  }

  void _onPushToWizzCardsScreen(BuildContext context, dynamic payload) {
    final WizzDeckDM deck = payload['deck'];
    // final DictionaryDM dictionary = payload['dictionaryFromTranslationScreen'];
    GoRouter.of(context).pushNamed(WizzCardsScreen.routeName,
        extra: payload, params: {'deck': deck.name});
  }

  void _onPressedStartLearning(
      BuildContext context, WizzDeckDM deck, bool isDirectLearning, int index) {
    GoRouter.of(context).goNamed(FlashCardsScreen.routeName, extra: {
      'deck': deck,
      'isDirectLearning': isDirectLearning,
      'index': index
    });
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
              child: child);
        },
        routes: [
          GoRoute(
            path: '/search_word_screen',
            parentNavigatorKey: _shellNavigatorKey,
            name: SearchWordScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return SearchWordScreen(
                  userRepository: widget.userRepository,
                  dictionaryProvider: widget.dictionaryProvider,
                  onWordClicked: _onWordClicked,
                  requestFocus: requestFocus,
                  scaffoldKey: _scaffoldKey);
            },
            routes: [
              GoRoute(
                path: r'word$:word',
                parentNavigatorKey: _rootNavigatorKey,
                name: TranslationScreen.routeName,
                builder: (context, state) {
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
              path: '/dictionaries_screen',
              // parentNavigatorKey: _shellNavigatorKey,
              name: DictionariesScreen.routeName,
              builder: (context, state) {
                return DictionariesScreen(
                    scaffoldKey: _scaffoldKey,
                    dictionaryProvider: widget.dictionaryProvider,
                    userRepository: widget.userRepository);
              }),
          GoRoute(
              path: '/wizz_decks',
              // parentNavigatorKey: _rootNavigatorKey,
              parentNavigatorKey: _shellNavigatorKey,
              name: WizzDecksScreen.routeName,
              builder: (context, state) {
                final dictionary = state.extra as DictionaryDM?;
                return WizzDecksScreen(
                  key: state.pageKey,
                  scaffoldKey: _scaffoldKey,
                  wizzTrainingModule: widget.wizzTrainingModule,
                  dictionaryFromTranslationScreen: dictionary,
                  pop: _pop,
                  backToSearchWordScreen: _backToSearchWordScreen,
                  onPressedStartLearning: _onPressedStartLearning,
                  addRouteListener: _addRouteListener,
                  removeRouteListener: _removeRouteListener,
                  pushToWizzCardsScreen: _onPushToWizzCardsScreen,
                );
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
                          extra['dictionaryFromTranslationScreen']
                              as DictionaryDM?;
                      return WizzCardsScreen(
                          key: state.pageKey,
                          wizzTrainingModule: widget.wizzTrainingModule,
                          deck: deck,
                          dictionaryFromTranslationScreen:
                              dictionaryFromTranslationScreen,
                          pop: _pop,
                          backToSearchWordScreen: _backToSearchWordScreen,
                          pushToSimpleTranslationCard:
                              _onPushToSimpleTranslationCard);
                    })
              ]),
          GoRoute(
              path: '/flash_cards_screen',
              name: FlashCardsScreen.routeName,
              builder: (context, state) {
                final deck = (state.extra as Map)['deck'] as WizzDeckDM;
                final isDirectLearning =
                    (state.extra as Map)['isDirectLearning'] as bool;
                final index = (state.extra as Map)['index'] as int;
                return FlashCardsScreen(
                    deck: deck,
                    isDirectLearning: isDirectLearning,
                    wizzTrainingModule: widget.wizzTrainingModule,
                    index: index,
                    scaffoldKey: _scaffoldKey);
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
              card: card,
            );
          })
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MyDictionary',
      // theme: ThemeData.dark(),
      // theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Roboto'),
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      routerConfig: _router,
    );
  }
}
