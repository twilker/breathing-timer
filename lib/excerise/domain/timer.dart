enum BreathingState { inhale, exhale }

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
