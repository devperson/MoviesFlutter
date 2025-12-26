import 'package:movies_flutter/Core/Event.dart';

abstract class IErrorTrackingService
{
  Event<Exception> get OnServiceError;

  void Initialize();

  void TrackError(Exception Ex, { List<int>? Attachment, Map<String, String>? AdditionalData });
}
