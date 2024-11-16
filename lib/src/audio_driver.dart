import 'dart:ffi';

import '../fluidsynth_ffi.dart';

class FluidAudioDriver {
  late final Pointer<fluid_audio_driver_t> instance;

  FluidAudioDriver(FluidSettings settings, FluidSynth synth) {
    instance = FluidNative.bindings
        .new_fluid_audio_driver(settings.instance, synth.instance);
  }

  void dispose() {
    FluidNative.bindings.delete_fluid_audio_driver(instance);
  }
}
