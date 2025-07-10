import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'key.dart';

enum AudioSampleState { undefined, loading, loaded, error }

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
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _silentMode = false;
  String? _fallbackAssetPath;

  final Map<Octave, AudioSample> samples = {
    Octave.two: const AudioSample.undefined(),
    Octave.three: const AudioSample.undefined(),
    Octave.four: const AudioSample.undefined(),
    Octave.five: const AudioSample.undefined(),
    Octave.six: const AudioSample.undefined(),
  };

  final Set<AudioPlayer> _activePlayers = {};

  Future<void> _initializeAudio() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;

    try {
      final supportedExtensions = ['ogg', 'mp3', 'wav', 'm4a'];
      extension = 'mp3';
      _fallbackAssetPath = null;
      bool foundAnyAudio = false;

      for (String ext in supportedExtensions) {
        for (Octave octave in Octave.values) {
          try {
            final testPath = 'assets/audio/samples_piano_F${octave.value}.$ext';
            final data = await rootBundle.load(testPath);
            if (data.lengthInBytes > 0) {
              extension = ext;
              _fallbackAssetPath = 'audio/samples_piano_F${octave.value}.$ext';
              foundAnyAudio = true;
              break;
            }
          } catch (_) {}
        }
        if (foundAnyAudio) break;
      }

      if (!foundAnyAudio) {
        _silentMode = true;
      }

      await _loadAllSamples();
      _isInitialized = true;
    } catch (e) {
      _silentMode = true;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _loadAllSamples() async {
    final futures = Octave.values.map((octave) => loadSample(octave).catchError((_) {}));
    await Future.wait(futures);

    if (samples.values.where((s) => s.isLoaded).isEmpty) {
      _silentMode = true;
      _fallbackAssetPath = null;
    }
  }

  Future<String> loadSample(Octave octave) async {
    final sample = samples[octave]!;
    if (sample.isUndefined) {
      samples[octave] = const AudioSample.loading();

      try {
        final assetPath = 'audio/samples_piano_F${octave.value}.$extension';
        try {
          final data = await rootBundle.load('assets/$assetPath');
          if (data.lengthInBytes > 0) {
            samples[octave] = AudioSample.loaded(assetPath);
            return assetPath;
          }
        } catch (_) {
          if (_fallbackAssetPath != null && !_silentMode) {
            final fallbackData = await rootBundle.load('assets/$_fallbackAssetPath');
            if (fallbackData.lengthInBytes > 0) {
              samples[octave] = AudioSample.loaded(_fallbackAssetPath!);
              return _fallbackAssetPath!;
            }
          }
        }

        throw Exception('No sample or fallback found.');
      } catch (e) {
        samples[octave] = AudioSample.error('$e');
        return '';
      }
    } else if (sample.isLoading) {
      int attempts = 0;
      while (samples[octave]!.isLoading && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      final updated = samples[octave]!;
      return updated.isLoaded ? updated.assetPath! : '';
    } else if (sample.hasError) {
      return '';
    } else {
      return sample.assetPath!;
    }
  }

  double _calculatePlaybackRate(int key) {
    final fKey = keys[KeyName.f]!;
    return math.pow(2, (key - fKey) / 12).toDouble().clamp(0.5, 2.0);
  }

  Future<void> playSample(String assetPath, int key) async {
    if (assetPath.isEmpty || _silentMode) {
      try {
        HapticFeedback.lightImpact();
      } catch (_) {}
      return;
    }

    try {
      final player = AudioPlayer();
      _activePlayers.add(player);

      final rate = _calculatePlaybackRate(key);
      await player.setPlaybackRate(rate);
      await player.play(AssetSource(assetPath));

      Future.delayed(const Duration(seconds: 2), () async {
        try {
          await player.stop();
          await player.dispose();
        } catch (_) {}
        _activePlayers.remove(player);
      });
    } catch (e) {
      try {
        HapticFeedback.lightImpact();
      } catch (_) {}
    }
  }

  Future<void> play(int key, Octave octave) async {
    if (!_isInitialized && !_isInitializing) {
      await _initializeAudio();
    }

    final assetPath = await loadSample(octave);
    await playSample(assetPath, key);
  }

  Future<void> stopAll() async {
    for (var player in _activePlayers) {
      try {
        await player.stop();
        await player.dispose();
      } catch (_) {}
    }
    _activePlayers.clear();
  }

  void dispose() {
    stopAll();
  }

  Future<void> setVolume(double volume) async {
    for (var player in _activePlayers) {
      try {
        await player.setVolume(volume.clamp(0.0, 1.0));
      } catch (_) {}
    }
  }

  bool isSampleReady(Octave octave) => samples[octave]?.isLoaded ?? false;

  double get loadingProgress {
    int loaded = samples.values.where((s) => s.isLoaded).length;
    return loaded / samples.length;
  }

  bool get isFullyLoaded => samples.values.every((s) => s.isLoaded);

  bool get hasAudioFiles => _fallbackAssetPath != null;

  List<Octave> get availableOctaves => samples.entries
      .where((e) => e.value.isLoaded)
      .map((e) => e.key)
      .toList();
}

final Piano piano = Piano();
