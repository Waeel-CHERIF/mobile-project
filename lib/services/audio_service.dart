import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/foundation.dart';

class AudioServiceHandler {
  late AudioPlayer _audioPlayer;
  // ignore: unused_field
  AudioHandler? _audioHandler;
  bool _isInitialized = false;

  AudioPlayer get player => _audioPlayer;

  Future<void> init() async {
    if (_isInitialized) return;

    _audioPlayer = AudioPlayer();

    try {
      _audioHandler = await AudioService.init(
        builder: () => AudioPlayerHandlerImpl(_audioPlayer),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.audioplayer.channel.audio',
          androidNotificationChannelName: 'Audio Player',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
      );
    } catch (e) {
      debugPrint('AudioService init warning: $e');
    }

    _isInitialized = true;
  }

  Future<void> setUrl(String url) async => await _audioPlayer.setUrl(url);
  Future<void> play() async => await _audioPlayer.play();
  Future<void> pause() async => await _audioPlayer.pause();
  Future<void> stop() async => await _audioPlayer.stop();
  Future<void> seek(Duration position) async => await _audioPlayer.seek(position);
  Future<void> setVolume(double volume) async => await _audioPlayer.setVolume(volume);
  Future<void> setSpeed(double speed) async => await _audioPlayer.setSpeed(speed);

  Future<void> setLoopMode(LoopMode mode) async => await _audioPlayer.setLoopMode(mode);

  void toggleRepeat() {
    switch (_audioPlayer.loopMode) {
      case LoopMode.off: _audioPlayer.setLoopMode(LoopMode.one); break;
      case LoopMode.one: _audioPlayer.setLoopMode(LoopMode.all); break;
      case LoopMode.all: _audioPlayer.setLoopMode(LoopMode.off); break;
    }
  }

  LoopMode get loopMode => _audioPlayer.loopMode;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<PlaybackEvent> get playbackEventStream => _audioPlayer.playbackEventStream;

  ValueStream<Duration> get position => Rx.combineLatest2<Duration, Duration?, Duration>(
        positionStream, durationStream, (position, duration) => position,
      ).shareValueSeeded(Duration.zero);

  bool get isPlaying => _audioPlayer.playing;
  Duration get currentPosition => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;
  bool get isBuffering => _audioPlayer.playing && _audioPlayer.processingState == ProcessingState.buffering;

  Future<void> playMultiple(List<AudioSource> sources, {int initialIndex = 0}) async {
    final playlist = ConcatenatingAudioSource(children: sources);
    await _audioPlayer.setAudioSource(playlist, initialIndex: initialIndex);
    await _audioPlayer.play();
  }

  Future<void> seekToNext() async => await _audioPlayer.seekToNext();
  Future<void> seekToPrevious() async => await _audioPlayer.seekToPrevious();

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _isInitialized = false;
  }
}

class AudioPlayerHandlerImpl extends BaseAudioHandler {
  final AudioPlayer _player;

  AudioPlayerHandlerImpl(this._player) {
    _player.playbackEventStream.listen(_broadcastState);
    _player.durationStream.listen((d) => mediaItem.add(mediaItem.value?.copyWith(duration: d)));
  }

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(PlaybackState(
      controls: [MediaControl.skipToPrevious, if (_player.playing) MediaControl.pause else MediaControl.play, MediaControl.skipToNext],
      systemActions: const {MediaAction.seek},
      androidCompactActionIndices: const [0, 1, 2],
      processingState: {ProcessingState.idle: AudioProcessingState.idle, ProcessingState.loading: AudioProcessingState.loading, ProcessingState.buffering: AudioProcessingState.buffering, ProcessingState.ready: AudioProcessingState.ready, ProcessingState.completed: AudioProcessingState.completed}[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
    ));
  }

  @override Future<void> play() => _player.play();
  @override Future<void> pause() => _player.pause();
  @override Future<void> seek(Duration position) => _player.seek(position);
  @override Future<void> stop() => _player.stop();
}
