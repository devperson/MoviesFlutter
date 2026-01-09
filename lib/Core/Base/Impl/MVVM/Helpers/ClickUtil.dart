
class ClickUtil
{
  static const int oneClickDelay = 1000; // milliseconds

  int _lastClickTime = 0;

  bool isOneClick()
  {
    final int clickTime = DateTime.now().millisecondsSinceEpoch;

    if (clickTime - _lastClickTime < oneClickDelay)
    {
      return false;
    }

    _lastClickTime = clickTime;
    return true;
  }
}
