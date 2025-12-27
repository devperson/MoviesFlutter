import 'Enums.dart';

class RestRequest
{
    final String ApiEndpoint;
    final Priority RequestPriority;
    final TimeoutType RequestTimeOut;
    final bool CancelSameRequest;
    final bool WithBearer;
    final String? RequestBody;
    final int RetryCount;
    final Map<String, String>? HeaderValues;

    RestRequest({
        required this.ApiEndpoint,
        this.RequestPriority = Priority.HIGH,
        this.RequestTimeOut = TimeoutType.Small,
        this.CancelSameRequest = false,
        this.WithBearer = true,
        this.RequestBody,
        this.RetryCount = 0,
        this.HeaderValues,
    });
}
