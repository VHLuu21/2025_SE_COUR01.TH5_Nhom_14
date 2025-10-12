
import 'package:cinenight_movie_app/provider/text_size_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;
  final Alignment alignment;

  const AnimatedText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.alignment = Alignment.centerLeft,
  });

  // Hiệu ứng cho text khi thay đổi size 
  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TextSizeNotifier>();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      ),
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: alignment,
        children: [...previousChildren, if (currentChild != null) currentChild],
      ),
      child: Text(
        text,
        key: ValueKey<String>(
          context.locale.languageCode + notifier.size.toString() + text,
        ),
        style: style.copyWith(
          fontSize: style.fontSize,
        ),
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
