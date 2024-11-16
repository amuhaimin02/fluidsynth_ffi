import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:fluidsynth_ffi/src/ffi/conversions.dart';
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

  String error() {
    final pError = FluidNative.bindings.fluid_synth_error(instance);
    try {
      return pError.cast<Utf8>().toDartString();
    } finally {
      calloc.free(pError);
    }
  }

  double getCPULoad() {
    final result = FluidNative.bindings.fluid_synth_get_cpu_load(instance);
    return result;
  }

  /// **************************************************************************
  /// Audio Rendering
  /// **************************************************************************

  // TODO: Add nwrite_float
  // TODO: Add process

  List<double> writeFloat({
    required int length,
  }) {
    const numChannels = 2;
    final buffer = calloc<Double>(length * numChannels);

    final result = FluidNative.bindings.fluid_synth_write_float(
      instance,
      length,
      buffer.cast(),
      0,
      numChannels,
      buffer.cast(),
      1,
      numChannels,
    );
    FluidLog.handleResult(result);

    return buffer.asTypedList(length * numChannels);
  }

  Int16List writeSigned16Bit({
    required int length,
  }) {
    const numChannels = 2;
    final buffer = calloc<Int16>(length * numChannels);

    final result = FluidNative.bindings.fluid_synth_write_s16(
      instance,
      length,
      buffer.cast(),
      0,
      numChannels,
      buffer.cast(),
      1,
      numChannels,
    );
    FluidLog.handleResult(result);

    return buffer.asTypedList(length * numChannels);
  }

  /// **************************************************************************
  /// Effect - Chorus
  /// **************************************************************************

  void setChorus({
    required int nr,
    required double level,
    required double speed,
    required double depthMs,
    required int type,
  }) {
    FluidNative.bindings
        .fluid_synth_set_chorus(instance, nr, level, speed, depthMs, type);
  }

  void setChorusOn(bool on) {
    FluidNative.bindings
        .fluid_synth_set_chorus_on(instance, on.toNativeBoolean());
  }

  int getChorusNumber() {
    return FluidNative.bindings.fluid_synth_get_chorus_nr(instance);
  }

  double getChorusLevel() {
    return FluidNative.bindings.fluid_synth_get_chorus_level(instance);
  }

  double getChorusSpeed() {
    return FluidNative.bindings.fluid_synth_get_chorus_speed(instance);
  }

  double getChorusDepth() {
    return FluidNative.bindings.fluid_synth_get_chorus_depth(instance);
  }

  int getChorusType() {
    return FluidNative.bindings.fluid_synth_get_chorus_type(instance);
  }

  /// **************************************************************************
  /// Effect - IIR Filter
  /// **************************************************************************

  /// **************************************************************************
  /// Effect - LADSPA
  /// **************************************************************************

  /// **************************************************************************
  /// Effect - Reverb
  /// **************************************************************************

  void reverbOn(bool on, {int? fxGroup}) {
    FluidNative.bindings
        .fluid_synth_reverb_on(instance, fxGroup ?? -1, on.toNativeBoolean());
  }

  double getReverbRoomSize({int? fxGroup}) {
    final pVal = calloc<Double>();
    try {
      final result = FluidNative.bindings
          .fluid_synth_get_reverb_group_roomsize(instance, fxGroup ?? -1, pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pVal);
    }
  }

  double getReverbDamp({int? fxGroup}) {
    final pVal = calloc<Double>();
    try {
      final result = FluidNative.bindings
          .fluid_synth_get_reverb_group_damp(instance, fxGroup ?? -1, pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pVal);
    }
  }

  double getReverbLevel({int? fxGroup}) {
    final pVal = calloc<Double>();
    try {
      final result = FluidNative.bindings
          .fluid_synth_get_reverb_group_level(instance, fxGroup ?? -1, pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pVal);
    }
  }

  double getReverbWidth({int? fxGroup}) {
    final pVal = calloc<Double>();
    try {
      final result = FluidNative.bindings
          .fluid_synth_get_reverb_group_width(instance, fxGroup ?? -1, pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pVal);
    }
  }

  void setReverbRoomSize(double value, {int? fxGroup}) {
    final result = FluidNative.bindings
        .fluid_synth_set_reverb_group_roomsize(instance, fxGroup ?? -1, value);
    FluidLog.handleResult(result);
  }

  void setReverbDamp(double value, {int? fxGroup}) {
    final result = FluidNative.bindings
        .fluid_synth_set_reverb_group_damp(instance, fxGroup ?? -1, value);
    FluidLog.handleResult(result);
  }

  void setReverbLevel(double value, {int? fxGroup}) {
    final result = FluidNative.bindings
        .fluid_synth_set_reverb_group_level(instance, fxGroup ?? -1, value);
    FluidLog.handleResult(result);
  }

  void setReverbWidth(double value, {int? fxGroup}) {
    final result = FluidNative.bindings
        .fluid_synth_set_reverb_group_width(instance, fxGroup ?? -1, value);
    FluidLog.handleResult(result);
  }

  /// **************************************************************************
  /// MIDI Channel Messages
  /// **************************************************************************

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

  double getGen({required int channel, required int param}) {
    final result =
        FluidNative.bindings.fluid_synth_get_gen(instance, channel, param);
    return result;
  }

  int getPitchBend({required int channel}) {
    final pVal = calloc<Int>();
    try {
      final result = FluidNative.bindings
          .fluid_synth_get_pitch_bend(instance, channel, pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pVal);
    }
  }

  int getPitchWheelSensitivity({required int channel}) {
    final pVal = calloc<Int>();
    try {
      final result = FluidNative.bindings
          .fluid_synth_get_pitch_wheel_sens(instance, channel, pVal);
      FluidLog.handleResult(result);
      return pVal.value;
    } finally {
      calloc.free(pVal);
    }
  }

  ({int soundFontId, int bankNumber, int presetNumber}) getProgram(
      {required int channel}) {
    final pSfontId = calloc<Int>();
    final pBankNum = calloc<Int>();
    final pPresetNum = calloc<Int>();
    try {
      final result = FluidNative.bindings.fluid_synth_get_program(
          instance, channel, pSfontId, pBankNum, pPresetNum);
      FluidLog.handleResult(result);
      return (
        soundFontId: pSfontId.value,
        bankNumber: pBankNum.value,
        presetNumber: pPresetNum.value
      );
    } finally {
      calloc.free(pSfontId);
      calloc.free(pBankNum);
      calloc.free(pPresetNum);
    }
  }

  void keyPressure(
      {required int channel, required int key, required int value}) {
    final result = FluidNative.bindings
        .fluid_synth_key_pressure(instance, channel, key, value);
    FluidLog.handleResult(result);
  }

  void noteOff({required int channel, required int key}) {
    final result =
        FluidNative.bindings.fluid_synth_noteoff(instance, channel, key);
    FluidLog.handleResult(result);
  }

  void noteOn({required int channel, required int key, required int velocity}) {
    final result = FluidNative.bindings
        .fluid_synth_noteon(instance, channel, key, velocity);
    FluidLog.handleResult(result);
  }

  void pitchBend({required int channel, required int value}) {
    final result =
        FluidNative.bindings.fluid_synth_pitch_bend(instance, channel, value);
    FluidLog.handleResult(result);
  }

  void pitchWheelSensitivity({required int channel, required int value}) {
    final result = FluidNative.bindings
        .fluid_synth_pitch_wheel_sens(instance, channel, value);
    FluidLog.handleResult(result);
  }

  void programChange({required int channel, required int program}) {
    final result = FluidNative.bindings
        .fluid_synth_program_change(instance, channel, program);
    FluidLog.handleResult(result);
  }

  void programReset() {
    final result = FluidNative.bindings.fluid_synth_program_reset(instance);
    FluidLog.handleResult(result);
  }

  void programSelect({
    required int channel,
    required int soundfontId,
    required int bankNum,
    required int presetNum,
  }) {
    final result = FluidNative.bindings.fluid_synth_program_select(
        instance, channel, soundfontId, bankNum, presetNum);
    FluidLog.handleResult(result);
  }

  void programSelectBySoundfontName({
    required int channel,
    required String soundfontName,
    required int bankNum,
    required int presetNum,
  }) {
    final pSoundfontName = soundfontName.toNativeUtf8();
    try {
      final result = FluidNative.bindings
          .fluid_synth_program_select_by_sfont_name(
              instance, channel, pSoundfontName.cast(), bankNum, presetNum);
      FluidLog.handleResult(result);
    } finally {
      calloc.free(pSoundfontName);
    }
  }

  void setGen(
      {required int channel, required int param, required double value}) {
    final result = FluidNative.bindings
        .fluid_synth_set_gen(instance, channel, param, value);
    FluidLog.handleResult(result);
  }

  void soundfontSelect({required int channel, required int soundfontId}) {
    final result = FluidNative.bindings
        .fluid_synth_sfont_select(instance, channel, soundfontId);
    FluidLog.handleResult(result);
  }

  ({bool handled, String? response}) sysEx({
    required String data,
    required bool dryRun,
  }) {
    final pData = data.toNativeUtf8();
    final pResponse = calloc<Char>();
    final pResponseLength = calloc<Int>();
    final pHandled = calloc<Int>();
    try {
      final result = FluidNative.bindings.fluid_synth_sysex(
        instance,
        pData.cast(),
        data.length,
        pResponse,
        pResponseLength,
        pHandled,
        dryRun.toNativeBoolean(),
      );
      FluidLog.handleResult(result);

      final handled = pHandled.value == 1;
      final response =
          pResponse.cast<Utf8>().toDartString(length: pResponseLength.value);
      return (handled: handled, response: response);
    } finally {
      calloc.free(pData);
      calloc.free(pResponse);
      calloc.free(pResponseLength);
      calloc.free(pHandled);
    }
  }

  void systemReset() {
    final result = FluidNative.bindings.fluid_synth_system_reset(instance);
    FluidLog.handleResult(result);
  }

  void unsetProgram({required int channel}) {
    final result =
        FluidNative.bindings.fluid_synth_unset_program(instance, channel);
    FluidLog.handleResult(result);
  }

  /// **************************************************************************
  /// MIDI Tuning
  /// **************************************************************************

  void activateKeyTuning({
    required int bank,
    required int program,
    required String name,
    required List<double>? pitch,
    required bool apply,
  }) {
    final pName = name.toNativeUtf8();
    final pPitch = pitch?.toNativeDoubles() ?? nullptr;
    try {
      final result = FluidNative.bindings.fluid_synth_activate_key_tuning(
        instance,
        bank,
        program,
        pName.cast(),
        pPitch,
        apply.toNativeBoolean(),
      );
      FluidLog.handleResult(result);
    } finally {
      calloc.free(pName);
      calloc.free(pPitch);
    }
  }

  void activateOctaveTuning({
    required int bank,
    required int program,
    required String name,
    required List<double> pitch,
    required bool apply,
  }) {
    final pName = name.toNativeUtf8();
    final pPitch = pitch.toNativeDoubles();
    try {
      final result = FluidNative.bindings.fluid_synth_activate_octave_tuning(
        instance,
        bank,
        program,
        pName.cast(),
        pPitch,
        apply.toNativeBoolean(),
      );
      FluidLog.handleResult(result);
    } finally {
      calloc.free(pName);
      calloc.free(pPitch);
    }
  }

  void activateTuning({
    required int channel,
    required int bank,
    required int program,
    required bool apply,
  }) {
    final result = FluidNative.bindings.fluid_synth_activate_tuning(
      instance,
      channel,
      bank,
      program,
      apply.toNativeBoolean(),
    );
    FluidLog.handleResult(result);
  }

  void deactivateTuning({
    required int channel,
    required bool apply,
  }) {
    final result = FluidNative.bindings.fluid_synth_deactivate_tuning(
      instance,
      channel,
      apply.toNativeBoolean(),
    );
    FluidLog.handleResult(result);
  }

  void tuneNotes({
    required int bank,
    required int program,
    required Map<int, double> keyToPitch,
    required bool apply,
  }) {
    final length = keyToPitch.length;

    final pKey = calloc<Int>(length * sizeOf<Int>());
    final pPitch = calloc<Double>(length * sizeOf<Double>());

    int i = 0;
    for (final entry in keyToPitch.entries) {
      pKey[i] = entry.key;
      pPitch[i] = entry.value;
      i++;
    }

    try {
      final result = FluidNative.bindings.fluid_synth_tune_notes(
        instance,
        bank,
        program,
        length,
        pKey,
        pPitch,
        apply.toNativeBoolean(),
      );
      FluidLog.handleResult(result);
    } finally {
      calloc.free(pKey);
      calloc.free(pPitch);
    }
  }

  ({String name, List<double> pitch}) tuningDump(
      {required int bank, required int program, int nameLengthLimit = 256}) {
    const pitchCount = 128;

    final pName = calloc<Char>(nameLengthLimit * sizeOf<Char>());
    final pPitch = calloc<Double>(pitchCount * sizeOf<Double>());

    try {
      final result = FluidNative.bindings.fluid_synth_tuning_dump(
        instance,
        bank,
        program,
        pName,
        nameLengthLimit,
        pPitch,
      );
      FluidLog.handleResult(result);

      return (
        name: pName.cast<Utf8>().toDartString(),
        pitch: pPitch.toDartDoubles(pitchCount)
      );
    } finally {
      calloc.free(pName);
      calloc.free(pPitch);
    }
  }

  ({int bank, int program}) tuningIterationNext() {
    final pBank = calloc<Int>();
    final pProgram = calloc<Int>();
    try {
      final result = FluidNative.bindings.fluid_synth_tuning_iteration_next(
        instance,
        pBank,
        pProgram,
      );
      FluidLog.handleResult(result);
      return (bank: pBank.value, program: pProgram.value);
    } finally {
      calloc.free(pBank);
      calloc.free(pProgram);
    }
  }

  void tuningIterationStart() {
    FluidNative.bindings.fluid_synth_tuning_iteration_start(instance);
  }

  /// **************************************************************************
  /// Soundfont Management
  /// **************************************************************************

  // TODO: Add soundfont class

  int getBankOffset({required int soundfontId}) {
    final result =
        FluidNative.bindings.fluid_synth_get_bank_offset(instance, soundfontId);
    return result;
  }

  void setBankOffset({required int soundfontId, required int offset}) {
    final result = FluidNative.bindings
        .fluid_synth_set_bank_offset(instance, soundfontId, offset);

    FluidLog.handleResult(result);
  }

  int soundfontCount() {
    final result = FluidNative.bindings.fluid_synth_sfcount(instance);
    return result;
  }

  int soundfontLoad(File file, {bool resetPresets = false}) {
    final result = FluidNative.bindings.fluid_synth_sfload(instance,
        file.path.toNativeUtf8().cast(), resetPresets.toNativeBoolean());
    return result; // Soundfont ID
  }

  void soundfontReload(int soundfontId) {
    final result =
        FluidNative.bindings.fluid_synth_sfreload(instance, soundfontId);
    FluidLog.handleResult(result);
  }

  void soundfontUnload(int soundfontId, {bool resetPresets = false}) {
    final result = FluidNative.bindings.fluid_synth_sfunload(
        instance, soundfontId, resetPresets.toNativeBoolean());
    return FluidLog.handleResult(result);
  }

  /// **************************************************************************
  /// Synthesis Parameters
  /// **************************************************************************

  // TODO: Add mod class

  int countAudioChannels() {
    final result =
        FluidNative.bindings.fluid_synth_count_audio_channels(instance);
    return result;
  }

  int countAudioGroups() {
    final result =
        FluidNative.bindings.fluid_synth_count_audio_groups(instance);
    return result;
  }

  int countEffectsChannels() {
    final result =
        FluidNative.bindings.fluid_synth_count_effects_channels(instance);
    return result;
  }

  int countEffectsGroups() {
    final result =
        FluidNative.bindings.fluid_synth_count_effects_groups(instance);
    return result;
  }

  int countMidiChannels() {
    final result =
        FluidNative.bindings.fluid_synth_count_midi_channels(instance);
    return result;
  }

  int getActiveVoiceCount() {
    final result =
        FluidNative.bindings.fluid_synth_get_active_voice_count(instance);
    return result;
  }

  double getGain() {
    final result = FluidNative.bindings.fluid_synth_get_gain(instance);
    return result;
  }

  int getInternalBufferSize() {
    final result =
        FluidNative.bindings.fluid_synth_get_internal_bufsize(instance);
    return result;
  }

  int getPolyphony() {
    final result = FluidNative.bindings.fluid_synth_get_polyphony(instance);
    return result;
  }

  void setGain(double value) {
    FluidNative.bindings.fluid_synth_set_gain(instance, value);
  }

  void setPolyphony(int value) {
    FluidNative.bindings.fluid_synth_set_polyphony(instance, value);
  }

  void setSampleRate(double value) {
    FluidNative.bindings.fluid_synth_set_sample_rate(instance, value);
  }

  /// **************************************************************************
  /// Synthesis Voice Control
  /// **************************************************************************
}
