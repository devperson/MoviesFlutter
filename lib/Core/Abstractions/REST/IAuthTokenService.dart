abstract interface class IAuthTokenService
{
    Future<String?> GetToken();
    Future<void> EnsureAuthValid();
    Future<void> SaveAuthTokenDetails(AuthTokenDetails? authToken);
    Future<AuthTokenDetails?> GetAuthTokenDetails();
}

class AuthTokenDetails
{
    final String Token;
    final DateTime ExpiredDate;
    final String RefreshToken;

    AuthTokenDetails({required this.Token, required this.ExpiredDate, required this.RefreshToken});


    // ---------- JSON ----------
    Map<String, dynamic> ToJson()
    {
      return
        {
          'Token': Token,
          'ExpiredDate': ExpiredDate.toIso8601String(),
          'RefreshToken': RefreshToken,
        };
    }

    factory AuthTokenDetails.FromJson(Map<String, dynamic> json)
    {
      DateTime parseDateOrMin(String key)
      {
        final value = json[key];
        if (value is String)
        {
          final parsed = DateTime.tryParse(value);
          if (parsed != null)
          {
            return parsed.toUtc();
          }
        }

        // Fail-closed: invalid date → expired token
        return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
      }

      String readString(String key)
      {
        final value = json[key];
        return value is String ? value : "";
      }

      return AuthTokenDetails(
        Token: readString('Token'),
        ExpiredDate: parseDateOrMin('ExpiredDate'),
        RefreshToken: readString('RefreshToken'),
      );
    }
}
