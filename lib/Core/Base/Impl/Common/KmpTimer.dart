import 'dart:async';
import '../../../Event.dart';

class KmpTimer
{
    final Duration interval;
    Timer? _timer;

    final Event<void> Elapsed = Event<void>();

    KmpTimer(this.interval);

    bool get IsEnabled => _timer != null && _timer!.isActive;

    void Start()
    {
        if (IsEnabled)
            return;

        _timer = Timer.periodic(interval, (Timer t) {
            Elapsed.Invoke(null);
        });
    }

    void Stop()
    {
        _timer?.cancel();
        _timer = null;
    }
}
