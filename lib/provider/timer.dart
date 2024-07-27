import 'dart:async';

import 'package:breath_timer/domain/timer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer.g.dart';

@riverpod
class TimerService extends _$TimerService {
  Timer? timer;
  static const inhaleDuration = Duration(seconds: 4);
  static const exhaleDuration = Duration(seconds: 5);
  static const timerTick = Duration(milliseconds: 50);

  @override
  Future<TimerState> build() async {
    return TimerState(
        isRunning: false,
        breathingState: BreathingState.inhale,
        durationPercentage: 0);
  }

  void start() {
    if (state.value?.isRunning == true) return;
    state = AsyncValue.data(TimerState(
        isRunning: true,
        breathingState: BreathingState.inhale,
        durationPercentage: 0));
    timer = Timer.periodic(timerTick, tick);
  }

  void stop() {
    timer?.cancel();
    state = AsyncValue.data(TimerState(
        isRunning: false,
        breathingState: BreathingState.inhale,
        durationPercentage: 0));
  }

  void restartTimer() {
    timer?.cancel();
    timer = Timer.periodic(timerTick, tick);
  }

  void tick(Timer timer) {
    final breathingState = state.value?.breathingState ?? BreathingState.inhale;
    final duration = breathingState == BreathingState.inhale
        ? inhaleDuration
        : exhaleDuration;
    final progress =
        (timer.tick * timerTick.inMilliseconds) / duration.inMilliseconds;
    if (progress >= 1) {
      state = AsyncValue.data(TimerState(
        isRunning: true,
        breathingState: breathingState == BreathingState.inhale
            ? BreathingState.exhale
            : BreathingState.inhale,
        durationPercentage: 0,
      ));
      restartTimer();
    } else {
      state = AsyncValue.data(TimerState(
        isRunning: true,
        breathingState: breathingState,
        durationPercentage: progress,
      ));
    }
  }
}
