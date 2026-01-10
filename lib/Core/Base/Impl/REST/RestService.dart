import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';
import '../../../Abstractions/REST/Json/IJsonMapper.dart';
import '../../../Abstractions/REST/Json/IJsonModel.dart';
import '../../../Domain/Infrastructures/REST/JsonMapper.dart';
import 'RequestQueueItem.dart';
import 'RequestQueueList.dart';
import '../Diagnostic/LoggableService.dart';
import '../../../Abstractions/AppServices/IConstant.dart';
import '../../../Abstractions/Messaging/IMessagesCenter.dart';
import '../../../Abstractions/REST/Enums.dart';
import '../../../Abstractions/REST/Exceptions/ServerApiException.dart';
import '../../../Abstractions/REST/IAuthTokenService.dart';
import '../../../Abstractions/REST/IRestClient.dart';
import '../../../Abstractions/REST/RestRequest.dart';

/// External abstractions already exist (per your note)
/// - IAuthTokenService
/// - IRestClient
/// - IMessagesCenter
/// - RequestQueueList
/// - RequestQueueItem
/// - RestRequest
/// - RestMethod
/// - AuthErrorEvent
/// - Exceptions
/// - LoggableService (mixin)

class RestService with LoggableService
{
  // === Dependencies (DI) ===

  final  _authTokenService = LazyInjected<IAuthTokenService>();
  final _restClient = LazyInjected<IRestClient>();
  final _jsonMap = LazyInjected<IJsonMapper>();
  final _queueList = LazyInjected<RequestQueueList>();
  final _constants = LazyInjected<IConstant>();

  final String _tag = 'RestClientService: ';

  // =================================================
  // Public REST API
  // =================================================

  Future<T> Get<T extends IDeserializable<T>>(RestRequest request)
  {
    LogMethodStart(args: {'request': request});
    return _makeWebRequest<T>(RestMethod.GET, request);
  }

  Future<T> Post<T extends IDeserializable<T>>(RestRequest request)
  {
    LogMethodStart(args: {'request': request});
    return _makeWebRequest<T>(RestMethod.POST, request);
  }

  Future<T> Put<T extends IDeserializable<T>>(RestRequest request)
  {
    LogMethodStart(args: {'request': request});
    return _makeWebRequest<T>(RestMethod.PUT, request);
  }

  Future<T> Delete<T extends IDeserializable<T>>(RestRequest request)
  {
    LogMethodStart(args: {'request': request});
    return _makeWebRequest<T>(RestMethod.DELETE, request);
  }

  // =================================================
  // Core request pipeline
  // =================================================

  Future<T> _makeWebRequest<T extends IDeserializable<T>>(RestMethod method, RestRequest request) async
  {
    if (request.WithBearer)
    {
      await _authTokenService.Value.EnsureAuthValid();
    }

    final result = await _addRequestToQueue(method, request);
    return _deserialize<T>(result);
  }

  /// Dart replacement for `Deferred<String>`
  /// Uses `Completer<String>`
  Future<String> _addRequestToQueue(RestMethod method,RestRequest request)
  {
    final path = _getUrlWithoutParam(request.ApiEndpoint);
    final queueItemId = '${method.name}$path/${request.RequestPriority}/${request.CancelSameRequest}';

    _log('Request $method: $queueItemId, priority: ${request.RequestPriority} added to Queue');

    final item = RequestQueueItem()
      ..Id = queueItemId
      ..priority = request.RequestPriority
      ..timeoutType = request.RequestTimeOut
      ..parentList = _queueList.Value
      ..logger = loggingService.Value
      ..RequestAction = () async
      {
        final fullUrl = '${_constants.Value.ServerUrlHost}${request.ApiEndpoint}';

        final token = await _authTokenService.Value.GetToken();
        final jsonBody = request.RequestBody != null
            ? _jsonMap.Value.Serialize(request.RequestBody!)
            : null;

        final httpRequest = RestClientHttpRequest()
          ..Url = fullUrl
          ..RequestMethod = method
          ..JsonBody = jsonBody
          ..AccessToken = token;

        final requestSummary = jsonBody != null && jsonBody.isNotEmpty
            ? 'DoHttpRequest(${method.name}, $fullUrl, $jsonBody)'
            : 'DoHttpRequest(${method.name}, $fullUrl)';

        loggingService.Value.LogMethodStarted2(requestSummary);

        final response = await _restClient.Value.DoHttpRequest(method, httpRequest);
        final safeContent = _hideSensitiveData(response);

        this.LogMethodFinished('$requestSummary with result: $safeContent');

        return response;
      };

    _queueList.Value.add(item);

    return item.CompletionSource.future;
  }

  // =================================================
  // Serialization / error detection
  // =================================================

  T _deserialize<T extends IDeserializable<T>>(String jsonStr)
  {
    _checkForError(jsonStr);

    if (T == String)
    {
      return jsonStr as T;
    }

    final val = _jsonMap.Value.Deserialize<T>(jsonStr);
    return val;
  }

  void _checkForError(String jsonStr)
  {
    if (jsonStr.toLowerCase().contains('error:'))
    {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final error = map['error'];
      if (error is String)
      {
        throw ServerApiException(error);
      }
    }
  }

  // =================================================
  // Helpers
  // =================================================

  String _getUrlWithoutParam(String url)
  {
    final hasQuery = url.contains('?');
    final base = hasQuery ? url.split('?').first : url;
    final parts = base.split('/');
    final count = hasQuery ? parts.length : parts.length - 1;

    final buffer = StringBuffer();
    for (var i = 0; i < count; i++)
    {
      final seg = parts[i];
      if (seg.isNotEmpty) {
        buffer.write('/$seg');
      }
    }
    return buffer.toString();
  }

  void _log(String message) => loggingService.Value.Log('$_tag$message');

  String _hideSensitiveData(String data)
  {
    if (!data.contains('access_token'))
    {
      return data;
    }

    try
    {
      final json = jsonDecode(data) as Map<String, dynamic>;
      const sensitiveKeys = [
        'access_token',
        'userName',
        'phoneNumber',
        'token_type',
        '.issued',
        '.expires',
        'expires_in',
      ];

      for (final key in sensitiveKeys)
      {
        json.remove(key);
      }

      return jsonEncode(json);
    }
    catch (_)
    {
      return data;
    }
  }

}
