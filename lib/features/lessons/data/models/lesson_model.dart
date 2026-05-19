class LessonModel {
  final String id;
  final String unitId;
  final String title;
  final String? description;
  final String lessonType;
  final int orderIndex;
  final int xpReward;
  final String? requiredLessonId;
  final bool isActive;
  final DateTime createdAt;

  const LessonModel({
    required this.id,
    required this.unitId,
    required this.title,
    required this.description,
    required this.lessonType,
    required this.orderIndex,
    required this.xpReward,
    required this.requiredLessonId,
    required this.isActive,
    required this.createdAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      unitId: json['unit_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      lessonType: json['lesson_type'] as String? ?? 'standard',
      orderIndex: json['order_index'] as int? ?? 0,
      xpReward: json['xp_reward'] as int? ?? 10,
      requiredLessonId: json['required_lesson_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
