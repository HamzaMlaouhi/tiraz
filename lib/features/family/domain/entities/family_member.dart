import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';

class FamilyMember extends Equatable {
  final LocalizedText initial;
  final LocalizedText name;
  final LocalizedText note;
  final Color noteColor;
  final int priceAed;

  const FamilyMember({
    required this.initial,
    required this.name,
    required this.note,
    required this.noteColor,
    required this.priceAed,
  });

  @override
  List<Object?> get props => [initial, name, note, noteColor, priceAed];
}
