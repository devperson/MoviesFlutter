import 'package:movies_flutter/Core/Event.dart';

abstract interface class IErrorTrackingService
{
  Event<Exception> get OnServiceError;

  void Initialize();

  void TrackError(Exception ex, { List<int>? attachment, Map<String, String>? additionalData });
}
