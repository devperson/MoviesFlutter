import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Event.dart';

class AppErrorTrackingService implements IErrorTrackingService
{
  @override
  void Initialize() {
    // TODO: implement Initialize
  }

  @override
  // TODO: implement OnServiceError
  Event<Exception> get OnServiceError => Event<Exception>();

  @override
  void TrackError(Exception ex, {List<int>? attachment, Map<String, String>? additionalData})
  {
    print(ex.toString());
  }

}