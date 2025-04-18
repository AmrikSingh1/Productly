import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/features/audio_player/presentation/bloc/audio_player_bloc.dart';
import 'package:productly/features/audio_player/presentation/bloc/audio_player_event.dart';
import 'package:productly/features/audio_player/presentation/bloc/audio_player_state.dart';

class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AudioPlayerBloc()..add(const AudioPlayerInitializeEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Player'),
        ),
        body: const AudioPlayerView(),
      ),
    );
  }
}

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({super.key});

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  final _player = AudioPlayer();
  bool _isPlayerInitialized = false;
  
  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // We use a fixed audio file from assets
      await _player.setAsset('assets/audio/sample.mp3');
      setState(() {
        _isPlayerInitialized = true;
      });

      // Listen to player position changes
      _player.positionStream.listen((position) {
        if (mounted) {
          context.read<AudioPlayerBloc>().add(
                AudioPlayerPositionChanged(position: position),
              );
        }
      });

      // Listen to player duration changes
      _player.durationStream.listen((duration) {
        if (duration != null && mounted) {
          context.read<AudioPlayerBloc>().add(
                AudioPlayerDurationChanged(duration: duration),
              );
        }
      });

      // Listen to player state changes
      _player.playerStateStream.listen((playerState) {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;
        
        if (mounted) {
          if (processingState == ProcessingState.completed) {
            context.read<AudioPlayerBloc>().add(const AudioPlayerCompleted());
            _player.seek(Duration.zero);
          } else {
            context.read<AudioPlayerBloc>().add(
                  AudioPlayerStateChanged(
                    isPlaying: isPlaying,
                    processingState: processingState,
                  ),
                );
          }
        }
      });
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Duration _clampDuration(Duration value, Duration min, Duration max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPlayerInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return BlocListener<AudioPlayerBloc, AudioPlayerState>(
      listener: (context, state) {
        // Handle play/pause commands
        if (state.playbackCommand == PlaybackCommand.play && !_player.playing) {
          _player.play();
        } else if (state.playbackCommand == PlaybackCommand.pause && _player.playing) {
          _player.pause();
        } else if (state.playbackCommand == PlaybackCommand.seek) {
          _player.seek(state.position);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Audio Player UI
            _buildAudioWaveform().animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                ),
            const SizedBox(height: 40),
            _buildPlayerControls(),
            const SizedBox(height: 24),
            _buildProgressBar(),
            const SizedBox(height: 16),
            _buildDurationInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioWaveform() {
    return SizedBox(
      height: 200,
      child: Center(
        child: CustomPaint(
          size: const Size(double.infinity, 150),
          painter: AudioWaveformPainter(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildPlayerControls() {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final isPlaying = state.isPlaying;
        final isBuffering = state.processingState == ProcessingState.buffering;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Skip backward button
            IconButton(
              iconSize: 48,
              icon: Icon(
                Icons.replay_10,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                final newPosition = _clampDuration(
                  _player.position - const Duration(seconds: 10),
                  Duration.zero,
                  _player.duration ?? Duration.zero,
                );
                _player.seek(newPosition);
              },
            ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 150),
                ),
            
            const SizedBox(width: 16),
            
            // Play/Pause button
            GestureDetector(
              onTap: () {
                context.read<AudioPlayerBloc>().add(
                      AudioPlayerPlayPausePressed(
                        isCurrentlyPlaying: isPlaying,
                      ),
                    );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isBuffering
                    ? Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 48,
                        color: theme.colorScheme.onPrimary,
                      ),
              ),
            ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                ),
            
            const SizedBox(width: 16),
            
            // Skip forward button
            IconButton(
              iconSize: 48,
              icon: Icon(
                Icons.forward_10,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                final newPosition = _clampDuration(
                  _player.position + const Duration(seconds: 10),
                  Duration.zero,
                  _player.duration ?? const Duration(seconds: 0),
                );
                _player.seek(newPosition);
              },
            ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 150),
                ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        
        return SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.primaryContainer,
            thumbColor: theme.colorScheme.primary,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            min: 0.0,
            max: state.duration.inMilliseconds.toDouble(),
            value: min(
              state.position.inMilliseconds.toDouble(),
              state.duration.inMilliseconds.toDouble(),
            ),
            onChanged: (value) {
              final newPosition = Duration(milliseconds: value.toInt());
              context.read<AudioPlayerBloc>().add(
                    AudioPlayerSeeked(position: newPosition),
                  );
            },
          ),
        ).animate().fadeIn(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 200),
            );
      },
    );
  }

  Widget _buildDurationInfo() {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        final position = state.position;
        final duration = state.duration;
        
        final positionText = '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}';
        final durationText = '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(positionText),
            Text(durationText),
          ],
        ).animate().fadeIn(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 250),
            );
      },
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final Color color;
  final random = Random();

  AudioWaveformPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 4.0;
    final barSpace = 2.0;
    final maxBars = (size.width / (barWidth + barSpace)).floor();
    
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;
    
    for (int i = 0; i < maxBars; i++) {
      final randomHeight = 10 + random.nextDouble() * (size.height - 20);
      final startX = i * (barWidth + barSpace);
      
      final startPoint = Offset(startX, (size.height - randomHeight) / 2);
      final endPoint = Offset(startX, (size.height + randomHeight) / 2);
      
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 