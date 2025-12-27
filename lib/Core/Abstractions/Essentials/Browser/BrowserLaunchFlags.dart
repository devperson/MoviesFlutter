/// Additional flags that can be set to control how the browser opens.
enum BrowserLaunchFlags
{
    /// No additional flags. This is the default.
    None(0),

    /// Only applicable to Android: launches a new activity adjacent to the current activity if available.
    LaunchAdjacent(1),

    /// Only applicable to iOS: launches the browser as a page sheet with the system preferred browser where supported.
    PresentAsPageSheet(2),

    /// Only applicable to iOS: launches the browser as a form sheet with the system preferred browser where supported.
    PresentAsFormSheet(4);

    final int value;
    const BrowserLaunchFlags(this.value);
}
