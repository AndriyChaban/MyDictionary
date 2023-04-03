import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:main_screen/main_screen.dart';

class TranslationScreen extends StatelessWidget {
  final String word;
  final MainScreenBloc? bloc;
  final void Function(String) onWordClicked;
  final VoidCallback onAppBarBackPressed;
  const TranslationScreen({
    required this.word,
    Key? key,
    required this.bloc,
    required this.onWordClicked,
    required this.onAppBarBackPressed,
  }) : super(key: key);
  static const routeName = 'translation-screen';

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onAppBarBackPressed,
          icon: Icon(Icons.arrow_back_outlined),
        ),
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
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No translation\n\nDictionary was deactivated',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              final headword = snapshot.data!.first.cards.first.headword;
              final text = snapshot.data!.first.cards.first.text;
              final dictionaryName = snapshot.data!.first.name;
              bloc!.handleAddToHistory(
                  card: CardDM(headword: headword, text: text),
                  dictionaryName: dictionaryName);
              return ListView.separated(
                itemBuilder: (context, index) => StyledTranslationCard(
                    onClick: onWordClicked,
                    headword: snapshot.data![index].cards.first.headword,
                    text: snapshot.data![index].cards.first.text,
                    isShort: false,
                    dictionaryName: snapshot.data![index].name),
                itemCount: snapshot.data!.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const DividerCommon(),
              );
            } else {
              return const CenteredLoadingProgressIndicator();
            }
          }),
    );
  }
}
