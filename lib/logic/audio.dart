import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'key.dart';

enum AudioSampleState {
  undefined,
  loading,
  loaded,
}

class AudioBuffer {
  final Uint8List bytes;
  const AudioBuffer(this.bytes);
}

class AudioSample {
  final AudioSampleState state;
  final AudioBuffer? buffer;

  const AudioSample.undefined()
      : state = AudioSampleState.undefined,
        buffer = null;

  const AudioSample.loading()
      : state = AudioSampleState.loading,
        buffer = null;

  const AudioSample.loaded(this.buffer)
      : state = AudioSampleState.loaded;
}

class Piano {
  final int poolSize = 8;
  final List<AudioPlayer> _playerPool = [];
  int _poolIndex = 0;
  final String extension = 'mp3';

  final Map<Octave, AudioSample> samples = {
    Octave.two: const AudioSample.undefined(),
    Octave.three: const AudioSample.undefined(),
    Octave.four: const AudioSample.undefined(),
    Octave.five: const AudioSample.undefined(),
    Octave.six: const AudioSample.undefined(),
  };

  Piano() {
    for (int i = 0; i < poolSize; i++) {
      _playerPool.add(AudioPlayer());
    }
    _preloadSamples();
  }

  Future<void> _preloadSamples() async {
    await Future.wait([
      loadSample(Octave.two),
      loadSample(Octave.three),
      loadSample(Octave.four),
      loadSample(Octave.five),
      loadSample(Octave.six),
    ]);
  }

  Future<AudioBuffer> loadSample(Octave octave) async {
    final current = samples[octave];

    if (current == null || current.state == AudioSampleState.undefined) {
      samples[octave] = const AudioSample.loading();

      try {
        final path = 'assets/audio/samples_piano_F${octave.value}.$extension';
        final data = await rootBundle.load(path);

        if (data.lengthInBytes == 0) {
          throw Exception('Audio file is empty: $path');
        }

        final buffer = AudioBuffer(data.buffer.asUint8List());
        samples[octave] = AudioSample.loaded(buffer);
        return buffer;
      } catch (e) {
        samples[octave] = const AudioSample.undefined();
        throw Exception('Cannot load sample for octave ${octave.value}: $e');
      }

    } else if (current.state == AudioSampleState.loading) {
      throw Exception("Sample is still loading.");
    } else if (current.state == AudioSampleState.loaded && current.buffer != null) {
      return current.buffer!;
    } else {
      throw Exception("Sample is in unexpected state: ${current.state}");
    }
  }

  Future<void> play(int keyInOctave, Octave octave) async {
    try {
      final sample = await loadSample(octave);
      await playSample(sample, keyInOctave, octave);
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  Future<void> playSample(AudioBuffer sample, int keyInOctave, Octave octave) async {
    final baseKeyInOctave = keys[KeyName.f]!;
    final playbackRate = pow(2, (keyInOctave - baseKeyInOctave) / 12).toDouble();
    final clampedPlaybackRate = playbackRate.clamp(0.1, 4.0);

    // Lấy player tiếp theo trong pool
    final player = _playerPool[_poolIndex];
    _poolIndex = (_poolIndex + 1) % poolSize;

    try {
      await player.stop();
      await player.setPlaybackRate(clampedPlaybackRate);
      await player.play(BytesSource(sample.bytes));
    } catch (e) {
      print("Error playing sample: $e");
    }
  }

  void dispose() {
    for (var player in _playerPool) {
      player.dispose();
    }
  }
}

final piano = Piano();