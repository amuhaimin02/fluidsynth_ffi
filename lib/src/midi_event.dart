import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:fluidsynth_ffi/fluidsynth_ffi.dart';

import 'log.dart';

class FluidMidiEvent {
  late final Pointer<fluid_midi_event_t> instance;

  FluidMidiEvent() {
    instance = FluidNative.bindings.new_fluid_midi_event();
  }

  FluidMidiEvent.fromInstance(this.instance);

  void dispose() {
    FluidNative.bindings.delete_fluid_midi_event(instance);
  }

  // Channel
  int get channel {
    return FluidNative.bindings.fluid_midi_event_get_channel(instance);
  }

  set channel(int value) {
    final result =
        FluidNative.bindings.fluid_midi_event_set_channel(instance, value);
    FluidLog.handleResult(result);
  }

  // Control
  int get control {
    return FluidNative.bindings.fluid_midi_event_get_control(instance);
  }

  set control(int value) {
    final result =
        FluidNative.bindings.fluid_midi_event_set_control(instance, value);
    FluidLog.handleResult(result);
  }

  // Key
  int get key {
    return FluidNative.bindings.fluid_midi_event_get_key(instance);
  }

  set key(int value) {
    final result =
        FluidNative.bindings.fluid_midi_event_set_key(instance, value);
    FluidLog.handleResult(result);
  }

  // Lyrics
  String get lyrics {
    final data = calloc<Pointer<Void>>();
    final size = calloc<Int>();
    FluidNative.bindings.fluid_midi_event_get_lyrics(instance, data, size);
    final lyrics = data.value.cast<Utf8>().toDartString(length: size.value);
    calloc.free(data);
    calloc.free(size);
    return lyrics;
  }

  set lyrics(String value) {
    final data = value.toNativeUtf8(allocator: calloc);
    final result = FluidNative.bindings.fluid_midi_event_set_lyrics(
        instance, data.cast<Void>(), data.length, 1);
    FluidLog.handleResult(result);
    calloc.free(data);
  }

  // Pitch
  int get pitch {
    return FluidNative.bindings.fluid_midi_event_get_pitch(instance);
  }

  set pitch(int value) {
    final result =
        FluidNative.bindings.fluid_midi_event_set_pitch(instance, value);
    FluidLog.handleResult(result);
  }

  // Program
  int get program {
    return FluidNative.bindings.fluid_midi_event_get_program(instance);
  }

  set program(int value) {
    final result =
        FluidNative.bindings.fluid_midi_event_set_program(instance, value);
    FluidLog.handleResult(result);
  }

  // Text
  String get text {
    final data = calloc<Pointer<Void>>();
    final size = calloc<Int>();
    FluidNative.bindings.fluid_midi_event_get_text(instance, data, size);
    final lyrics = data.value.cast<Utf8>().toDartString(length: size.value);
    calloc.free(data);
    calloc.free(size);
    return lyrics;
  }

  set text(String value) {
    final data = value.toNativeUtf8(allocator: calloc);
    final result = FluidNative.bindings
        .fluid_midi_event_set_text(instance, data.cast<Void>(), data.length, 1);
    FluidLog.handleResult(result);
    calloc.free(data);
  }

  // Type
  int get type {
    return FluidNative.bindings.fluid_midi_event_get_type(instance);
  }

  set type(int value) {
    final result =
        FluidNative.bindings.fluid_midi_event_set_type(instance, value);
    FluidLog.handleResult(result);
  }

  // Value
  int get value {
    return FluidNative.bindings.fluid_midi_event_get_value(instance);
  }

  set value(int value) {
    final result =
        FluidNative.bindings.fluid_midi_event_set_value(instance, value);
    FluidLog.handleResult(result);
  }

  // Velocity
  int get velocity {
    return FluidNative.bindings.fluid_midi_event_get_velocity(instance);
  }

  set velocity(int value) {
    final result =
        FluidNative.bindings.fluid_midi_event_set_velocity(instance, value);
    FluidLog.handleResult(result);
  }
}
