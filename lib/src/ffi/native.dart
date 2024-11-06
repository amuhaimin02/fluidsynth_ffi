import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:fluidsynth_ffi/src/ffi/generated_bindings.dart';

class FluidNative {
  static const String _libName = 'fluidsynth';

  /// The dynamic library in which the symbols for [FluidSynthBindings] can be found.
  static final DynamicLibrary _dylib = () {
    if (Platform.isMacOS || Platform.isIOS) {
      // TODO: Support custom bundling
      return DynamicLibrary.open('/opt/homebrew/lib/lib$_libName.dylib');
    }
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('lib$_libName.so');
    }
    if (Platform.isWindows) {
      return DynamicLibrary.open('$_libName.dll');
    }
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }();

  /// The bindings to the native functions in [_dylib].
  static final FluidSynthBindings bindings = FluidSynthBindings(_dylib);

  FluidNative._();
}
