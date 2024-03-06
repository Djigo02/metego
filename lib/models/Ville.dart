class Ville{
  late String nom;
  late double temperature;
  late String couverture;
  String ? humidite;

  Ville({required this.nom, required this.couverture, required this.temperature, this.humidite});
}