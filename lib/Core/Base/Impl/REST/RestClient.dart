import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../Abstractions/REST/Enums.dart';
import '../../../Abstractions/REST/IRestClient.dart';

class RestClient implements IRestClient
{
  final HttpClient httpClient = HttpClient();

  @override
  Future<String> DoHttpRequest(RestMethod method, RestClientHttpRequest httpRequest) async
  {
    final uri = Uri.parse(httpRequest.Url);
    // dart:io HttpClient.open(...) requires an explicit port number.
    // Uri.port returns 0 when the port is not specified in the URL,
    // so we must manually resolve the default port based on the scheme.
    // These are the same default ports used by browsers:
    //   - 443 for HTTPS
    //   - 80  for HTTP
    final int resolvedPort =
    uri.hasPort
        ? uri.port
        : (uri.scheme == 'https' ? 443 : 80);

    final request = await httpClient.open(
      method.name,
      uri.host,
      resolvedPort,
      uri.path + (uri.hasQuery ? '?${uri.query}' : ''),
    );

    request.headers.set(HttpHeaders.acceptHeader, "application/json");

    if (httpRequest.AccessToken != null && httpRequest.AccessToken!.isNotEmpty)
    {
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer ${httpRequest.AccessToken}");
    }

    // Optional custom headers
    // if (httpRequest.HeaderValues != null)
    // {
    //   httpRequest.HeaderValues!.forEach((key, value)
    //   {
    //     request.headers.set(key, value);
    //   });
    // }

    if (httpRequest.JsonBody != null && httpRequest.JsonBody!.isNotEmpty)
    {
      request.headers.set(HttpHeaders.contentTypeHeader, ContentType.json.mimeType);
      request.add(utf8.encode(httpRequest.JsonBody!));
    }

    //convert timeOut enum to integer equivalent in milliseconds
    final int timeoutMillis = httpRequest.RequestTimeout.value * 1000;
    final response = await request.close()
        .timeout(Duration(milliseconds: timeoutMillis));

    final responseContent = await utf8.decoder.bind(response).join();

    return responseContent;
  }

  // ---------- helpers ----------


}