import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object?> get props => [];
}

class AudioPlayerInitializeEvent extends AudioPlayerEvent {
  const AudioPlayerInitializeEvent();
}

class AudioPlayerStateChanged extends AudioPlayerEvent {
  final bool isPlaying;
  final ProcessingState processingState;

  const AudioPlayerStateChanged({
    required this.isPlaying,
    required this.processingState,
  });

  @override
  List<Object?> get props => [isPlaying, processingState];
}

class AudioPlayerPositionChanged extends AudioPlayerEvent {
  final Duration position;

  const AudioPlayerPositionChanged({required this.position});

  @override
  List<Object?> get props => [position];
}

class AudioPlayerDurationChanged extends AudioPlayerEvent {
  final Duration duration;

  const AudioPlayerDurationChanged({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class AudioPlayerPlayPausePressed extends AudioPlayerEvent {
  final bool isCurrentlyPlaying;

  const AudioPlayerPlayPausePressed({required this.isCurrentlyPlaying});

  @override
  List<Object?> get props => [isCurrentlyPlaying];
}

class AudioPlayerSeeked extends AudioPlayerEvent {
  final Duration position;

  const AudioPlayerSeeked({required this.position});

  @override
  List<Object?> get props => [position];
}

class AudioPlayerCompleted extends AudioPlayerEvent {
  const AudioPlayerCompleted();
} 