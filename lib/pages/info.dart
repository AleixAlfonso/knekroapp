import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: GridView.count(             crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0XFF8789C0),
                          Color(0XFF45F0DF),
                          Color(0XFFC2CAE8),
                          Color(0XFF8380B6),
                          Color(0XFF111D4A),
                        ],
                        stops: [
                          0.20,
                          0.40,
                          0.60,
                          0.80,
                          1
                        ]),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Streamer',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/Miscelanea.png'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Knekro', style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 10,
                      ),
                      socialMedia(
                          'https://twitter.com/KNekro',
                          'https://www.youtube.com/user/KNekroGamer',
                          'https://www.twitch.tv/knekro'),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Text(
                        'Streamer',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/Miscelanea.png'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Knekro', style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 10,
                      ),
                      socialMedia(
                          'https://twitter.com/KNekro',
                          'https://www.youtube.com/user/KNekroGamer',
                          'https://www.twitch.tv/knekro'),
                    ],
                  ),
                ),
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(20),
              //   child: Container(
              //     color: Colors.grey,
              //     child: Column(
              //       children: [
              //         Text(
              //           'Programador',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         CircleAvatar(
              //           radius: 30,
              //           backgroundImage: AssetImage('assets/aleix.png'),
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         Text('Aleixmen', style: TextStyle(color: Colors.white)),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         socialMediaAleix('https://twitter.com/KNekro',
              //             'https://www.twitch.tv/knekro'),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  socialMedia(String urltwitter, String urlyoutube, String urltwitch) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () async {
              await canLaunch(urltwitter)
                  ? await launch(urltwitter)
                  : throw 'Could not launch $urltwitter';
            },
            icon: Image.asset('assets/TwitterLogo.png')),
        SizedBox(
          width: 5,
        ),
        IconButton(
          onPressed: () async {
            await canLaunch('https://www.twitch.tv/knekro')
                ? await launch('https://www.twitch.tv/knekro')
                : throw 'Could not launch https://www.twitch.tv/knekro';
          },
          icon: Image.asset('assets/TwitchLogo.png'),
          iconSize: 30,
        ),
        SizedBox(
          width: 5,
        ),
        IconButton(
            onPressed: () async {
              await canLaunch('https://www.youtube.com/user/KNekroGamer')
                  ? await launch('https://www.youtube.com/user/KNekroGamer')
                  : throw 'Could not launch https://www.youtube.com/user/KNekroGamer';
            },
            icon: Image.asset('assets/YoutubeLogo.png')),
      ],
    );
  }

  socialMediaAleix(String urltwitter, String urltwitch) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () async {
              await canLaunch(urltwitter)
                  ? await launch(urltwitter)
                  : throw 'Could not launch $urltwitter';
            },
            icon: Image.asset('assets/TwitterLogo.png')),
        SizedBox(
          width: 5,
        ),
        IconButton(
          onPressed: () async {
            await canLaunch('https://www.twitch.tv/knekro')
                ? await launch('https://www.twitch.tv/knekro')
                : throw 'Could not launch https://www.twitch.tv/knekro';
          },
          icon: Image.asset('assets/TwitchLogo.png'),
          iconSize: 30,
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
