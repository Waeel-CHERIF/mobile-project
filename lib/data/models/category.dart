import 'package:audio_player_app/data/models/track.dart';

class Category {
  final String id;
  final String name;
  final String? description;
  final String? thumbnailUrl;
  final List<Track> tracks;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    this.tracks = const [],
  });

  factory Category.fromApi(Map<String, dynamic> map) {
    final tracks = <Track>[];

    if (map['files'] != null && map['files'] is List) {
      for (final file in map['files'] as List) {
        tracks.add(Track.fromMap({
          'id': file['id']?.toString() ?? '',
          'title': file['name'] ?? file['file'] ?? '',
          'audioUrl': file['url'] ?? file['file'] ?? '',
          'trackNumber': file['id'],
        }));
      }
    } else {
      final numberStr = map['number']?.toString() ?? map['id']?.toString() ?? '';
      if (numberStr.isNotEmpty) {
        final numberInt = int.tryParse(numberStr) ?? 1;
        final paddedNumber = numberInt.toString().padLeft(3, '0');
        final surahName = map['name_ar'] ?? map['name_en'] ?? map['name'] ?? 'Unknown Surah';
        
        tracks.add(Track.fromMap({
          'id': numberStr,
          'title': surahName,
          'audioUrl': 'https://server8.mp3quran.net/afs/$paddedNumber.mp3',
          'trackNumber': numberInt,
        }));
      }
    }

    return Category(
      id: map['id']?.toString() ?? map['name'] ?? '',
      name: map['name_ar'] ?? map['name_en'] ?? map['name'] ?? 'Unknown',
      description: map['type'] ?? map['description'],
      thumbnailUrl: map['thumbnail'],
      tracks: tracks,
    );
  }

  Category copyWith({String? id, String? name, String? description, String? thumbnailUrl, List<Track>? tracks}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      tracks: tracks ?? this.tracks,
    );
  }
}
