import 'package:fluidsynth_ffi/src/exception.dart';

class FluidLog {
  static void handleResult(int resultCode) {
    if (resultCode == -1) {
      throw const FluidException('Operation failed');
    }
  }
}
