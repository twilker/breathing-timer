import 'dart:async';
import 'dart:developer';

import 'package:breath_timer/common/events.dart';
import 'package:breath_timer/excerise/domain/timer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer.g.dart';

// var errorThrown = false;

@Riverpod(keepAlive: true)
class TimerService extends _$TimerService {
  Timer? _timer;
  static const inhaleDuration = Duration(seconds: 4);
  static const exhaleDuration = Duration(seconds: 5);
  static const timerTick = Duration(milliseconds: 50);

  TimerService() {
    eventBus.on<AppStartedEvent>().listen((_) {
      log('App started.');
    });
  }

  @override
  Future<TimerState> build() async {
    // await Future.delayed(const Duration(seconds: 5));
    // if (!errorThrown) {
    //   errorThrown = true;
    //   throw Error();
    // }
    return TimerState(
        isRunning: false,
        breathingState: BreathingState.inhale,
        durationPercentage: 0);
  }

  void start() {
    if (state.value?.isRunning == true) return;
    log('starting timer');
    state = AsyncValue.data(TimerState(
        isRunning: true,
        breathingState: BreathingState.inhale,
        durationPercentage: 0));
    _timer = Timer.periodic(timerTick, tick);
  }

  void stop() {
    _timer?.cancel();
    state = AsyncValue.data(TimerState(
        isRunning: false,
        breathingState: BreathingState.inhale,
        durationPercentage: 0));
  }

  void restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(timerTick, tick);
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
