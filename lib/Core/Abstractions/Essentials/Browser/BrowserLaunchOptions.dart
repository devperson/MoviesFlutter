import '../../Common/XfColor.dart';
import 'BrowserLaunchMode.dart';
import 'BrowserLaunchFlags.dart';
import 'BrowserTitleMode.dart';

/// Optional setting to open the browser with.
/// Remarks: Not all settings apply to all operating systems. Check documentation for more information.
class BrowserLaunchOptions
{
    /// Gets or sets the preferred color of the toolbar background of the in-app browser.
    /// Remarks: This setting only applies to iOS and Android.
    XfColor? PreferredToolbarColor;

    /// Gets or sets the preferred color of the controls on the in-app browser.
    /// Remarks: This setting only applies to iOS.
    XfColor? PreferredControlColor;

    /// Gets or sets how the browser should be launched.
    /// Remarks: The default value is [BrowserLaunchMode.SystemPreferred].
    BrowserLaunchMode LaunchMode = BrowserLaunchMode.SystemPreferred;

    /// Gets or sets the preferred mode for the title display.
    /// Remarks: The default value is [BrowserTitleMode.Default]. This setting only applies to Android.
    BrowserTitleMode TitleMode = BrowserTitleMode.Default;

    /// Gets or sets additional launch flags that may or may not take effect based on the device and [LaunchMode].
    /// Remarks: The default value is [BrowserLaunchFlags.None]. Not all flags work on all platforms, check the flag descriptions.
    BrowserLaunchFlags Flags = BrowserLaunchFlags.None;

    bool HasFlag(BrowserLaunchFlags flag) => (Flags.value & flag.value) != 0;
}
