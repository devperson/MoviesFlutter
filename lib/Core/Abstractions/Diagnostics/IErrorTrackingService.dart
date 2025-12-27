import 'package:movies_flutter/Core/Event.dart';

abstract interface class IErrorTrackingService
{
  Event<Exception> get OnServiceError;

  void Initialize();

  void TrackError(Exception Ex, { List<int>? Attachment, Map<String, String>? AdditionalData });
}
