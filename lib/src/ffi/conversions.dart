/*
 * Helper for native conversion
 */

import 'dart:ffi';

import 'package:ffi/ffi.dart';

extension DartToNativeDoubleListExtension on List<double> {
  Pointer<Double> toNativeDoubles() {
    final pointer = calloc<Double>(length * sizeOf<Double>());

    for (int i = 0; i < length; i++) {
      pointer[i] = this[i];
    }

    return pointer;
  }
}

extension NativeToDartDoubleListExtension on Pointer<Double> {
  List<double> toDartDoubles(int length) {
    final array = List.filled(length, 0.0);

    for (int i = 0; i < length; i++) {
      array[i] = this[i];
    }

    return array;
  }
}

extension DartToNativeBooleanExtension on bool {
  int toNativeBoolean() {
    return this ? 1 : 0;
  }
}

extension NativeToDartBooleanExtension on int {
  bool toDartBoolean() {
    return this != 0;
  }
}
