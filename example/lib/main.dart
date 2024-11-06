import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:fluidsynth_ffi/fluidsynth_ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

typedef NativeMidiCallback = Void Function(Pointer<Void>, Pointer);

class _MyAppState extends State<MyApp> {
  late FluidSynth _synth;
  late FluidSettings _settings;
  late FluidAudioDriver _audioDriver;
  late FluidPlayer _player;

  bool _isPlaying = false;
  int _tick = 0;
  FluidMidiEvent? _lastEvent;

  void _startSynth() async {
    final storageDir = await getApplicationSupportDirectory();
    final soundFontFile = File('${storageDir.path}/soundfont.sf2');
    soundFontFile.writeAsBytesSync(
        (await rootBundle.load('assets/TimGM6mb.sf2')).buffer.asUint8List());
    final midiFile = File('${storageDir.path}/ballade.mid');
    midiFile.writeAsBytesSync(
        (await rootBundle.load('assets/ballade.mid')).buffer.asUint8List());

    _settings = FluidSettings();
    _synth = FluidSynth(_settings);

    final soundfontId =
        _synth.loadSoundfont(soundFontFile, resetPresets: false);

    _audioDriver = FluidAudioDriver(_settings, _synth);
    _player = FluidPlayer(_synth);

    _player.add(midiFile);

    _synth.programChange(channel: 0, program: 0);
    _synth.bankSelect(channel: 0, bank: 0);
    _synth.gain = 1;

    _player.tickCallback = ((tick) {
      setState(() {
        _tick = tick;
      });
    });

    _player.playbackCallback = ((event) {
      _synth.handleMidiEvent(event);
      setState(() {
        _lastEvent = event;
      });
    });

    _player.play();

    setState(() {
      _isPlaying = true;
    });
  }

  void _stopSynth() {
    _player.stop();
    _player.dispose();
    _audioDriver.dispose();
    _synth.dispose();

    _settings.dispose();

    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tick: $_tick'),
              Builder(
                builder: (context) {
                  final event = _lastEvent;
                  if (event != null) {
                    return Text(
                        'Event: T:${event.type} C:${event.control} K:${event.key} V:${event.velocity}');
                  } else {
                    return const Text('---');
                  }
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (_isPlaying) {
                    _stopSynth();
                  } else {
                    _startSynth();
                  }
                },
                child: _isPlaying
                    ? const Text("Stop FluidSynth")
                    : const Text('Start FluidSynth'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
