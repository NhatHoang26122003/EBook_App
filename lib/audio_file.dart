import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioFile extends StatefulWidget {
  final  AudioPlayer advancedPlayer;
  final String audioPath;
  const AudioFile({super.key, required this.advancedPlayer, required this.audioPath});

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPause = false;
  bool isRepeat = false;
  Color repeatColor = Colors.black;
  List<IconData> _icon = [
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];
  @override
  void initState(){
    super.initState();
    this.widget.advancedPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    this.widget.advancedPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
    this. widget.advancedPlayer.setSource(UrlSource(this.widget.audioPath));
    this.widget.advancedPlayer.onPlayerComplete.listen((event){
      setState(() {
        _position = Duration(seconds: 0);
        if (isRepeat){
          isPlaying = true;
        } else {
          isPlaying = false;
        }
      });
    });
  }
  Widget btnStart() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 10),
      icon: isPlaying ? Icon(_icon[1], color: Colors.blue, size:50) : Icon(_icon[0], color: Colors.blue, size:50 ),
      onPressed: () async {
        if (isPlaying) {
          await widget.advancedPlayer.pause();
        } else {
          await widget.advancedPlayer.setSource(UrlSource(this.widget.audioPath));
          await widget.advancedPlayer.resume();
        }
        setState(() {
          isPlaying = !isPlaying;
        });
      },
    );
  }
  Widget btnFast() {
    return IconButton(
      icon: Image.asset('img/forward.jpg',width: 15, height: 15),
      onPressed: (){
        this.widget.advancedPlayer.setPlaybackRate(1.5);
      },
    );
  }
  Widget btnSlow() {
    return IconButton(
      icon: Image.asset('img/backward.jpg',width: 15, height: 15),
      onPressed: (){
        this.widget.advancedPlayer.setPlaybackRate(0.75);
      },
    );
  }
  Widget btnShuffle() {
    return IconButton(
      icon: Image.asset('img/shuffle.jpg',width: 15, height: 15),
      onPressed: (){
      },
    );
  }
  Widget btnRepeat() {
    return IconButton(
      // icon: Image.asset('img/repeat.jpg',width: 15, height: 15),
      icon: Icon(Icons.repeat, size: 17, color: repeatColor,),
      onPressed: (){
        if (isRepeat){
          this.widget.advancedPlayer.setReleaseMode(ReleaseMode.release);
          setState(() {
            repeatColor = Colors.black;
            isRepeat = !isRepeat;
          });
        } else {
          this.widget.advancedPlayer.setReleaseMode(ReleaseMode.loop);
          setState(() {
            repeatColor = Colors.blue;
            isRepeat = !isRepeat;
          });
        }
      },
    );
  }
  Widget loadAsset(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          btnShuffle(),
          btnSlow(),
          btnStart(),
          btnFast(),
          btnRepeat(),
        ],
      ),
    );
  }
  Widget slider (){
    return Slider(
      activeColor: Colors.red,
      inactiveColor: Colors.grey,
      value: _position.inSeconds.toDouble(),
      min:0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value){
        setState(() {
          changeToSecond(value.toInt());
          value = value;
        });
      },
    );
  }
  void changeToSecond (int second){
    Duration newSecond = Duration(seconds: second);
    this.widget.advancedPlayer.seek(newSecond);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding (
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_position.inMinutes}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                ),
                Text(
                  "${_duration.inMinutes}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                ),
              ],
            ),
          ),
          slider(),
          loadAsset(),
        ],
      ),
    );
  }
}
