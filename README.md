# 🌍 GeoShield - PolyHx-2025

GeoShield est une plateforme de **visualisation des risques environnementaux**, combinant **glissements de terrain, risques d'inondation et cartographie des zones protégées**.  
Elle vise à **prévenir les constructions en zones dangereuses** et à **sensibiliser citoyens et promoteurs immobiliers aux risques naturels**.

<p align="center">
  <img src="assets/geoshield.png" alt="GeoShield Logo" width="300">
</p>


---

## **📌 Sommaire**
- [🔍 Objectifs](#objectifs)
- [🗺️ Fonctionnalités principales](#fonctionnalités-principales)
- [🛠️ Technologies utilisées](#technologies-utilisées)
- [📥 Installation](#installation)

---

## 🔍 Objectifs
GeoShield a pour mission de :
- **Identifier les zones à risque** 📍  
  - Analyse des facteurs **géologiques, hydrologiques et climatiques** influençant les glissements de terrain et inondations.
- **Cartographier et alerter** 🌎  
  - Création de **cartes interactives** indiquant les **zones dangereuses et restrictions de construction**.
- **Sensibiliser le public et les professionnels** ⚠️  
  - Informer les **citoyens, urbanistes et promoteurs immobiliers** sur les **réglementations** et les **mesures de prévention**.

---

## 🗺️ Fonctionnalités principales
✅ **Affichage des zones à risque** sur une carte interactive (**glissements de terrain, inondations, zones protégées**).  
✅ **Système de couches dynamiques** pour activer/désactiver différents types de risques.  
✅ **Recherche intelligente** pour localiser rapidement une zone spécifique.  
✅ **Mise à jour des données en temps réel** via API **ESRI REST & Open Data**.  
✅ **Interface intuitive et adaptative** sur mobile.  

---

## 🛠️ Technologies utilisées
GeoShield repose sur une stack **moderne et performante** :

| Technologie      | Usage |
|-----------------|------------------------------------------------|
| **Flutter**     | Développement de l'application mobile |
| **Dart**        | Langage principal |
| **flutter_map** | Affichage des cartes interactives |
| **OpenStreetMap** | Base cartographique |
| **GeoJSON & ESRI REST API** | Intégration des données de risques |

---

## 📥 Installation
### 🔹 Prérequis
- **Flutter** doit être installé :  
  [📖 Documentation officielle](https://docs.flutter.dev/get-started/install)  

### 🔹 Étapes d’installation
```sh
# Clone du projet
git clone https://github.com/PolyHx-2025/GeoShield.git

# Accéder au dossier
cd GeoShield

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
