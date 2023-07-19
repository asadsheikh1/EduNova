import 'dart:async';

import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_database/firebase_database.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Map<dynamic, dynamic> playlist;
  const VideoPlayerWidget({Key? key, required this.playlist}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  Timer? _timer;
  late List<VideoPlayerController> _controllers = [];
  int _currentVideoIndex = 0;
  bool _isPlaying = true;
  bool _isMuted = false;
  Duration _currentTime = Duration.zero;
  double _sliderValue = 0.0;
  bool _showControls = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initVideoPlayers();
  }

  Future<void> _initVideoPlayers() async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    final DatabaseEvent databaseEvent = await databaseReference.child('course').child(widget.playlist['time']).child('videoUrl').once();
    final DataSnapshot dataSnapshot = databaseEvent.snapshot;
    final List<dynamic> videoUrls = dataSnapshot.value as List<dynamic>;

    _controllers = await Future.wait(
      videoUrls.map((videoUrl) async {
        final controller = VideoPlayerController.network(videoUrl.toString());
        await controller.initialize();
        return controller;
      }),
    );

    setState(() {
      _currentVideoIndex = 0;
      _controllers[_currentVideoIndex].play(); // Play the initial video

      // Start the timer to update the current time
      _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        if (mounted) {
          setState(() {
            _currentTime = _controllers[_currentVideoIndex].value.position;
            _sliderValue = _currentTime.inSeconds.toDouble();
          });
        }
      });
    });
  }

  void _playNextVideo() {
    _controllers[_currentVideoIndex].pause(); // Pause the current video
    setState(() {
      _currentVideoIndex = (_currentVideoIndex + 1) % _controllers.length;
      _controllers[_currentVideoIndex].play(); // Play the next video
      _isPlaying = true; // Reset the play/pause button state
      _currentTime = Duration.zero; // Reset the current time
      _sliderValue = 0.0; // Reset the slider value
    });
  }

  void _playPreviousVideo() {
    _controllers[_currentVideoIndex].pause(); // Pause the current video
    setState(() {
      _currentVideoIndex = (_currentVideoIndex - 1 + _controllers.length) % _controllers.length;
      _controllers[_currentVideoIndex].play(); // Play the previous video
      _isPlaying = true; // Reset the play/pause button state
      _currentTime = Duration.zero; // Reset the current time
      _sliderValue = 0.0; // Reset the slider value
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controllers[_currentVideoIndex].play();
      } else {
        _controllers[_currentVideoIndex].pause();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controllers[_currentVideoIndex].setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _seekTo(double value) {
    final newPosition = Duration(seconds: value.toInt());
    _controllers[_currentVideoIndex].seekTo(newPosition);
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controllers.isNotEmpty
        ? Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showControls = !_showControls;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controllers[_currentVideoIndex].value.aspectRatio,
                      child: VideoPlayer(_controllers[_currentVideoIndex]),
                    ),
                    Positioned.fill(
                      child: AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                iconSize: 64,
                                icon: _isPlaying ? Icon(Icons.pause, color: kMainSwatchColor) : Icon(Icons.play_arrow, color: kMainSwatchColor),
                                onPressed: _togglePlayPause,
                              ),
                              Positioned(
                                left: 16.0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.skip_previous,
                                    color: kMainSwatchColor,
                                  ),
                                  onPressed: _playPreviousVideo,
                                ),
                              ),
                              Positioned(
                                right: 16.0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.skip_next,
                                    color: kMainSwatchColor,
                                  ),
                                  onPressed: _playNextVideo,
                                ),
                              ),
                              Positioned(
                                bottom: 16.0,
                                left: 16.0,
                                child: IconButton(
                                  icon: _isMuted ? Icon(Icons.volume_off, color: kMainSwatchColor) : Icon(Icons.volume_up, color: kMainSwatchColor),
                                  onPressed: _toggleMute,
                                ),
                              ),
                              Positioned(
                                bottom: 16.0,
                                right: 16.0,
                                child: IconButton(
                                  icon: _isFullScreen ? Icon(Icons.fullscreen_exit, color: kMainSwatchColor) : Icon(Icons.fullscreen, color: kMainSwatchColor),
                                  onPressed: _toggleFullScreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Slider(
                      value: _sliderValue,
                      min: 0.0,
                      max: _controllers[_currentVideoIndex].value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                          _seekTo(value);
                        });
                      },
                    ),
                  ),
                  Text(
                    '${_formatDuration(_currentTime)} / ${_formatDuration(_controllers[_currentVideoIndex].value.duration)}',
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator.adaptive());
  }
}
