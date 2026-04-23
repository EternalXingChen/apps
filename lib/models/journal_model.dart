class JournalModel {
  final String id;
  final String content;
  final int? moodId;
  final List<String>? mediaUrls;
  final String? location;
  final String? weather;
  final bool isEncrypted;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalModel({
    required this.id,
    required this.content,
    this.moodId,
    this.mediaUrls,
    this.location,
    this.weather,
    this.isEncrypted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'moodId': moodId,
      'mediaUrls': mediaUrls?.join(','),
      'location': location,
      'weather': weather,
      'isEncrypted': isEncrypted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'],
      content: json['content'],
      moodId: json['moodId'],
      mediaUrls: json['mediaUrls']?.toString().split(',').where((s) => s.isNotEmpty).toList(),
      location: json['location'],
      weather: json['weather'],
      isEncrypted: json['isEncrypted'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  JournalModel copyWith({
    String? id,
    String? content,
    int? moodId,
    List<String>? mediaUrls,
    String? location,
    String? weather,
    bool? isEncrypted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalModel(
      id: id ?? this.id,
      content: content ?? this.content,
      moodId: moodId ?? this.moodId,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      location: location ?? this.location,
      weather: weather ?? this.weather,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
