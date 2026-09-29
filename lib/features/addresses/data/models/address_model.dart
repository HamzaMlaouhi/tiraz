import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/address.dart';

class AddressModel extends Address {
  final bool isDefault;

  const AddressModel({required super.id, required super.label, required super.line, required this.isDefault});

  /// Mirrors `AddressesService.toDto` on the backend.
  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'] as String,
        label: LocalizedText.fromJson(json['label'] as Map<String, dynamic>),
        line: LocalizedText.fromJson(json['line'] as Map<String, dynamic>),
        isDefault: json['isDefault'] as bool,
      );
}
