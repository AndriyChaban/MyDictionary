import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:db_service/db_service.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:google_api_service/google_api_service.dart';

import 'package:main_screen/main_screen.dart';
import 'package:translation_screen/translation_screen.dart';
import 'package:user_repository/user_repository.dart';

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

  runApp(MyDictionaryApp(
      dictionaryProvider: dictionaryProvider, userRepository: userRepository));
}

// TODO make stateless if necessary

class MyDictionaryApp extends StatefulWidget {
  const MyDictionaryApp(
      {required this.dictionaryProvider,
      Key? key,
      required this.userRepository})
      : super(key: key);

  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;

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

  void _onWordClicked(BuildContext context, String word, MainScreenBloc bloc) {
    GoRouter.of(context).goNamed(TranslationScreen.routeName,
        params: {'word': word}, extra: bloc);
  }

  void _goToView(BuildContext context, String routeName) {
    GoRouter.of(context).pushNamed(routeName);
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
              goToView: _goToView,
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
                path: ':word',
                parentNavigatorKey: _rootNavigatorKey,
                name: TranslationScreen.routeName,
                builder: (context, state) {
                  MainScreenBloc bloc = state.extra as MainScreenBloc;
                  return TranslationScreen(
                      word: state.params['word']!, bloc: bloc);
                },
              ),
            ],
          ),
          GoRoute(
              path: '/dictionaries_view',
              name: DictionariesView.routeName,
              builder: (context, state) {
                print(state.location);
                return DictionariesView();
              })
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
