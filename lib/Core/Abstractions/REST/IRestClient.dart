import 'Enums.dart';

abstract interface class IRestClient
{
    Future<String> DoHttpRequest(RestMethod method, RestClientHttpRequest httpRequest);
}

class RestClientHttpRequest
{
    RestMethod RequestMethod = RestMethod.GET;
    String Url = "";
    String? JsonBody;
    String? AccessToken;
    TimeoutType RequestTimeout = TimeoutType.Small;
}
