import 'dart:math';

import 'package:flutter/material.dart';

class FlippingFlashCard extends StatefulWidget {
  // final String assetPath;
  final bool showFront;
  final Widget front;
  final Widget back;

  const FlippingFlashCard(
      {Key? key,
      // required this.assetPath,
      required this.showFront,
      required this.front,
      required this.back})
      : super(key: key);

  @override
  State<FlippingFlashCard> createState() => _FlippingFlashCardState();
}

class _FlippingFlashCardState extends State<FlippingFlashCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final Curve _rotationCurve = Curves.elasticOut;
  late Widget _currentSide;
  late Widget _side1;
  late Widget _side2;
  double _rotation = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.showFront) {
      _side1 = widget.front;
      _currentSide = widget.front;
    } else {
      _side1 = widget.back;
      _currentSide = widget.back;
    }
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _onRotationComplete();
      })
      ..addListener(_updateRotation);
  }

  @override
  void didUpdateWidget(covariant FlippingFlashCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.showFront == true) return;
    if (widget.showFront != oldWidget.showFront) {
      _immediatelyFinish();
      _side2 = !widget.showFront ? widget.front : widget.back;
      _flipCard();
    }
    // if (widget.showFront != oldWidget.showFront) {
    //   _animationController.forward(from: 0);
    // }
  }

  void _flipCard() {
    _currentSide = _side1;
    _animationController.forward(from: 0);
  }

  void _immediatelyFinish() {
    if (_animationController.isAnimating) {
      _animationController.stop();
      _currentSide = _side2;
      _side1 = _side2;
    }
  }

  void _onRotationComplete() {
    setState(() {
      _animationController.value = 0;
      _side1 = _side2;
      _currentSide = _side2;
    });
  }

  void _updateRotation() {
    setState(() {
      _rotation = pi * _rotationCurve.transform(_animationController.value);
      if (_currentSide == _side1 && _rotation >= pi / 2) {
        _currentSide = _side2;
      } else if (_currentSide == _side2 && _rotation < pi / 2) {
        _currentSide = _side1;
      } else if (_currentSide == _side2) {
        _rotation = _rotation - pi;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_rotation),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _currentSide,
        ),
      ),
    );
  }
}
