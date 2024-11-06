import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:fluidsynth_ffi/src/midi_event.dart';

import '../fluidsynth_ffi.dart';
import 'log.dart';

class FluidSettings {
  late final Pointer<fluid_settings_t> instance;

  FluidSettings() {
    instance = FluidNative.bindings.new_fluid_settings();
  }

  void dispose() {
    FluidNative.bindings.delete_fluid_settings(instance);
  }

  String getString(String name) {
    final value = calloc<Pointer<Char>>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_dupstr(instance, name.toNativeUtf8().cast(), value);
      FluidLog.handleResult(result);

      return value.value.cast<Utf8>().toDartString();
    } finally {
      calloc.free(value);
    }
  }

  String getStringDefault(String name) {
    final defaultValue = calloc<Pointer<Char>>();
    try {
      final result = FluidNative.bindings.fluid_settings_getstr_default(
          instance, name.toNativeUtf8().cast(), defaultValue);
      FluidLog.handleResult(result);

      print('string default val: ${defaultValue.value}');

      return defaultValue.value.cast<Utf8>().toDartString();
    } finally {
      calloc.free(defaultValue);
    }
  }

  void setString(String name, String value) {
    final result = FluidNative.bindings.fluid_settings_setstr(
        instance, name.toNativeUtf8().cast(), value.toNativeUtf8().cast());
    FluidLog.handleResult(result);
  }
}
