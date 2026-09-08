import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';

class Occasion extends Equatable {
  final LocalizedText name;
  final LocalizedText itemCount;
  final Color background;
  final String imageUrl;

  const Occasion({required this.name, required this.itemCount, required this.background, required this.imageUrl});

  @override
  List<Object?> get props => [name, itemCount, background, imageUrl];
}
