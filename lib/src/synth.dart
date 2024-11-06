import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:fluidsynth_ffi/src/midi_event.dart';
import '../fluidsynth_ffi.dart';
import 'log.dart';

class FluidSynth {
  late final Pointer<fluid_synth_t> instance;

  FluidSynth(FluidSettings settings) {
    instance = FluidNative.bindings.new_fluid_synth(settings.instance);
  }

  void dispose() {
    FluidNative.bindings.delete_fluid_synth(instance);
  }

  // MIDI channel messages

  void allNotesOff(int channel) {
    final result =
        FluidNative.bindings.fluid_synth_all_notes_off(instance, channel);
    FluidLog.handleResult(result);
  }

  void allSoundsOff(int channel) {
    final result =
        FluidNative.bindings.fluid_synth_all_sounds_off(instance, channel);
    FluidLog.handleResult(result);
  }

  void bankSelect({required int channel, required int bank}) {
    final result =
        FluidNative.bindings.fluid_synth_bank_select(instance, channel, bank);
    FluidLog.handleResult(result);
  }

  void controlChange(
      {required int channel, required int control, required int value}) {
    final result =
        FluidNative.bindings.fluid_synth_cc(instance, channel, control, value);
    FluidLog.handleResult(result);
  }

  void channelPressure({required int channel, required int value}) {
    final result = FluidNative.bindings
        .fluid_synth_channel_pressure(instance, channel, value);
    FluidLog.handleResult(result);
  }

  int getControlChange({required int channel, required int control}) {
    final pVal = calloc<Int>();
    try {
      final result = FluidNative.bindings
          .fluid_synth_get_cc(instance, channel, control, pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pVal);
    }
  }

  void systemReset() {
    final result = FluidNative.bindings.fluid_synth_system_reset(instance);
    FluidLog.handleResult(result);
  }

  // ----------------

  int loadSoundfont(File soundfontFile, {bool resetPresets = false}) {
    final result = FluidNative.bindings.fluid_synth_sfload(instance,
        soundfontFile.path.toNativeUtf8().cast(), resetPresets ? 1 : 0);
    return result; // Soundfont ID
  }

  void unloadSoundfont(int soundfontId, {bool resetPresets = false}) {
    final result = FluidNative.bindings
        .fluid_synth_sfunload(instance, soundfontId, resetPresets ? 1 : 0);
    return FluidLog.handleResult(result);
  }

  void programChange({required int channel, required int program}) {
    final result = FluidNative.bindings
        .fluid_synth_program_change(instance, channel, program);
    return FluidLog.handleResult(result);
  }

  void handleMidiEvent(FluidMidiEvent event) {
    final result = FluidNative.bindings
        .fluid_synth_handle_midi_event(instance.cast(), event.instance);
    return FluidLog.handleResult(result);
  }

  double get gain {
    return FluidNative.bindings.fluid_synth_get_gain(instance);
  }

  set gain(double value) {
    FluidNative.bindings.fluid_synth_set_gain(instance, value);
  }
}
