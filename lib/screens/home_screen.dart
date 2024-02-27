import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mete_go/models/config.dart';
import 'package:mete_go/screens/second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(backScafoldColor),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 100,),
            /*
            * Image animee de nuage qui passe
            */
            Padding(
              padding: const EdgeInsets.all(40),
              child: Lottie.asset("assets/lotties/nuage.json",),
            ),
            /*
            * Phrase de bienvenue
            */
            const Text(phrase_de_bienvenue,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: titleSize,
                fontFamily: family,
                fontWeight: FontWeight.bold
              ),
            ),
            /*
            * Espace entre le texte et le bouton
            */
            const SizedBox(height: 30,),
            /*
            * Bouton Commencer
            */
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffffffff)),
                minimumSize: MaterialStateProperty.all<Size>(Size(250, 50))
              ),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context)=>const SecondScreen(),
                    )
                );
              },
              child: const Text(
                'Commencer',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: ButtonFontSize,
                  fontFamily: family
                ),
              ),
            ),
          ],
        )
    );
  }
}
