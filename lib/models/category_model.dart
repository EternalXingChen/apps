class CategoryModel {
  final String id;
  final String name;
  final String type; // 'expense' or 'income'
  final String? icon;
  final String? color;
  final bool isDefault;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.isDefault = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
      'color': color,
      'isDefault': isDefault ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
      color: json['color'],
      isDefault: json['isDefault'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
