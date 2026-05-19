class UnitModel {
  final String id;
  final String? regionId;
  final String title;
  final String? description;
  final int orderIndex;
  final bool isActive;
  final DateTime createdAt;

  const UnitModel({
    required this.id,
    required this.regionId,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.isActive,
    required this.createdAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] as String,
      regionId: json['region_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      orderIndex: json['order_index'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
