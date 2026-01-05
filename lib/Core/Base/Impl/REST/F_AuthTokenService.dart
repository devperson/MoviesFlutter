import 'dart:convert';

import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

import '../../../Abstractions/Essentials/IPreferences.dart';
import '../../../Abstractions/REST/Exceptions/AuthExpiredException.dart';
import '../../../Abstractions/REST/IAuthTokenService.dart';
import '../Diagnostic/LoggableService.dart';

class F_AuthTokenService with LoggableService implements IAuthTokenService
{
  static const String TAG = "AuthTokenService: ";
  static const String AUTH_KEY = "user_at";
  AuthTokenDetails? _authToken;

  final _preferencesService = LazyInjected<IPreferences>();


  @override
  Future<String?> GetToken() async
  {
    final tokenDetails = await GetAuthTokenDetails();
    return tokenDetails?.Token ?? "";
  }

  @override
  Future<void> EnsureAuthValid() async
  {
    _authToken ??= await GetAuthTokenDetails();

    if (_authToken == null)
    {
      loggingService.Value.LogWarning("${TAG}Skip checking access token because authToken is null");
      return;
    }

    final expireDate = _authToken!.ExpiredDate;

    final nowDate = DateTime.now().toUtc();
    final expireMinus2Days = expireDate.subtract(const Duration(days: 2));

    if (expireMinus2Days.isBefore(nowDate))
    {
      loggingService.Value.LogWarning("${TAG}Access token is expired(expiredDate - 2days) $expireMinus2Days < $nowDate, actual expired date: $expireDate");
      throw AuthExpiredException();
    }
  }

  @override
  Future<void> SaveAuthTokenDetails(AuthTokenDetails? authToken) async
  {
    if(authToken != null)
    {
      final json = jsonEncode(authToken.ToJson());
      _preferencesService.Value.Set(AUTH_KEY, json);
    }
  }

  @override
  Future<AuthTokenDetails?> GetAuthTokenDetails() async
  {
    final authTokenJson = _preferencesService.Value.Get(AUTH_KEY, "");

    if (authTokenJson.isNotEmpty)
    {
      try
      {
        return AuthTokenDetails.FromJson(JsonDecoder().convert(authTokenJson));
      }
      catch (ex, stackTrace)
      {
        loggingService.Value.LogError(ex, stackTrace, "${TAG}Failed to deserialize AuthTokenDetails");
        return null;
      }
    }

    return null;
  }
}