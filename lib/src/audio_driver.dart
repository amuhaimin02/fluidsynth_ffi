import 'dart:ffi';

import '../fluidsynth_ffi.dart';

class FluidAudioDriver implements Finalizable {
  static final _finalizer = NativeFinalizer(
      FluidNative.bindings.addresses.delete_fluid_audio_driver.cast());

  late final Pointer<fluid_audio_driver_t> instance;

  FluidAudioDriver(FluidSettings settings, FluidSynth synth) {
    instance = FluidNative.bindings
        .new_fluid_audio_driver(settings.instance, synth.instance);
    _finalizer.attach(this, instance.cast());
  }

  void dispose() {
    _finalizer.detach(this);
  }
}
