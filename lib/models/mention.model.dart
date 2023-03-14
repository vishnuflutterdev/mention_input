import 'package:flutter/material.dart';
import 'package:mention_input/models/mention_data.model.dart';

class Mention {
  Mention({
    required this.triggerAnnotation,
    this.data = const [],
    this.highlightStyle,
  });

  final String triggerAnnotation;
  final List<MentionData> data;
  final TextStyle? highlightStyle;
}
