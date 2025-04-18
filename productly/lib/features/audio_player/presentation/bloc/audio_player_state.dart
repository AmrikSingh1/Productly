import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

enum PlaybackCommand { none, play, pause, seek }

class AudioPlayerState extends Equatable {
  final bool isPlaying;
  final ProcessingState processingState;
  final Duration position;
  final Duration duration;
  final PlaybackCommand playbackCommand;

  const AudioPlayerState({
    this.isPlaying = false,
    this.processingState = ProcessingState.idle,
    this.position = Duration.zero,
    this.duration = const Duration(seconds: 1), // Prevent division by zero
    this.playbackCommand = PlaybackCommand.none,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    ProcessingState? processingState,
    Duration? position,
    Duration? duration,
    PlaybackCommand? playbackCommand,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      processingState: processingState ?? this.processingState,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playbackCommand: playbackCommand ?? this.playbackCommand,
    );
  }

  @override
  List<Object?> get props => [
        isPlaying,
        processingState,
        position,
        duration,
        playbackCommand,
      ];
} 