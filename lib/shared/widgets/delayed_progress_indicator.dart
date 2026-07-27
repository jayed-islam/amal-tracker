import 'dart:async';
import 'package:flutter/material.dart';

class DelayedLinearProgressIndicator extends StatefulWidget {
  final Color? color;
  final Color? backgroundColor;
  final Duration delay;

  const DelayedLinearProgressIndicator({
    super.key,
    this.color,
    this.backgroundColor,
    this.delay = const Duration(milliseconds: 400),
  });

  @override
  State<DelayedLinearProgressIndicator> createState() =>
      _DelayedLinearProgressIndicatorState();
}

class _DelayedLinearProgressIndicatorState
    extends State<DelayedLinearProgressIndicator> {
  bool _show = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) {
        setState(() => _show = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();
    return LinearProgressIndicator(
      color: widget.color,
      backgroundColor: widget.backgroundColor,
    );
  }
}
