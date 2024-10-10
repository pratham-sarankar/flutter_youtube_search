extension MapExtension on Map<String, dynamic> {
  /// Get the value from a nested map
  dynamic getNestedValue(List<dynamic> path) {
    dynamic value = this;
    for (var key in path) {
      value = value?[key];
    }
    return value;
  }
}
