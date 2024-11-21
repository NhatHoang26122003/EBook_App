import 'package:audioplayers/audioplayers.dart';
import 'package:ebook_app/audio_file.dart';
import 'package:flutter/material.dart';
import 'package:ebook_app/app_colors.dart' as AppColors;

class DetailAudioPage extends StatefulWidget {
  const DetailAudioPage({super.key});

  @override
  State<DetailAudioPage> createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {
  late AudioPlayer advancedPlayer;

  @override
  void initState(){
    super.initState();
    advancedPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    advancedPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold (
      backgroundColor: AppColors.audioBluishBackground,
      body: Stack (
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: screenHeight/3,
            child: Container(
              color: AppColors.audioBlueBackground,
            ),
          ),
          Positioned(
            top:0,
            left:0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){},
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: (){},
                ),
              ],
              elevation: 0.0,
            )
          ),
          Positioned(
            left: 0,
            right: 0,
            top: screenHeight/5,
            height: screenHeight*0.36,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight*0.1,),
                  const Text (
                    "THE WATER CURE",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Avenir",
                    )
                  ),
                  const Text (
                    "Martin Hyatt",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  AudioFile (advancedPlayer: advancedPlayer),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight*0.12,
            left: (screenWidth - 130)/2,
            right: (screenWidth - 130)/2,
            height: screenHeight*0.16,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.lightGreen, width: 2),
                color: AppColors.audioGreyBackground,
              ),
              child: Padding (
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                    image: DecorationImage(
                      image: AssetImage("img/pic-2.jpg"),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
