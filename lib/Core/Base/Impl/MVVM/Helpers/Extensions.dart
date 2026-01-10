extension DebugList<T> on List<T>
{
  String ToDebugString()
  {
    final sb = StringBuffer('List[${length}] ');

    for (final item in this)
    {
      sb.write('$item, ');
    }

    return sb.toString();
  }
}