import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import '../models/Ville.dart';
import '../models/config.dart';

class WaitingMessage extends StatefulWidget {
  WaitingMessage({key}) : super(key: key);

  @override
  State<WaitingMessage> createState() => _WaitingMessageState();
}

class _WaitingMessageState extends State<WaitingMessage> {
  List<Ville> ListeVille = [
    Ville(nom: 'Dakar', couverture: 'Ensoileille', temperature: 30),
    Ville(nom: 'Paris', couverture: 'Nuageux', temperature: 20),
    Ville(nom: 'Thies', couverture: 'Ensoileille', temperature: 33),
    Ville(nom: 'Londres', couverture: 'Nuageux', temperature: 10),
    Ville(nom: 'Quebec', couverture: 'Ensoileille', temperature: 0),
    Ville(nom: 'Marseille', couverture: 'Nuageux', temperature: 32),
  ];
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


  @override
  void initState() {
    super.initState();
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

        if (counter == 60) {
          timer.cancel();
        }
      });
    });
  }

  // Timer pour la barre de progression
  void _startTimerProgress(){
    _timerProgress = Timer.periodic(Duration(seconds: 10), (timer) {
    // Toutes les 10s la barre de progession avance
    setState(() {
    // tous les 10s il s'icremente de 10
    counterProgress+=10;
    // tous les 10s la valeur en pourcentage
    progressBar+=16.6;
    // tous les 10s la largeur de la barre de progression
    widthProgress+= 50;
    // Ville a afficher
    int i = (counterProgress/10).toInt();
    ville = ListeVille[i];
    if (counterProgress >= 60) {
    timer.cancel();
  }
  });
  });
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                  "${ville.nom}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: family,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
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
                  '${ville.temperature} °C',
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
                    Icon(
                      Icons.sunny,
                      color: Colors.yellow,
                      size: 30,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      '${ville.couverture}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: family,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

              //   Fin
              ],
            ),

          ),
          // Fin du box
          const SizedBox(height: 50,),
          // Message d'attente
          Text(message),
          // Barre de progression
          Container(
            width: progress_bar_width,
            height: progress_bar_height,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Stack(
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
          )
        ],
      ),
    );
  }
}
