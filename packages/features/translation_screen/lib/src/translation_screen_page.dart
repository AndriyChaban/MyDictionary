import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:main_screen/main_screen.dart';

class TranslationScreen extends StatelessWidget {
  final String word;
  final MainScreenBloc? bloc;
  const TranslationScreen({
    required this.word,
    Key? key,
    this.bloc,
  }) : super(key: key);
  static const routeName = 'translation-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.toString()),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(child: Text('item 1')),
              PopupMenuItem(child: Text('item 2'))
            ];
          })
        ],
      ),
      body: FutureBuilder(
          future: bloc!.listOfWordTranslations(word),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemBuilder: (context, index) => StyledTranslationCard(
                    onClick: null,
                    headword: snapshot.data![index].headword,
                    text: snapshot.data![index].text,
                    isShort: false,
                  ),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const DividerCommon(),
                ),
              );
            } else {
              return const CenteredLoadingProgressIndicator();
            }
          }),
    );
  }
}
