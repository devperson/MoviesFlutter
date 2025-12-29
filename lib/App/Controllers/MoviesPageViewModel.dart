import 'package:movies_flutter/App/Controllers/LoginPageViewModel.dart';
import 'package:movies_flutter/App/Pages/LoginPage.dart';

import '../../Core/Abstractions/Navigation/NavigationParameters.dart';
import '../../Core/Base/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/MVVM/Helpers/ObservableCollection.dart';
import '../../Core/Base/MVVM/ViewModels/PageViewModel.dart';

class MoviesPageViewModel extends PageViewModel
{
  static const Name = 'MoviesPageViewModel';

  int count = 150;
  final StringItems = ObservableCollection<String>();
  late final RemoveCommand = AsyncCommand(OnRemoveCommand);
  late final ShareLogsCommand = AsyncCommand(OnShareLogsCommand);
  late final LogoutCommand = AsyncCommand(OnLogoutCommand);

  @override
  void Initialize(NavigationParameters parameters)
  {
    // TODO: implement Initialize
    super.Initialize(parameters);

    final List<String> items = List<String>.generate(100, (index) => 'Item ${index + 1}');
    this.StringItems.AddRange(items);
    this.update();
  }

  @override
  void Destroy()
  {
    super.Destroy();
  }

  Future<void> increment() async
  {
    count++;
    this.StringItems.Insert(5, 'New Item $count');
  }


  Future<void> OnRemoveCommand(Object? param) async
  {
    final index = param as int;
    this.StringItems.RemoveAt(index);
  }

  Future<void> OnShareLogsCommand(Object? param) async
  {

  }

  Future<void> OnLogoutCommand(Object? param) async
  {
      this.Navigate("/"+LoginPageViewModel.Name);
  }
}