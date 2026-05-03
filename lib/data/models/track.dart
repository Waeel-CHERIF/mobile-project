class Track {
  final String id;
  final String title;
  final String audioUrl;
  final String? categoryId;
  final String? categoryName;
  final int? trackNumber;
  final Duration? duration;
  final String? thumbnailUrl;

  Track({
    required this.id,
    required this.title,
    required this.audioUrl,
    this.categoryId,
    this.categoryName,
    this.trackNumber,
    this.duration,
    this.thumbnailUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'audioUrl': audioUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'trackNumber': trackNumber,
      'duration': duration?.inSeconds,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      audioUrl: map['audioUrl'] ?? '',
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      trackNumber: map['trackNumber'],
      duration: map['duration'] != null ? Duration(seconds: map['duration']) : null,
      thumbnailUrl: map['thumbnailUrl'],
    );
  }

  Track copyWith({
    String? id, String? title, String? audioUrl, String? categoryId,
    String? categoryName, int? trackNumber, Duration? duration, String? thumbnailUrl,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      audioUrl: audioUrl ?? this.audioUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      trackNumber: trackNumber ?? this.trackNumber,
      duration: duration ?? this.duration,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
