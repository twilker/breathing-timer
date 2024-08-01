enum BreathingState { inhale, exhale, hold }

class TimerState {
  final bool isRunning;
  final BreathingState breathingState;
  final double durationPercentage;

  TimerState({
    required this.isRunning,
    required this.breathingState,
    required this.durationPercentage,
  });
}

class TimerConfiguration {
  String name;
  List<TimerPhase> phases;

  TimerConfiguration({
    required this.phases,
    required this.name,
  });
}

class FixedRepetitionPhase extends TimerPhase {
  int repetitions;

  FixedRepetitionPhase({
    super.inhaleDuration = 0,
    super.inhaleHoldDuration = 0,
    super.exhaleDuration = 0,
    super.exhaleHoldDuration = 0,
    required this.repetitions,
  });
}

class InfiniteRepetionPhase extends TimerPhase {
  InfiniteRepetionPhase({
    super.inhaleDuration = 0,
    super.inhaleHoldDuration = 0,
    super.exhaleDuration = 0,
    super.exhaleHoldDuration = 0,
  });
}

class MaximumHoldPhase extends TimerPhase {
  MaximumHoldPhase() : super(exhaleHoldDuration: -1);
}

abstract class TimerPhase {
  double inhaleDuration;
  double inhaleHoldDuration;
  double exhaleDuration;
  double exhaleHoldDuration;

  TimerPhase({
    this.inhaleDuration = 0,
    this.inhaleHoldDuration = 0,
    this.exhaleDuration = 0,
    this.exhaleHoldDuration = 0,
  });
}
