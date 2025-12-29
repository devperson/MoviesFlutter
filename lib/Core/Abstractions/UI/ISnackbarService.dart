import '../../Event.dart';

abstract interface class ISnackbarService
{
    Event<SeverityType> get PopupShowed;
    void ShowError(String message);
    void ShowInfo(String message);
    void Show(String message, SeverityType severityType, {int duration = 10000});
}

enum SeverityType
{
    Info,
    Success,
    Warning,
    Error
}
