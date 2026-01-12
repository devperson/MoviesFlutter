import 'package:movies_flutter/Core/Abstractions/Common/Event.dart';

abstract interface class IErrorTrackingService
{
  Event<Exception> get OnServiceError;

  Future<void> InitializeAsync();
  Future<void> CustomConfigure();


  void TrackError(Object ex, StackTrace stackTrace, { List<int>? attachment, Map<String, String>? additionalData });
}
