import 'package:breath_timer/excerise/provider/timer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init.g.dart';

@Riverpod(keepAlive: true)
Future<void> initExcerise(InitExceriseRef ref) async {
  ref.onDispose(() {
    // ensure we invalidate all the providers we depend on
    ref.invalidate(timerServiceProvider);
  });
  // all asynchronous app initialization code should belong here:
  // we use read instead of watch as we only want to wait until the first value
  // is created. Any further state changes should not trigger a rebuild.
  await ref.read(timerServiceProvider.future);
}
