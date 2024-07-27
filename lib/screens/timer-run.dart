import 'dart:developer';

import 'package:breath_timer/domain/timer.dart';
import 'package:breath_timer/provider/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class ExceriseRunScreen extends ConsumerStatefulWidget {
  const ExceriseRunScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExceriseRunScreenState();
}

class _ExceriseRunScreenState extends ConsumerState<ExceriseRunScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final String inhaleSoundPath = 'assets/inhale.wav';
  final String exhaleSoundPath = 'assets/exhale.wav';

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playSound(BreathingState state) async {
    var path =
        state == BreathingState.inhale ? inhaleSoundPath : exhaleSoundPath;
    try {
      await audioPlayer.stop();
      await audioPlayer.setAsset(path);
      await audioPlayer.play();
    } catch (e) {
      log('ExceriseRunScreen::playSound: error', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerServiceProvider);

    ref.listen(timerServiceProvider, (previous, next) {
      if (next.value?.isRunning != true) {
        return;
      }
      if (previous?.value?.breathingState != next.value?.breathingState ||
          previous?.value?.isRunning != next.value?.isRunning) {
        playSound(next.value!.breathingState);
      }
    });

    return switch (timerState) {
      AsyncData(:final value) => GestureDetector(
          onTap: () {
            audioPlayer.stop();
            if (value.isRunning) {
              ref.read(timerServiceProvider.notifier).stop();
            } else {
              ref.read(timerServiceProvider.notifier).start();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Breathing Exercise'),
            ),
            body: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: value.isRunning
                        ? value.breathingState == BreathingState.inhale
                            ? 200 * value.durationPercentage
                            : 200 - (200 * value.durationPercentage)
                        : 200,
                    height: value.isRunning
                        ? value.breathingState == BreathingState.inhale
                            ? 200 * value.durationPercentage
                            : 200 - (200 * value.durationPercentage)
                        : 200,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                  ),
                  Container(
                    height: 206,
                    width: 206,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                            color: const Color.fromARGB(255, 63, 92, 186),
                            width: 3)),
                  ),
                  Text(
                    value.isRunning
                        ? (value.breathingState == BreathingState.inhale
                            ? 'Inhale'
                            : 'Exhale')
                        : 'Start',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      _ => const CircularProgressIndicator()
    };
  }
}
