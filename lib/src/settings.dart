import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:fluidsynth_ffi/src/ffi/conversions.dart';

import '../fluidsynth_ffi.dart';
import 'log.dart';

class FluidSettings implements Finalizable {
  static final _finalizer = NativeFinalizer(
      FluidNative.bindings.addresses.delete_fluid_settings.cast());

  late final Pointer<fluid_settings_t> instance;

  FluidSettings() {
    instance = FluidNative.bindings.new_fluid_settings();
    // _finalizer.attach(this, instance.cast(), detach: this);
  }

  void dispose() {
    _finalizer.detach(this);
  }

  FluidSettingsType getType(String name) {
    final pName = name.toNativeUtf8();
    try {
      final result =
          FluidNative.bindings.fluid_settings_get_type(instance, pName.cast());
      return FluidSettingsType.values.firstWhere((e) => e.code == result);
    } finally {
      calloc.free(pName);
    }
  }

  int getInt(String name) {
    final pName = name.toNativeUtf8();
    final pVal = calloc<Int>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_getint(instance, pName.cast(), pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pName);
      calloc.free(pVal);
    }
  }

  int getIntDefault(String name) {
    final pName = name.toNativeUtf8();
    final pVal = calloc<Int>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_getint_default(instance, pName.cast(), pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pName);
      calloc.free(pVal);
    }
  }

  ({int min, int max}) getIntRange(String name) {
    final pName = name.toNativeUtf8();
    final pMin = calloc<Int>();
    final pMax = calloc<Int>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_getint_range(instance, pName.cast(), pMin, pMax);
      FluidLog.handleResult(result);
      return (min: pMin.value, max: pMax.value);
    } finally {
      calloc.free(pName);
      calloc.free(pMin);
      calloc.free(pMax);
    }
  }

  double getNum(String name) {
    final pName = name.toNativeUtf8();
    final pVal = calloc<Double>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_getnum(instance, pName.cast(), pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pName);
      calloc.free(pVal);
    }
  }

  double getNumDefault(String name) {
    final pName = name.toNativeUtf8();
    final pVal = calloc<Double>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_getnum_default(instance, pName.cast(), pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pName);
      calloc.free(pVal);
    }
  }

  ({double min, double max}) getNumRange(String name) {
    final pName = name.toNativeUtf8();
    final pMin = calloc<Double>();
    final pMax = calloc<Double>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_getnum_range(instance, pName.cast(), pMin, pMax);
      FluidLog.handleResult(result);
      return (min: pMin.value, max: pMax.value);
    } finally {
      calloc.free(pName);
      calloc.free(pMin);
      calloc.free(pMax);
    }
  }

  String getString(String name) {
    final pName = name.toNativeUtf8();
    final pVal = calloc<Pointer<Char>>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_dupstr(instance, pName.cast(), pVal);
      FluidLog.handleResult(result);

      if (pVal.value != nullptr) {
        return pVal.value.cast<Utf8>().toDartString();
      } else {
        return "";
      }
    } finally {
      calloc.free(pName);
      calloc.free(pVal);
    }
  }

  String getStringDefault(String name) {
    final pName = name.toNativeUtf8();
    final pDefault = calloc<Pointer<Char>>();
    try {
      final result = FluidNative.bindings
          .fluid_settings_getstr_default(instance, pName.cast(), pDefault);
      FluidLog.handleResult(result);

      return pDefault.value.cast<Utf8>().toDartString();
    } finally {
      calloc.free(pName);
      calloc.free(pDefault);
    }
  }

  bool isRealtime(String name) {
    final pName = name.toNativeUtf8();
    try {
      final result = FluidNative.bindings
          .fluid_settings_is_realtime(instance, pName.cast());
      return result.toDartBoolean();
    } finally {
      calloc.free(pName);
    }
  }

  void setInt(String name, int value) {
    final pName = name.toNativeUtf8();
    try {
      final result = FluidNative.bindings
          .fluid_settings_setint(instance, pName.cast(), value);
      FluidLog.handleResult(result);
    } finally {
      calloc.free(pName);
    }
  }

  void setNum(String name, double value) {
    final pName = name.toNativeUtf8();
    try {
      final result = FluidNative.bindings
          .fluid_settings_setnum(instance, pName.cast(), value);
      FluidLog.handleResult(result);
    } finally {
      calloc.free(pName);
    }
  }

  void setString(String name, String value) {
    final pName = name.toNativeUtf8();
    final pVal = value.toNativeUtf8();
    try {
      final result = FluidNative.bindings
          .fluid_settings_setstr(instance, pName.cast(), pVal.cast());
      FluidLog.handleResult(result);
    } finally {
      calloc.free(pName);
      calloc.free(pVal);
    }
  }
}

enum FluidSettingsType {
  none(fluid_types_enum.FLUID_NO_TYPE),
  number(fluid_types_enum.FLUID_NUM_TYPE),
  integer(fluid_types_enum.FLUID_INT_TYPE),
  string(fluid_types_enum.FLUID_STR_TYPE),
  set(fluid_types_enum.FLUID_SET_TYPE),
  ;

  final int code;

  const FluidSettingsType(this.code);
}
