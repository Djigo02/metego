import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mete_go/services/weather_service.dart';
import 'dart:async';

import '../models/Ville.dart';
import '../models/config.dart';
import '../screens/second_screen.dart';

class WaitingMessage extends StatefulWidget {
  WaitingMessage({key}) : super(key: key);

  @override
  State<WaitingMessage> createState() => _WaitingMessageState();
}

class _WaitingMessageState extends State<WaitingMessage> {
  bool isFinish = false;
  List<Ville> ListeVille = [
    Ville(nom: 'Dakar', couverture: 'Ensoileille', temperature: 30),
    Ville(nom: 'Paris', couverture: 'Nuageux', temperature: 20),
    Ville(nom: 'Thies', couverture: 'Ensoileille', temperature: 33),
    Ville(nom: 'Londres', couverture: 'Nuageux', temperature: 10),
    Ville(nom: 'Quebec', couverture: 'Ensoileille', temperature: 0),
    Ville(nom: 'Marseille', couverture: 'Nuageux', temperature: 32),
  ];

  // Liste des villes dont leur meteo ete affiche
  late List<Ville> MeteoVilles = [];
  late Map<String, dynamic> meteoData = {};

  late Ville ville = ListeVille[0];
  int counter = 0;
  int index = 0;
  String message = 'Démmarage ...';
  // Timer pour le message
  late Timer _timer;
  // Timer pour la progression de la barre
  late Timer _timerProgress;
  // Compte les seconde passer
  double counterProgress = 0;
  // pourcentage de progression
  double progressBar = 0;
  // largeur de la barre de progression
  double widthProgress = 0;

  bool isLoading = true; // Suivre si les données sont en cours de chargement ou non

  @override
  void initState() {
    super.initState();
    var meteo = new Meteo();
    meteo.fetchWeatherData('abidjan').then((data) {
      setState(() {
        meteoData = data;
        MeteoVilles.add(Ville(nom: meteoData['name'],
            couverture: meteoData['weather']['description'],
            temperature: meteoData['main']['temp'],
            humidite: meteoData['main']['humidity']
        ));
        isLoading = false; // Mettez isLoading à false lorsque les données sont chargées avec succès
      });
    }).catchError((error) {
      print('Erreur lors du chargement de l\'api: $error');
    });
    _startTimer();
    _startTimerProgress();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerProgress.cancel();
    super.dispose();
  }

  // Timer pour les messages d'attentes
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      setState(() {
        counter += 6;
        index = index > 2 ? 0 : index;
        message = [
          'Nous téléchargeons les données...',
          'C\'est presque fini...',
          'Plus que quelques secondes avant d’avoir le résultat...'
        ][index];
        index++;

        if (counter >= 60) {
          timer.cancel();
        }
      });
    });
  }

  // Timer pour la barre de progression
  void _startTimerProgress(){
    _timerProgress = Timer.periodic(Duration(seconds: 10), (timer) {
      if (!isLoading) { // Vérifiez si les données sont chargées
        setState(() {
          var meteo = new Meteo();
          meteo.fetchWeatherData(ville.nom).then((data) {
            setState(() {
              meteoData = data;
              if(counterProgress>50)
                isFinish = true;
              print(meteoData);
            });
          }).catchError((error) {
            print('Erreur lors du chargement de l\'api: $error');
          });
          // tous les 10s il s'icremente de 10
          counterProgress+=10;
          // tous les 10s la valeur en pourcentage
          progressBar+=16.6;
          // tous les 10s la largeur de la barre de progression
          widthProgress+= 50;
          // Ville a afficher
          int i = (counterProgress/10).toInt();
          ville = ListeVille[i];
          print(counterProgress);
          if (counterProgress >= 60) {
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(!isFinish)
            // Box pour afficher la meteo de la ville
            Container(
            height: 350,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(backScafoldColor),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                // Nom de la ville
                Text(
                  // ville.nom,
                  "${meteoData?['name'] ?? 'Chargement...'}",
                  // "${meteoData['name']}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: family,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20,),
                // Afficher la couverture avec une animation
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Lottie.asset("assets/lotties/ensoleille.json"),
                ),
              const SizedBox(height: 20,),
              //   Temperature
                Text(
                  meteoData != null && meteoData.containsKey("main") ? '${meteoData["main"]["temp"]} °C' : "Loading...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: family,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10,),
              //   Couverture
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.sunny,
                      color: Colors.yellow,
                      size: 30,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      ville.couverture,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: family,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                //Humidite
                Text(
                  meteoData != null && meteoData.containsKey("main") ? 'humidité: ${meteoData["main"]["humidity"]} %' : "...",
                  // 'humidité: ${meteoData['main']['humidity'] ?? '...'} %',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: family,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

              //   Fin
              ],
            ),

          ),
            // Fin du box
          if(isFinish)
            Container(
              height: 300,
              width: 300,
              color: Colors.deepOrange,
            ),
          const SizedBox(height: 50,),
          // -----------------------------------------------------
          // Pendant le chargemment
          if(!isFinish)
            // Message d'attente
            Text(message),
          if(!isFinish)
            // Barre de progression
            Container(
              width: progress_bar_width,
              height: progress_bar_height,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10)
              ),
              child:
                Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: widthProgress,
                    height: progress_bar_height,
                    decoration: BoxDecoration(
                        color: const Color(backScafoldColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 250),
                    child: Text(
                      '${progressBar.ceil()}%',
                        style: const TextStyle(
                            color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          // -----------------------------------------------------
          // Apres chargemment afficher le bouton recommencer
          if(isFinish)
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffffffff)),
                  minimumSize: MaterialStateProperty.all<Size>(Size(250, 50))
              ),
              onPressed: (){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(
                      builder: (context)=>const SecondScreen(),
                    )
                );
              },
              child: const Text(
                'Recommencer',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ButtonFontSize,
                    fontFamily: family
                ),
              ),
            ),
        ],
      ),
    );
  }
}
