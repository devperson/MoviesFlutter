import 'dart:async';
import '../../../Event.dart';

class CustomTimer
{
    final Duration interval;
    Timer? _timer;

    final SimpleEvent Elapsed = SimpleEvent();

    CustomTimer(this.interval);

    bool get IsEnabled => _timer != null && _timer!.isActive;

    void Start()
    {
        if (IsEnabled)
            return;

        _timer = Timer.periodic(interval, (Timer t) {
            Elapsed.Invoke();
        });
    }

    void Stop()
    {
        _timer?.cancel();
        _timer = null;
    }
}
