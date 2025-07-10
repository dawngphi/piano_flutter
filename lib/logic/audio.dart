import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
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
  String? _fallbackAssetPath;
  bool _isInitialized = false;
  bool _isInitializing = false; // Prevent duplicate initialization
  bool _silentMode = false;

  final Map<Octave, AudioSample> samples = {
    Octave.two: const AudioSample.undefined(),
    Octave.three: const AudioSample.undefined(),
    Octave.four: const AudioSample.undefined(),
    Octave.five: const AudioSample.undefined(),
    Octave.six: const AudioSample.undefined(),
  };

  Piano() {
    _audioPlayer = AudioPlayer();
    // Don't auto-initialize in constructor, let it be lazy-loaded
  }

  Future<void> _initializeAudio() async {
    if (_isInitialized || _isInitializing) return;

    _isInitializing = true;
    print('🎹 Initializing Piano Audio System...');

    try {
      // List of supported extensions in order of preference
      final supportedExtensions = ['mp3', 'wav', 'ogg', 'm4a'];

      extension = 'mp3'; // Default
      _fallbackAssetPath = null;

      // Try to find any available audio file to use as fallback
      bool foundAnyAudio = false;
      for (String ext in supportedExtensions) {
        print('🔍 Checking for .$ext files...');

        for (Octave octave in Octave.values) {
          try {
            final testPath = 'assets/audio/samples_piano_F${octave.value}.$ext';
            final data = await rootBundle.load(testPath);

            // Check if the file actually has content
            if (data.lengthInBytes > 0) {
              extension = ext;
              _fallbackAssetPath = 'audio/samples_piano_F${octave.value}.$ext';
              foundAnyAudio = true;
              print('✅ Found valid audio format: $ext, using: $_fallbackAssetPath (${data.lengthInBytes} bytes)');
              break;
            } else {
              print('⚠️  File exists but is empty: $testPath');
            }
          } catch (e) {
            // File not found, continue to next
            continue;
          }
        }
        if (foundAnyAudio) break;
      }

      if (!foundAnyAudio) {
        print('⚠️  No valid audio files found in assets. Enabling silent mode.');
        print('📁 Expected files in assets/audio/:');
        for (Octave octave in Octave.values) {
          print('   - samples_piano_F${octave.value}.mp3');
        }
        _silentMode = true;
      } else {
        _silentMode = false;
      }

      // Load samples in all octaves
      await _loadAllSamples();

      _isInitialized = true;
      print('🎹 Piano initialization complete. Silent mode: $_silentMode');

    } catch (e) {
      print('❌ Error during piano initialization: $e');
      _silentMode = true;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _loadAllSamples() async {
    print('📦 Loading audio samples...');

    final futures = Octave.values.map((octave) =>
        loadSample(octave).catchError((error) {
          print('❌ Error loading sample for ${octave.name}: $error');
          return '';
        })
    );

    await Future.wait(futures);

    final loadedCount = samples.values.where((s) => s.isLoaded).length;
    print('📦 Loaded $loadedCount/${samples.length} audio samples');

    // If no samples loaded successfully, enable silent mode
    if (loadedCount == 0) {
      print('⚠️  No audio samples loaded successfully. Enabling silent mode.');
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

        // Try to load the specific octave file
        try {
          final data = await rootBundle.load('assets/$assetPath');
          if (data.lengthInBytes > 0) {
            samples[octave] = AudioSample.loaded(assetPath);
            print('✅ Loaded: $assetPath (${data.lengthInBytes} bytes)');
            return assetPath;
          } else {
            throw Exception('File exists but is empty');
          }
        } catch (e) {
          // If specific octave file doesn't exist, try to use fallback
          if (_fallbackAssetPath != null && !_silentMode) {
            try {
              final fallbackData = await rootBundle.load('assets/$_fallbackAssetPath');
              if (fallbackData.lengthInBytes > 0) {
                print('🔄 Using fallback audio for octave ${octave.value}: $_fallbackAssetPath');
                samples[octave] = AudioSample.loaded(_fallbackAssetPath!);
                return _fallbackAssetPath!;
              } else {
                throw Exception('Fallback file is empty');
              }
            } catch (fallbackError) {
              throw Exception('Fallback also failed: $fallbackError');
            }
          } else {
            throw Exception('No audio file available for octave ${octave.value}: $e');
          }
        }
      } catch (e) {
        final errorMessage = 'Failed to load sample for octave ${octave.value}: $e';
        samples[octave] = AudioSample.error(errorMessage);
        print('❌ $errorMessage');
        return '';
      }
    } else if (sample.isLoading) {
      // Wait for loading to complete
      int attempts = 0;
      while (samples[octave]!.isLoading && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      final updatedSample = samples[octave]!;
      if (updatedSample.isLoaded) {
        return updatedSample.assetPath!;
      } else {
        return '';
      }
    } else if (sample.hasError) {
      return ''; // Return empty string for silent mode
    } else {
      return sample.assetPath!;
    }
  }

  Future<void> playSample(String assetPath, int key) async {
    // If no asset path (silent mode), simulate playing
    if (assetPath.isEmpty || _silentMode) {
      print('🔇 Playing in silent mode - key: $key');
      // Provide haptic feedback when in silent mode
      try {
        HapticFeedback.lightImpact();
      } catch (e) {
        // Haptic feedback not available
      }
      return;
    }

    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Calculate playback rate for pitch shifting
      final playbackRate = _calculatePlaybackRate(key);

      // Set playback rate (note: not all platforms support this)
      await _audioPlayer.setPlaybackRate(playbackRate);

      // Play the audio file
      await _audioPlayer.play(AssetSource(assetPath));

      // Auto-stop after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        _audioPlayer.stop();
      });

    } catch (e) {
      print('❌ Error playing sample: $e');
      // Provide haptic feedback as fallback
      try {
        HapticFeedback.lightImpact();
      } catch (e) {
        // Haptic feedback not available
      }
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
    // Ensure initialization before playing
    if (!_isInitialized && !_isInitializing) {
      await _initializeAudio();
    }

    try {
      final assetPath = await loadSample(octave);
      await playSample(assetPath, key);
    } catch (e) {
      print('❌ Error playing audio: $e');
      // Provide haptic feedback as fallback
      try {
        HapticFeedback.lightImpact();
      } catch (e) {
        // Haptic feedback not available
      }
    }
  }

  // Stop all audio
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('❌ Error stopping audio: $e');
    }
  }

  // Dispose resources
  void dispose() {
    try {
      _audioPlayer.dispose();
    } catch (e) {
      print('❌ Error disposing audio player: $e');
    }
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('❌ Error setting volume: $e');
    }
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

  // Check if audio is available
  bool get hasAudioFiles {
    return _fallbackAssetPath != null;
  }

  // Get available octaves with audio
  List<Octave> get availableOctaves {
    return samples.entries
        .where((entry) => entry.value.isLoaded)
        .map((entry) => entry.key)
        .toList();
  }
}

// Global piano instance
final Piano piano = Piano();