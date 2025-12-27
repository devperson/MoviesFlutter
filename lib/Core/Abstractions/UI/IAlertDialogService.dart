abstract interface class IAlertDialogService
{
    Future<void> DisplayAlert(String title, String message, {String cancel = "Close"});
    Future<bool> ConfirmAlert(String title, String message, List<String> buttons);
    Future<String?> DisplayActionSheet(String title, {String? cancel, String? destruction, List<String> buttons = const []});
}
