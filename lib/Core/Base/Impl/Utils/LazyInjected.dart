import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/ConsoleService.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';

/// LazyInjected<T>
/// ----------------
/// A lightweight lazy resolver for dependencies using GetX DI.
///
/// Why this exists:
/// - Avoids calling `Get.find<T>()` directly everywhere
/// - Centralizes DI usage behind a single abstraction
/// - Makes it easier to switch DI frameworks in the future
///   (e.g. GetX → GetIt / Riverpod / custom container)
/// Benefits:
/// - Lazy: dependency is resolved only when first accessed
/// - Cached: resolved instance is reused
/// - Explicit: no hidden reflection or magic
/// - Testable: can be overridden or mocked easily
/// Architectural note:
/// Prefer using `LazyInjected<T>` instead of `Get.find<T>()`
/// directly inside services, controllers, or view models.
/// This limits DI framework coupling to one place.
class LazyInjected<T> with ConsoleService
{
  T? _value;
  /// Gets the resolved dependency.
  /// The instance is resolved lazily on first access and cached.
  T get Value
  {
    if(_value == null)
      {
        try
        {
          _value = ContainerLocator.Resolve<T>();
          return _value!;
        }
        catch(ex, stackTrace)
        {
          // final logger = _getLogger();
          // if(logger != null)
          // {
          //   logger.LogError(ex, stackTrace);
          // }
          PrintException(ex, stackTrace);
          rethrow;
        }
      }
    else
      {
        return _value!;
      }
  }

  ILoggingService? _getLogger()
  {
    try
        {
          final logger = ContainerLocator.Resolve<ILoggingService>();
          return logger;
        }
    catch(ex, stackTrace)
    {
      PrintException(ex, stackTrace);
      return null;
    }

  }



}
