/// Order metadata
///
/// This class is used to store the metadata of an order.
/// The user can store any kind of data in the metadata.
class OrderMetadata {
  OrderMetadata();

  final Map<String, dynamic> _data = <String, dynamic>{};

  /// Gets the value of a metadata key.
  /// If the key does not exist, null will be returned.
  /// The value can be any type.
  dynamic get(String key) => _data[key];

  /// Sets the value of a metadata key.
  /// If the key already exists, the value will be overwritten.
  /// If the key does not exist, it will be created.
  /// The value can be any type.
  // ignore: avoid_annotating_with_dynamic
  void set(String key, dynamic value) => _data[key] = value;

  /// Converts the metadata to a JSON object.
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    for (var entry in _data.entries) {
      json[entry.key] = entry.value.toString();
    }
    return json;
  }
}
