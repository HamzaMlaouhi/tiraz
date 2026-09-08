extension FirstOrNullExtension<T> on Iterable<T> {
  /// The first element, or `null` if the iterable is empty — avoids
  /// pulling in `package:collection` for this one helper.
  T? get firstOrNull => isEmpty ? null : first;
}
