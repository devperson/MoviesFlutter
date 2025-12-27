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
}
