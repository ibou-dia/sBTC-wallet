# sBTC Wallet

## Description

sBTC Wallet est une application mobile développée avec Flutter qui permet aux utilisateurs de gérer leur Bitcoin tokenisé (sBTC) sur la blockchain Stacks. Ce portefeuille offre une interface utilisateur moderne et intuitive pour envoyer, recevoir et suivre les transactions sBTC.

## Fonctionnalités

- **Interface utilisateur moderne** : Design épuré et intuitif avec des transitions fluides
- **Gestion de portefeuille** : Création et connexion de portefeuilles sBTC
- **Affichage du solde** : Visualisation du solde en sBTC et dans la devise locale choisie par l'utilisateur
- **Envoi et réception** : Transfert de sBTC vers d'autres adresses
- **Suivi des transactions** : Historique détaillé des transactions
- **Personnalisation** : Choix de la devise locale pour l'affichage des montants
- **Sécurité** : Fonctionnalités de sécurité avancées pour protéger les actifs
- **Onboarding** : Processus d'intégration guidé pour les nouveaux utilisateurs

## Captures d'écran

![Captures d'écran](assets\images\sbtc-wallet.jpg)


## Technologies utilisées

- Flutter/Dart pour le développement cross-platform
- Provider pour la gestion d'état
- Stacks blockchain pour les opérations sBTC
- CoinGecko API pour les taux de change des devises

## Installation

### Prérequis

- Flutter SDK (2.19.0 ou supérieur)
- Dart (3.0.0 ou supérieur)
- Android Studio / Xcode

### Étapes d'installation

1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/ibou-dia/sBTC-wallet.git
   ```

2. Accédez au répertoire du projet :
   ```bash
   cd sbtc_wallet
   ```

3. Installez les dépendances :
   ```bash
   flutter pub get
   ```

4. Lancez l'application :
   ```bash
   flutter run
   ```

## Structure du projet

```
lib/
├── main.dart                # Point d'entrée de l'application
├── screens/                 # Écrans de l'application
│   ├── home_screen.dart     # Écran d'accueil
│   ├── send_screen.dart     # Écran d'envoi de sBTC
│   ├── receive_screen.dart  # Écran de réception de sBTC
│   └── ...
├── services/                # Services métier
│   ├── wallet_service.dart  # Gestion du portefeuille
│   └── ...
├── utils/                   # Utilitaires
└── widgets/                 # Widgets réutilisables
```

## Contribuer

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une pull request ou à signaler des problèmes.

## Licence

Ce projet est sous licence MIT.
