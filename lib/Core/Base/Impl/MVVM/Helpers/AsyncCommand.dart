import 'dart:async';

import '../../../../Abstractions/Common/Event.dart';
import '../../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../Utils/LazyInjected.dart';
import 'ClickUtil.dart';

typedef AsyncExecuteFunc = Future<void> Function(Object? param);
typedef CanExecuteFunc = bool Function(Object? param);

class AsyncCommand
{
  static bool disableDoubleClickCheck = false;

  // -------- instance --------
  final AsyncExecuteFunc _executeFunc;
  final CanExecuteFunc? _canExecuteFunc;

  final loggingService = LazyInjected<ILoggingService>();
  final _doubleClickChecker = ClickUtil();
  final CanExecuteChanged = SimpleEvent();

  /// Primary constructor
  AsyncCommand(this._executeFunc, { CanExecuteFunc? canExecuteFunc,})
      : _canExecuteFunc = canExecuteFunc;

  bool CanExecute(Object? param)
  {
    return _canExecuteFunc?.call(param) ?? true;
  }

  Future<void> ExecuteAsync([Object? param]) async
  {
    if (!disableDoubleClickCheck)
    {
      if (!_doubleClickChecker.isOneClick())
      {
        loggingService.Value.LogWarning('AsyncCommand.executeAsync() is ignored because it is not permitted to execute second click within ${ClickUtil.oneClickDelay} ms');
        return;
      }
    }

    await _executeFunc(param);
  }

  void Execute([Object? param])
  {
    unawaited(this.ExecuteAsync(param));
  }

  void raiseCanExecuteChanged()
  {
     CanExecuteChanged.Invoke();
  }
}
