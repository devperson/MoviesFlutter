import 'BrowserLaunchOptions.dart';

/// Provides a way to display a web page inside an app.
abstract interface class IBrowser
{
    /// Open the browser to specified URI.
    /// [uri] URI to open.
    /// Returns Completed task when browser is launched, but not necessarily closed. Result indicates if launching was successful or not.
    Future<bool> OpenAsync(String uri, {BrowserLaunchOptions? options});
}
