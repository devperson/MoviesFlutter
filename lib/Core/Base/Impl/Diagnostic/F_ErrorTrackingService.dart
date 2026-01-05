import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Abstractions/Common/Event.dart';

class F_ErrorTrackingService implements IErrorTrackingService
{
  @override
  void Initialize() {
    // TODO: implement Initialize
  }

  @override
  // TODO: implement OnServiceError
  Event<Exception> get OnServiceError => Event<Exception>();

  @override
  void TrackError(Object ex, StackTrace stackTrace, {List<int>? attachment, Map<String, String>? additionalData})
  {
    if (ex is AppException)
    {
      print(ex);
    }
    else if (ex is Exception)
    {
      print(ex.ToAppException(stackTrace));
    }
    else
    {
      print('Non-exception error: $ex\n$stackTrace');
    }
  }

}