import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../Abstractions/REST/Enums.dart';
import '../../../Abstractions/REST/Exceptions/AuthExpiredException.dart';
import '../../../Abstractions/REST/Exceptions/HttpConnectionException.dart';
import '../../../Abstractions/REST/Exceptions/HttpRequestException.dart';
import '../../../Abstractions/REST/IRestClient.dart';

import 'dart:async';
import 'package:dio/dio.dart';

class RestClient implements IRestClient
{
  late final Dio _dio;

  RestClient()
  {
    _dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: { 'Accept': 'application/json' },
      ));
  }

  @override
  Future<String> DoHttpRequest(RestMethod method, RestClientHttpRequest httpRequest) async
  {
    final int timeoutSeconds = httpRequest.RequestTimeout.value;
    final Duration timeout = Duration(seconds: timeoutSeconds);

    try
    {
      final customOption = Options(
        method: method.name,
        headers: _buildHeaders(httpRequest),
        // 👇 per-request timeout override
        sendTimeout: timeout,
        receiveTimeout: timeout,
        responseType: ResponseType.plain,
      );

      final response = await _dio.request<String>(httpRequest.Url, data: httpRequest.JsonBody, options: customOption);

      return response.data ?? '';
    }
    on DioException catch (e, stackTrace)
    {
      // --- Timeouts ---
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout)
      {
        throw HttpConnectionException('Request timed out', causeException: e, causedStackTrace: stackTrace);
      }

      // --- Network ---
      if (e.type == DioExceptionType.connectionError)
      {
        throw HttpConnectionException('Network error: ${e.error}',causeException: e, causedStackTrace: stackTrace);
      }

      // --- HTTP errors ---
      final response = e.response;
      if (response != null)
      {
        final statusCode = response.statusCode ?? 0;
        final body = response.data?.toString() ?? '';

        if (statusCode == 401)
        {
          throw AuthExpiredException();
        }

        throw HttpRequestException(statusCode, body, e);
      }

      throw HttpConnectionException('Unexpected HTTP error',causeException: e, causedStackTrace: stackTrace);
    }
  }

  Map<String, String> _buildHeaders(RestClientHttpRequest request)
  {
    final headers = <String, String>{};

    if (request.AccessToken != null &&
        request.AccessToken!.isNotEmpty)
    {
      headers['Authorization'] =
      'Bearer ${request.AccessToken}';
    }

    headers['Content-Type'] = 'application/json';

    return headers;
  }
}
