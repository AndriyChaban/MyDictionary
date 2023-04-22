import 'dart:ui';

import 'package:domain_models/domain_models.dart';
import 'package:flashcards_screen/src/components/flipping_flash_card.dart';
import 'package:flutter/material.dart';

class FlippingCards extends StatefulWidget {
  const FlippingCards(
      {Key? key,
      required this.isDirectLearning,
      required this.card,
      required this.showExamples,
      required this.onPressedShowFullText,
      required this.onPressedOk,
      required this.onPressedNotOk})
      : super(key: key);
  final bool isDirectLearning;
  final WizzCardDM card;
  final bool showExamples;
  final VoidCallback onPressedShowFullText;
  final VoidCallback onPressedOk;
  final VoidCallback onPressedNotOk;

  @override
  State<FlippingCards> createState() => _FlippingCardsState();
}

class _FlippingCardsState extends State<FlippingCards> {
  late bool _showFrontTop;
  late bool _showFrontBottom;

  final String _assetPath1 = 'assets/pictures/drawer_picture.jpg';
  final String _assetPath2 = 'assets/pictures/flip_card_side.jpg';

  @override
  void initState() {
    super.initState();
    _showFrontTop = widget.isDirectLearning ? true : false;
    _showFrontBottom = !_showFrontTop;
  }

  Widget _buildSide({required bool isWord, required bool isFront}) {
    return SizedBox(
      width: 350,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            isFront ? _assetPath1 : _assetPath2,
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
            width: 350,
            height: 220,
          ),
          if (!isFront)
            isWord
                ? Text(
                    widget.card.word,
                    style: const TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                    softWrap: true,
                  )
                : SizedBox(
                    width: 350,
                    height: 200,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            '${widget.card.meaning}\n\n',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (widget.showExamples && widget.card.examples != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.card.examples!,
                              softWrap: true,
                            ),
                          )
                      ],
                    ),
                  ),
          // if (!isFront && !isWord && widget.isDirectLearning ||
          //     !isFront && isWord && !widget.isDirectLearning)
          //   Positioned(
          //     bottom: 20,
          //     left: 10,
          //     right: 10,
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(20),
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          //         child: Container(
          //           height: 30,
          //         ),
          //       ),
          //     ),
          //   ),
          if (!isFront && !isWord && widget.isDirectLearning ||
              !isFront && isWord && !widget.isDirectLearning)
            Positioned(
                bottom: 10,
                left: 50,
                right: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            blendMode: BlendMode.srcATop,
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: const SizedBox(
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: widget.onPressedNotOk,
                            icon: const Icon(
                              Icons.mood_bad,
                              color: Colors.red,
                              size: 30,
                            )),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            blendMode: BlendMode.srcATop,
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: const SizedBox(
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: widget.onPressedShowFullText,
                            icon: const Icon(
                              Icons.translate,
                              color: Colors.white,
                              size: 30,
                            )),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            blendMode: BlendMode.srcATop,
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: const SizedBox(
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: widget.onPressedOk,
                            icon: const Icon(
                              Icons.mood,
                              color: Colors.green,
                              size: 30,
                            )),
                      ],
                    ),
                  ],
                ))
        ],
      ),
    );
  }

  void _onTapCardTop() {
    if (_showFrontTop == true) return;
    setState(() {
      _showFrontTop = !_showFrontTop;
    });
  }

  void _onTapCardBottom() {
    if (_showFrontBottom == true) return;
    setState(() {
      _showFrontBottom = !_showFrontBottom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.isDirectLearning ? null : _onTapCardTop,
          child: FittedBox(
            child: FlippingFlashCard(
                showFront: _showFrontTop,
                front: _buildSide(isWord: true, isFront: true),
                back: _buildSide(isWord: true, isFront: false)),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: widget.isDirectLearning ? _onTapCardBottom : null,
          child: FlippingFlashCard(
              showFront: _showFrontBottom,
              front: _buildSide(isWord: false, isFront: true),
              back: _buildSide(isWord: false, isFront: false)),
        )
      ],
    );
  }
}
