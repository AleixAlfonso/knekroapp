import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:knekroapp/controllers/ad_state.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  BannerAd? banner3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);

    adState.initialization.then(
      (status) {
        setState(
          () {
            banner3 = BannerAd(
                adUnitId: adState.banner2,
                size: AdSize.banner,
                request: AdRequest(),
                listener: BannerAdListener())
              ..load();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: GridView.count(
              crossAxisCount: 1,
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
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/Miscelanea.png'),
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                        Text('Knekro',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        socialMedia(
                            'https://twitter.com/KNekro',
                            'https://www.youtube.com/user/KNekroGamer',
                            'https://www.twitch.tv/knekro',
                            mediaQuery),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
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
                          'App Creator',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/aleix.png'),
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                        Text('Aleixmen',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        socialMediaAleix(
                            'https://twitter.com/AleixAlfonso',
                            'https://www.twitch.tv/aleiixmen',
                            'https://www.paypal.com/donate?hosted_button_id=UQNC9MVWDQCSA',
                            mediaQuery),
                        SizedBox(
                          height: mediaQuery.size.height * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                    'Reporte de bugs y sugerencias en el twitter del App Creator.')
              ],
            ),
          ),
        ),
        if (banner3 == null)
          SizedBox(
            height: 50,
          )
        else
          Container(
            height: 50,
            child: AdWidget(ad: banner3!),
          )
      ]),
    );
  }

  socialMedia(String urltwitter, String urlyoutube, String urltwitch,
      MediaQueryData mediaQuery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: mediaQuery.size.width * 0.05,
        ),
        IconButton(
            iconSize: mediaQuery.size.height * 0.07,
            onPressed: () async {
              await canLaunch(urltwitter)
                  ? await launch(urltwitter)
                  : throw 'Could not launch $urltwitter';
            },
            icon: Image.asset('assets/TwitterLogo.png')),
        SizedBox(
          width: mediaQuery.size.width * 0.05,
        ),
        IconButton(
          onPressed: () async {
            await canLaunch('https://www.twitch.tv/knekro')
                ? await launch('https://www.twitch.tv/knekro')
                : throw 'Could not launch https://www.twitch.tv/knekro';
          },
          icon: Image.asset('assets/TwitchLogo.png'),
          iconSize: mediaQuery.size.height * 0.07,
        ),
        SizedBox(
          width: mediaQuery.size.width * 0.05,
        ),
        IconButton(
            iconSize: mediaQuery.size.height * 0.07,
            onPressed: () async {
              await canLaunch('https://www.youtube.com/user/KNekroGamer')
                  ? await launch('https://www.youtube.com/user/KNekroGamer')
                  : throw 'Could not launch https://www.youtube.com/user/KNekroGamer';
            },
            icon: Image.asset('assets/YoutubeLogo.png')),
      ],
    );
  }

  socialMediaAleix(String urltwitter, String urltwitch, String utlpaypal,
      MediaQueryData mediaQuery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: mediaQuery.size.width * 0.05,
        ),
        IconButton(
            iconSize: mediaQuery.size.height * 0.07,
            onPressed: () async {
              await canLaunch(urltwitter)
                  ? await launch(urltwitter)
                  : throw 'Could not launch $urltwitter';
            },
            icon: Image.asset('assets/TwitterLogo.png')),
        SizedBox(
          width: mediaQuery.size.width * 0.05,
        ),
        IconButton(
          onPressed: () async {
            await canLaunch(urltwitch)
                ? await launch(urltwitch)
                : throw 'Could not launch $urltwitch';
          },
          icon: Image.asset('assets/TwitchLogo.png'),
          iconSize: mediaQuery.size.height * 0.07,
        ),
        SizedBox(
          width: mediaQuery.size.width * 0.05,
        ),
        IconButton(
          onPressed: () async {
            await canLaunch(utlpaypal)
                ? await launch(utlpaypal)
                : throw 'Could not launch $utlpaypal';
          },
          icon: Image.asset('assets/PayPal.png'),
          iconSize: mediaQuery.size.height * 0.08,
        ),
      ],
    );
  }
}
