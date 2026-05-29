class MapStateModel {
  final String id;
  final String? regionId;
  final String regionName;
  final String name;
  final String capital;
  final String abbreviation;
  final String? description;
  final String? funFact;
  final String mapKey;
  final String? colorHex;
  final int orderIndex;

  const MapStateModel({
    required this.id,
    required this.regionId,
    required this.regionName,
    required this.name,
    required this.capital,
    required this.abbreviation,
    required this.description,
    required this.funFact,
    required this.mapKey,
    required this.colorHex,
    required this.orderIndex,
  });

  factory MapStateModel.fromJson(Map<String, dynamic> json) {
    final region = _parseJsonMap(json['regions']);

    return MapStateModel(
      id: json['id'] as String,
      regionId: json['region_id'] as String?,
      regionName: region?['name'] as String? ?? 'México',
      name: json['name'] as String,
      capital: json['capital'] as String,
      abbreviation: json['abbreviation'] as String,
      description: json['description'] as String?,
      funFact: json['fun_fact'] as String?,
      mapKey: json['map_key'] as String,
      colorHex: json['color_hex'] as String?,
      orderIndex: json['order_index'] as int? ?? 0,
    );
  }

  static Map<String, dynamic>? _parseJsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}

class MapStateProgressModel {
  final String mapKey;
  final int attempts;
  final int correctAttempts;

  const MapStateProgressModel({
    required this.mapKey,
    required this.attempts,
    required this.correctAttempts,
  });

  double get accuracy {
    if (attempts == 0) return 0;
    return correctAttempts / attempts;
  }

  String get label {
    if (attempts == 0) return 'Sin práctica todavía';
    return '${(accuracy * 100).round()}% de precisión';
  }
}

class MapExplorerContent {
  final List<MapStateModel> states;
  final Map<String, MapStateProgressModel> progressByMapKey;

  const MapExplorerContent({
    required this.states,
    required this.progressByMapKey,
  });

  bool get isEmpty => states.isEmpty;
}
