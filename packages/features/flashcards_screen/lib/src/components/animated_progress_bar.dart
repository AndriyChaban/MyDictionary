import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  final int maxValue;
  final int currentValue;
  final Color color;

  const AnimatedProgressBar(
      {Key? key,
      required this.maxValue,
      required this.currentValue,
      this.color = Colors.black})
      : super(key: key);

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
  double _progress = 0;
  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != oldWidget.currentValue) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${widget.currentValue - 1}/${widget.maxValue}   '),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              _progress = (widget.currentValue + _animation.value - 2) /
                  widget.maxValue;
              return Flexible(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 15,
                    value: _progress,
                  ),
                ),
              );
            },
          ),
          Text(
              '   ${((widget.currentValue - 1) / widget.maxValue).toStringAsFixed(2)}%'),
        ],
      ),
    );
  }
}
