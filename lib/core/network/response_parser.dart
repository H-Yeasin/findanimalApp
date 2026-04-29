class ResponseParser {
  const ResponseParser._();

  static T parseObject<T>(
    dynamic raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return fromJson(Map<String, dynamic>.from(raw as Map));
  }

  static List<T> parseList<T>(
    dynamic raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final list = List<Map<String, dynamic>>.from(raw as List);
    return list.map(fromJson).toList();
  }
}
