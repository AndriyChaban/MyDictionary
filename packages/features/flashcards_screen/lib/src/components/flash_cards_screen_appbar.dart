import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class FlashCardsScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onTapMenu;
  final WizzDeckDM deck;
  final int index;

  const FlashCardsScreenAppBar(
      {Key? key,
      required this.onTapMenu,
      required this.deck,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kAppBarColor,
      leading: Column(
        children: [
          IconButton(icon: const Icon(Icons.menu), onPressed: onTapMenu),
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
              tag: 'deck-name-${index}',
              child: Text('Deck:   ${deck.name.toCapital()}')),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(deck.fromLanguage.toCapital()),
              const Icon(Icons.arrow_forward_rounded),
              Text(deck.toLanguage.toCapital()),
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
