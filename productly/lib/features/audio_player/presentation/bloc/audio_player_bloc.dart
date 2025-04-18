import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:productly/features/audio_player/presentation/bloc/audio_player_event.dart';
import 'package:productly/features/audio_player/presentation/bloc/audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  AudioPlayerBloc() : super(const AudioPlayerState()) {
    on<AudioPlayerInitializeEvent>(_onInitialize);
    on<AudioPlayerStateChanged>(_onStateChanged);
    on<AudioPlayerPositionChanged>(_onPositionChanged);
    on<AudioPlayerDurationChanged>(_onDurationChanged);
    on<AudioPlayerPlayPausePressed>(_onPlayPausePressed);
    on<AudioPlayerSeeked>(_onSeeked);
    on<AudioPlayerCompleted>(_onCompleted);
  }

  void _onInitialize(
    AudioPlayerInitializeEvent event,
    Emitter<AudioPlayerState> emit,
  ) {
    // Initial state is already created in constructor
  }

  void _onStateChanged(
    AudioPlayerStateChanged event,
    Emitter<AudioPlayerState> emit,
  ) {
    emit(state.copyWith(
      isPlaying: event.isPlaying,
      processingState: event.processingState,
    ));
  }

  void _onPositionChanged(
    AudioPlayerPositionChanged event,
    Emitter<AudioPlayerState> emit,
  ) {
    emit(state.copyWith(
      position: event.position,
      // Reset the playback command to none
      playbackCommand: PlaybackCommand.none,
    ));
  }

  void _onDurationChanged(
    AudioPlayerDurationChanged event,
    Emitter<AudioPlayerState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  void _onPlayPausePressed(
    AudioPlayerPlayPausePressed event,
    Emitter<AudioPlayerState> emit,
  ) {
    final playbackCommand =
        event.isCurrentlyPlaying ? PlaybackCommand.pause : PlaybackCommand.play;
    
    emit(state.copyWith(
      playbackCommand: playbackCommand,
    ));
  }

  void _onSeeked(
    AudioPlayerSeeked event,
    Emitter<AudioPlayerState> emit,
  ) {
    emit(state.copyWith(
      position: event.position,
      playbackCommand: PlaybackCommand.seek,
    ));
  }

  void _onCompleted(
    AudioPlayerCompleted event,
    Emitter<AudioPlayerState> emit,
  ) {
    emit(state.copyWith(
      isPlaying: false,
      position: Duration.zero,
    ));
  }
} 