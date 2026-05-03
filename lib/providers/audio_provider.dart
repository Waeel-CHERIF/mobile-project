import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_player_app/data/models/category.dart' as models;
import 'package:audio_player_app/data/models/track.dart';
import 'package:audio_player_app/data/repositories/audio_repository.dart';
import 'package:audio_player_app/services/audio_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioRepository _audioRepository;
  final AudioServiceHandler _audioService;

  List<models.Category> _categories = [];
  Track? _currentTrack;
  bool _isLoading = false;
  String? _errorMessage;
  Duration _position = Duration.zero;
  Duration? _duration;
  bool _isPlaying = false;
  LoopMode _loopMode = LoopMode.off;
  List<Track> _currentPlaylist = [];
  int _currentIndex = 0;

  List<models.Category> get categories => _categories;
  Track? get currentTrack => _currentTrack;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Duration get position => _position;
  Duration? get duration => _duration;
  bool get isPlaying => _isPlaying;
  LoopMode get loopMode => _loopMode;
  List<Track> get currentPlaylist => _currentPlaylist;
  int get currentIndex => _currentIndex;

  AudioProvider({required AudioRepository audioRepository, required AudioServiceHandler audioService})
      : _audioRepository = audioRepository, _audioService = audioService {
    _initListeners();
  }

  void _initListeners() {
    _audioService.positionStream.listen((pos) { _position = pos; notifyListeners(); });
    _audioService.durationStream.listen((dur) { _duration = dur; notifyListeners(); });
    _audioService.playerStateStream.listen((state) { _isPlaying = state.playing; notifyListeners(); });
  }

  Future<void> loadCategories() async {
    _setLoading(true); _clearError();
    try {
      _categories = await _audioRepository.fetchAllCategories();
      notifyListeners();
    } catch (e) { _setError(e.toString()); }
    finally { _setLoading(false); }
  }

  Future<void> playTrack(Track track, {List<Track>? playlist}) async {
    try {
      _currentTrack = track;
      if (playlist != null) {
        _currentPlaylist = playlist;
        _currentIndex = playlist.indexWhere((t) => t.id == track.id);
      } else {
        _currentPlaylist = [track]; _currentIndex = 0;
      }
      await _audioService.setUrl(track.audioUrl);
      await _audioService.play();
      notifyListeners();
    } catch (e) { _setError(e.toString()); }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> play() async => await _audioService.play();
  Future<void> pause() async => await _audioService.pause();

  Future<void> stop() async {
    await _audioService.stop();
    _currentTrack = null; _position = Duration.zero;
    notifyListeners();
  }

  Future<void> seekTo(Duration position) async => await _audioService.seek(position);

  Future<void> seekToNext() async {
    if (_currentPlaylist.isEmpty) return;
    int nextIndex = _currentIndex + 1;
    if (nextIndex >= _currentPlaylist.length) nextIndex = 0;
    await playTrack(_currentPlaylist[nextIndex], playlist: _currentPlaylist);
  }

  Future<void> seekToPrevious() async {
    if (_currentPlaylist.isEmpty) return;
    if (_position.inSeconds > 3) { await seekTo(Duration.zero); return; }
    int prevIndex = _currentIndex - 1;
    if (prevIndex < 0) prevIndex = _currentPlaylist.length - 1;
    await playTrack(_currentPlaylist[prevIndex], playlist: _currentPlaylist);
  }

  void toggleRepeat() {
    _audioService.toggleRepeat();
    _loopMode = _audioService.loopMode;
    notifyListeners();
  }

  String get repeatModeText {
    switch (_loopMode) {
      case LoopMode.one: return 'Repeat One';
      case LoopMode.all: return 'Repeat All';
      case LoopMode.off: return 'Repeat Off';
    }
  }

  List<Track> getTracksByCategory(String categoryId) => _audioRepository.getTracksByCategory(_categories, categoryId);
  List<Track> getAllTracks() => _audioRepository.getAllTracks(_categories);

  void _setLoading(bool loading) { _isLoading = loading; notifyListeners(); }
  void _setError(String error) { _errorMessage = error; notifyListeners(); }
  void _clearError() { _errorMessage = null; notifyListeners(); }

  @override
  void dispose() { _audioService.dispose(); super.dispose(); }
}
