import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'key.dart';

enum AudioSampleState {
  undefined,
  loading,
  loaded,
  error,
}

class AudioSample {
  final AudioSampleState state;
  final String? assetPath;
  final String? errorMessage;

  const AudioSample.undefined()
      : state = AudioSampleState.undefined,
        assetPath = null,
        errorMessage = null;

  const AudioSample.loading()
      : state = AudioSampleState.loading,
        assetPath = null,
        errorMessage = null;

  const AudioSample.loaded(this.assetPath)
      : state = AudioSampleState.loaded,
        errorMessage = null;

  const AudioSample.error(this.errorMessage)
      : state = AudioSampleState.error,
        assetPath = null;

  bool get isUndefined => state == AudioSampleState.undefined;
  bool get isLoading => state == AudioSampleState.loading;
  bool get isLoaded => state == AudioSampleState.loaded;
  bool get hasError => state == AudioSampleState.error;
}

class Piano {
  late String extension;
  late AudioPlayer _audioPlayer;

  final Map<Octave, AudioSample> samples = {
    Octave.two: const AudioSample.undefined(),
    Octave.three: const AudioSample.undefined(),
    Octave.four: const AudioSample.undefined(),
    Octave.five: const AudioSample.undefined(),
    Octave.six: const AudioSample.undefined(),
  };

  Piano() {
    _audioPlayer = AudioPlayer();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    // Determine supported extension based on platform
    // For Flutter, we'll primarily use mp3 or wav
    extension = 'mp3'; // Default to mp3 for better compression

    // Try to determine the best format for the platform
    try {
      // Check if assets exist with different extensions
      await rootBundle.load('assets/audio/samples_piano_F4.mp3');
      extension = 'mp3';
    } catch (e) {
      try {
        await rootBundle.load('assets/audio/samples_piano_F4.wav');
        extension = 'wav';
      } catch (e) {
        try {
          await rootBundle.load('assets/audio/samples_piano_F4.ogg');
          extension = 'ogg';
        } catch (e) {
          extension = 'mp3'; // Fallback
        }
      }
    }

    // Load samples in all octaves
    _loadAllSamples();
  }

  Future<void> _loadAllSamples() async {
    final futures = [
      loadSample(Octave.two),
      loadSample(Octave.three),
      loadSample(Octave.four),
      loadSample(Octave.five),
      loadSample(Octave.six),
    ];

    await Future.wait(futures.map((future) => future.catchError((error) {
      print('Error loading sample: $error');
      return '';
    })));
  }

  Future<String> loadSample(Octave octave) async {
    final sample = samples[octave]!;

    if (sample.isUndefined) {
      samples[octave] = const AudioSample.loading();

      try {
        final assetPath = 'assets/audio/samples_piano_F${octave.value}.$extension';

        // Verify the asset exists
        await rootBundle.load(assetPath);

        samples[octave] = AudioSample.loaded(assetPath);
        return assetPath;
      } catch (e) {
        final errorMessage = 'Failed to load sample for octave ${octave.value}: $e';
        samples[octave] = AudioSample.error(errorMessage);
        throw Exception(errorMessage);
      }
    } else if (sample.isLoading) {
      throw Exception("Duplicate playing action when sample is still loading.");
    } else if (sample.hasError) {
      throw Exception(sample.errorMessage);
    } else {
      return sample.assetPath!;
    }
  }

  Future<void> playSample(String assetPath, int key) async {
    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Calculate playback rate for pitch shifting
      final playbackRate = _calculatePlaybackRate(key);

      // Set playback rate (note: not all platforms support this)
      await _audioPlayer.setPlaybackRate(playbackRate);

      // Play the audio file
      await _audioPlayer.play(AssetSource(assetPath));

      // Auto-stop after 2 seconds (similar to original implementation)
      Future.delayed(const Duration(seconds: 2), () {
        _audioPlayer.stop();
      });

    } catch (e) {
      print('Error playing sample: $e');
      rethrow;
    }
  }

  double _calculatePlaybackRate(int key) {
    // Equivalent to: 2 ** ((key - Keys['F']) / 12)
    final fKey = keys[KeyName.f]!;
    final rate = math.pow(2, (key - fKey) / 12).toDouble();

    // Clamp playback rate to reasonable bounds (0.5x to 2.0x)
    return rate.clamp(0.5, 2.0);
  }

  Future<void> play(int key, Octave octave) async {
    try {
      final assetPath = await loadSample(octave);
      await playSample(assetPath, key);
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // Play a chord (multiple notes)
  Future<void> playChord(List<int> keys, Octave octave) async {
    try {
      for (int key in keys) {
        // Small delay between notes to create a chord effect
        Future.delayed(Duration(milliseconds: keys.indexOf(key) * 50), () {
          play(key, octave);
        });
      }
    } catch (e) {
      print('Error playing chord: $e');
    }
  }

  // Stop all audio
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  // Dispose resources
  void dispose() {
    _audioPlayer.dispose();
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  // Check if a sample is ready to play
  bool isSampleReady(Octave octave) {
    return samples[octave]?.isLoaded ?? false;
  }

  // Get loading progress (returns percentage of samples loaded)
  double get loadingProgress {
    int loadedCount = samples.values.where((sample) => sample.isLoaded).length;
    return loadedCount / samples.length;
  }

  // Check if all samples are loaded
  bool get isFullyLoaded {
    return samples.values.every((sample) => sample.isLoaded);
  }
}

// Global piano instance
final Piano piano = Piano();