class UrlNavigationHelper
{
  bool IsPop = false;
  bool IsMultiPop = false;
  bool IsMultiPopAndPush = false;
  bool IsPush = false;
  bool IsPushAsRoot = false;
  bool IsMultiPushAsRoot = false;

  UrlNavigationHelper();

  static UrlNavigationHelper Parse(String url)
  {
    final obj = UrlNavigationHelper();

    if (url == "../")
    {
      obj.IsPop = true;
    }
    else if (url.contains("../"))
    {
      final trimmed = url.replaceAll("../", "");

      obj.IsMultiPop = trimmed.isEmpty;
      obj.IsMultiPopAndPush = !obj.IsMultiPop;
    }
    else if (url.contains("/"))
    {
      final pages = url
          .split("/")
          .where((p) => p.isNotEmpty)
          .toList();

      if (pages.length > 1)
      {
        obj.IsMultiPushAsRoot = true;
      }
      else
      {
        obj.IsPushAsRoot = true;
      }
    }
    else if (url.isNotEmpty)
    {
      obj.IsPush = true;
    }

    return obj;
  }
}
