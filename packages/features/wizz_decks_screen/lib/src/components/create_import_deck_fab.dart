import 'dart:math';

import 'package:components/components.dart';
import 'package:flutter/material.dart';

class CreateImportDeckFAB extends StatefulWidget {
  final void Function() onClickCreateDeck;
  final void Function() onClickImportDeck;
  final bool isFromTranslationScreen;

  const CreateImportDeckFAB(
      {Key? key,
      required this.onClickCreateDeck,
      required this.onClickImportDeck,
      required this.isFromTranslationScreen})
      : super(key: key);

  @override
  State<CreateImportDeckFAB> createState() => _CreateImportDeckFABState();
}

class _CreateImportDeckFABState extends State<CreateImportDeckFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  late final _positionAnimation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCirc));
  late final _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.linear));
  bool _isExpanded = false;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        overlayEntry?.remove();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleButton() {
    if (!_isExpanded) {
      _showOverlay();
      _isExpanded = true;
    } else {
      _hideOverlay();
      _isExpanded = false;
    }
  }

  void _hideOverlay() {
    _animationController.reverse();
    _isExpanded = false;
  }

  void _instantlyHideOverlay() {
    _animationController.reset();
    _isExpanded = false;
  }

  Widget _buildButton(
      {required VoidCallback onPressed,
      required String text,
      required IconData iconData}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 2,
                    color: isDark
                        ? kPrimaryColor
                        : Theme.of(context).primaryColor)),
            child: TextButton.icon(
              icon: Icon(iconData),
              onPressed: onPressed,
              label: Text(text),
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final width = renderBox.size.width;
    // final height = renderBox.size.height;
    final offset = renderBox.localToGlobal(Offset(-width / 2, 0));
    overlayEntry = OverlayEntry(builder: (context) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: [
              GestureDetector(
                onTap: _toggleButton,
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Positioned(
                left: offset.dx - 1.6 * _positionAnimation.value * sin(pi / 12),
                top: offset.dy - _positionAnimation.value * cos(pi / 12),
                child: _buildButton(
                    text: 'Create New',
                    onPressed: _onClickCreate,
                    iconData: Icons.add),
              ),
              Positioned(
                left: offset.dx -
                    1.5 * _positionAnimation.value * sin(5 * pi / 12),
                top: offset.dy - _positionAnimation.value * cos(5 * pi / 12),
                child: _buildButton(
                    text: 'Import .xml',
                    onPressed: _onClickImport,
                    iconData: Icons.file_download_outlined),
              ),
            ],
          );
        },
      );
    });

    overlay.insert(overlayEntry!);
    _animationController
      ..reset()
      ..forward();
  }

  void _onClickButton() {
    _toggleButton();
  }

  void _onClickCreate() {
    _instantlyHideOverlay();
    widget.onClickCreateDeck();
  }

  void _onClickImport() {
    _instantlyHideOverlay();
    widget.onClickImportDeck();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.isFromTranslationScreen
          ? widget.onClickCreateDeck
          : _onClickButton,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: widget.isFromTranslationScreen
          ? const Icon(Icons.add)
          : AnimatedIcon(
              icon: AnimatedIcons.add_event, progress: _animationController),
    );
  }
}
