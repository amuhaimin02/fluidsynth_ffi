import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import '../fluidsynth_ffi.dart';
import 'log.dart';

typedef _NativeMidiEventCallback = Void Function(
    Pointer<Void> data, Pointer<fluid_midi_event_t> event);

typedef _NativeMidiTickCallback = Void Function(Pointer<Void> data, Int tick);

class FluidPlayer implements Finalizable {
  static final _finalizer = NativeFinalizer(
      FluidNative.bindings.addresses.delete_fluid_player.cast());

  late final Pointer<fluid_player_t> instance;

  FluidPlayer(FluidSynth synth) {
    instance = FluidNative.bindings.new_fluid_player(synth.instance);
    _finalizer.attach(this, instance.cast());
  }

  void dispose() {
    _finalizer.detach(this);
  }

  void add(File midiFile) {
    final result = FluidNative.bindings
        .fluid_player_add(instance, midiFile.path.toNativeUtf8().cast());
    return FluidLog.handleResult(result);
  }

  int get bpm {
    final result = FluidNative.bindings.fluid_player_get_bpm(instance);
    return result;
  }

  int get currentTick {
    final result = FluidNative.bindings.fluid_player_get_current_tick(instance);
    return result;
  }

  int get division {
    final result = FluidNative.bindings.fluid_player_get_division(instance);
    return result;
  }

  int get midiTempo {
    final result = FluidNative.bindings.fluid_player_get_midi_tempo(instance);
    return result;
  }

  FluidPlayerStatus get status {
    final result = FluidNative.bindings.fluid_player_get_status(instance);
    return FluidPlayerStatus.from(result);
  }

  int get totalTicks {
    final result = FluidNative.bindings.fluid_player_get_total_ticks(instance);
    return result;
  }

  void join() {
    final result = FluidNative.bindings.fluid_player_join(instance);
    return FluidLog.handleResult(result);
  }

  void play() {
    final result = FluidNative.bindings.fluid_player_play(instance);
    return FluidLog.handleResult(result);
  }

  void seek(int ticks) {
    final result = FluidNative.bindings.fluid_player_seek(instance, ticks);
    return FluidLog.handleResult(result);
  }

  set bpm(int value) {
    final result = FluidNative.bindings.fluid_player_set_bpm(instance, value);
    FluidLog.handleResult(result);
  }

  set loop(int value) {
    final result = FluidNative.bindings.fluid_player_set_loop(instance, value);
    FluidLog.handleResult(result);
  }

  set midiTempo(int value) {
    final result =
        FluidNative.bindings.fluid_player_set_midi_tempo(instance, value);
    FluidLog.handleResult(result);
  }

  set playbackCallback(Function(FluidMidiEvent event) callback) {
    late final NativeCallable<_NativeMidiEventCallback> nativeCallable;

    void onResponse(Pointer<Void> data, Pointer<fluid_midi_event_t> event) {
      callback(FluidMidiEvent.fromInstance(event));
    }

    nativeCallable =
        NativeCallable<_NativeMidiEventCallback>.listener(onResponse);

    int result = FluidNative.bindings.fluid_player_set_playback_callback(
        instance.cast(), nativeCallable.nativeFunction.cast(), nullptr);
    FluidLog.handleResult(result);
  }

  void tempo(int tempoType, double value) {
    final result =
        FluidNative.bindings.fluid_player_set_tempo(instance, tempoType, value);
    FluidLog.handleResult(result);
  }

  set tickCallback(Function(int tick) callback) {
    late final NativeCallable<_NativeMidiTickCallback> nativeCallable;

    void onResponse(Pointer<Void> data, int tick) {
      callback(tick);
    }

    nativeCallable =
        NativeCallable<_NativeMidiTickCallback>.listener(onResponse);

    int result = FluidNative.bindings.fluid_player_set_tick_callback(
        instance.cast(), nativeCallable.nativeFunction.cast(), instance.cast());
    FluidLog.handleResult(result);
  }

  void stop() {
    final result = FluidNative.bindings.fluid_player_stop(instance);
    return FluidLog.handleResult(result);
  }
}

enum FluidPlayerStatus {
  ready(fluid_player_status.FLUID_PLAYER_READY),
  playing(fluid_player_status.FLUID_PLAYER_PLAYING),
  stopping(fluid_player_status.FLUID_PLAYER_STOPPING),
  done(fluid_player_status.FLUID_PLAYER_DONE);

  final int code;

  const FluidPlayerStatus(this.code);

  factory FluidPlayerStatus.from(int code) {
    return values.firstWhere((val) => val.code == code);
  }
}
