# Prime Pro — starter Flutter

Ce dépôt est un **prototype de départ** pour l'application Android Prime Pro.
Il comprend une interface Flutter sans dépendances externes : accueil FREE/VIP,
historique, profil et écran d'administration de démonstration.

## Important avant publication
- Les données sont uniquement en mémoire : elles disparaissent au redémarrage.
- Le mode administrateur est une démonstration locale, **pas une sécurité réelle**.
- Les abonnements VIP ne sont pas vérifiés par un serveur dans cette version.
- Les notifications sont des messages dans l'application, pas des notifications push.
- Ne publiez pas cette version comme service payant avant d'ajouter backend,
  authentification, règles d'accès, validation des paiements et tests.

## Construire l'APK sans ordinateur (depuis Android)
1. Créez/ouvrez un compte GitHub dans le navigateur du téléphone.
2. Créez un dépôt nommé `prime-pro`.
3. Téléversez les fichiers de cette archive en conservant leur arborescence
   (ou téléversez l'archive et décompressez-la avant l'envoi).
4. Ouvrez l'onglet **Actions** du dépôt et activez GitHub Actions si demandé.
5. Le workflow `Build Android APK` lance Flutter dans le cloud.
6. Une fois terminé, ouvrez l'exécution réussie, descendez à **Artifacts** et
   téléchargez `prime-pro-debug-apk`. Décompressez l'archive téléchargée.
7. Ouvrez le fichier APK sur le téléphone et autorisez l'installation depuis
   cette source si Android le demande.

## Arborescence
- `lib/main.dart` : prototype de l'interface et logique de démonstration.
- `pubspec.yaml` : configuration Flutter.
- `.github/workflows/build-apk.yml` : compilation APK dans GitHub Actions.

## Prochaine étape de production
Connecter Firebase Authentication + Firestore, définir les rôles côté serveur,
sécuriser l'administration et vérifier les abonnements via une fonction serveur.
Ne placez jamais de clé privée, mot de passe ou secret d'administration dans l'APK.
