import 'DisplayInfo.dart';

abstract interface class IDisplay
{
    DisplayInfo GetDisplayInfo();
    bool GetDisplayKeepOnValue();
    void SetDisplayKeepOnValue(bool keepOn);
}
