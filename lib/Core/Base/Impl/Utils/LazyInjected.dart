import 'package:get/get.dart';

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
class LazyInjected<T>
{
  final String? tag;
  T? _value;

  /// Creates a lazy dependency resolver.
  ///
  /// [tag] — optional GetX tag for named registrations.
  LazyInjected({this.tag});

  /// Gets the resolved dependency.
  /// The instance is resolved lazily on first access and cached.
  T get Value => _value ??= Get.find<T>(tag: tag);
}
