
enum BrowserTitleMode
{
   /// <summary>Uses the system default.</summary>
   Default(0),
   /// <summary>Show the title.</summary>
   Show(1),
   /// <summary>Hide the title.</summary>
   Hide(2);

  final int value;
  const BrowserTitleMode(this.value);

}