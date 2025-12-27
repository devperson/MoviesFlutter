/// Launch type of the browser.
/// Remarks: It's recommended to use the [BrowserLaunchMode.SystemPreferred] as it is the default and gracefully falls back if needed.
enum BrowserLaunchMode
{
    /// Launch the optimized system browser and stay inside of your application. Chrome Custom Tabs on Android and SFSafariViewController on iOS.
    SystemPreferred,

    /// Use the default external launcher to open the browser outside of the app.
    External
}
