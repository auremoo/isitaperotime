> Créé par **Aurélien Moote - Moo - 2026**. Logiciel libre (licence MIT) :
> réutilisable à condition de conserver la mention de l'auteur.

# Is it Apero Time ?

L'app qui te dit quoi boire et quand !

## Fonctionnalites

- **Accueil** : Horloge en temps reel avec recommandation de boisson selon l'heure (Pastis, Ricard, Apero, Vin, Cocktail, Dodo...)
- **Cocktails** : 17 recettes detaillees avec recherche, filtres par ingredient, favoris et cocktail aleatoire
- **Carte des bars** : Carte interactive OpenStreetMap avec les bars a proximite (API Overpass + fallback JSON France)
- **Jeux d'alcool** : 5 jeux interactifs (Je n'ai jamais, Jeu du Roi, Action ou Verite, Piccolo, Flip Cup)
- **Mode sombre** : Theme light/dark avec persistance
- **Contact** : Envoi d'email au developpeur

## Stack technique

- **Flutter 3** / Dart 3.8+
- **Riverpod** pour le state management
- **GoRouter** avec ShellRoute pour la navigation
- **FlutterMap v7** + marker clustering pour la carte
- **json_serializable** pour les modeles de donnees
- **SharedPreferences** pour la persistance locale
- **Material 3** avec palette chaleureuse ambree

## Structure du projet

```
lib/
├── main.dart & app.dart          # Entry points
├── core/                         # Constants, theme, router, widgets partages
├── data/
│   ├── models/                   # Cocktail, Bar, DrinkingGame (immutables)
│   ├── repositories/             # Acces aux donnees (cache, API, JSON)
│   └── services/                 # Asset, Location, Overpass, Email
└── features/                     # Home, Cocktails, Map, Games, Settings, Contact
```

## Lancer le projet

```bash
flutter pub get
dart run build_runner build
flutter run
```

## Tests

```bash
flutter test
```

25 tests unitaires couvrant les utilitaires, modeles et serialisation JSON.

## Credits

Aurelien Moote - 2022-2026

Inspire par [estcequecestbientotlapero.fr](https://estcequecestbientotlapero.fr/)

Donnees bars : OpenStreetMap / Overpass API

---

> L'abus d'alcool est dangereux pour la sante. A consommer avec moderation.

## Auteur & licence

**Aurélien Moote - Moo - 2026**
Copyright (c) 2026 Aurélien Moote ("Moo")
Licence MIT — réutilisable à condition de conserver la mention de l'auteur.
Voir le fichier [LICENSE](./LICENSE) pour le texte complet.
