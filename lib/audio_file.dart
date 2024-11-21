import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioFile extends StatefulWidget {
  final  AudioPlayer advancedPlayer;
  const AudioFile({super.key, required this.advancedPlayer});

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  final String path = "https://st.bslmeiyu.com/uploads/%E6%9C%97%E6%96%87%E5%9B%BD%E9%99%85SBS%E7%B3%BB%E5%88%97/"
      "%E6%9C%97%E6%96%87%E5%9B%BD%E9%99%85%E8%8B%B1%E8%AF%AD%E6%95%99%E7%A8%8B%E7%AC%AC2%E5%86%8C"
      "_V2/%E5%AD%A6%E7%94%9F%E7%94%A8%E4%B9%A6/P027_Side%20by%20Side%20Gazette%2001_2Build%20Your%20Vocabulary!.mp3";
  bool isPlaying = false;
  bool isPause = false;
  bool isLoop = false;
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
    this. widget.advancedPlayer.setSource(UrlSource(path));
  }
  Widget btnStart() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 10),
      icon: isPlaying ? Icon(_icon[1], color: Colors.blue, size:50) : Icon(_icon[0], color: Colors.blue, size:50 ),
      onPressed: () async {
        if (isPlaying) {
          await widget.advancedPlayer.pause();
        } else {
          await widget.advancedPlayer.play(UrlSource(path));
        }
        setState(() {
          isPlaying = !isPlaying;
        });
      },
    );
  }
  Widget loadAsset(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          btnStart(),
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
