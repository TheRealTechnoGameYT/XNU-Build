# XNU Build GitHub Actions + Local Helper Files

Ce dépôt contient un **workflow GitHub Actions** et des scripts d'assistance pour tenter de compiler XNU
(le noyau de macOS) sur un runner macOS hébergé par GitHub ou localement.

## Contenu du zip
- `.github/workflows/build-xnu.yml` : workflow GitHub Actions prêt à l'emploi (essaye un miroir Dortania ou utilise `kdk.dmg` présent dans le repo).
- `scripts/build_xnu.sh` : script local pour lancer la compilation (utilise `xnu-src`).
- `scripts/download_kdk_local.sh` : petit utilitaire pour installer un `kdk.dmg` localement dans `/Library/Developer/KDKs`.
- `README.md` (ce fichier)

## Pré-requis (runner / machine)
- macOS runner (GitHub `macos-15` recommandé) ou une machine macOS avec Xcode installé.
- Xcode (version compatible avec la version XNU cible).
- KDK correspondant (Kernel Debug Kit) pour la version XNU que tu veux compiler. Ce KDK contient `migcom`, `iig`, headers et SDKs requis.

## Méthodes pour fournir le KDK au workflow
### Option A — (CONSEILLÉE) Télécharger le KDK officiel depuis Apple Developer et déposer `kdk.dmg` dans la racine du repo
1. Va sur https://developer.apple.com/download/all/ (connexion Apple Developer requise).
2. Télécharge le `Kernel Debug Kit` (.dmg) correspondant à la version de macOS / XNU que tu veux compiler.
3. **Option simple** : Ajoute `kdk.dmg` à la racine de ce repo (commit + push). **Attention** : les KDK sont souvent volumineux — vérifier la limite de taille du repo.
4. Le workflow est écrit pour détecter `kdk.dmg` dans la racine et l'installer automatiquement.

### Option B — Utiliser le miroir Dortania (convenience)
Le workflow tente en premier de récupérer automatiquement un KDK miroir depuis le dépôt `dortania/KdkSupportPkg`.
**Avertissement** : miroir non officiel — utiliser uniquement si tu comprends les risques.

### Option C — Télécharger KDK manuellement et stocker comme release asset
1. Crée une Release sur ton repository GitHub et téléverse `kdk.dmg` comme asset.
2. Modifie le workflow pour récupérer ce release asset (requiert token pour authentifier la requête). Ce mode n'est pas inclus par défaut dans ce template, mais peut être ajouté.

## Utilisation (GitHub)
1. Crée un nouveau repo (ou utilise un fork) et place les fichiers de ce zip à la racine.
2. Si tu choisis Option A, ajoute `kdk.dmg` à la racine (ou Option B laisse le workflow utiliser le miroir).
3. Pousse sur `main` puis va dans l'onglet "Actions" et déclenche le workflow `Build XNU` (ou push sur main).
4. Sur succès, tu trouveras un artifact nommé `xnu-kernel` téléchargeable depuis la page d'exécution du workflow.

## Utilisation (local)
1. Place `kdk.dmg` sur ta machine.
2. Exécute `sudo scripts/download_kdk_local.sh /path/to/kdk.dmg` pour copier le `.kdk` dans `/Library/Developer/KDKs`.
3. Lance `./scripts/build_xnu.sh -a X86_64 -d 23` (ajuste `-d` pour le Darwin major target).

## Notes & Limitations importantes
- Même si tu obtiens un noyau compilé, tu **ne pourras pas** remplacer le noyau d’Apple sur un Mac réel sans la signature Apple (Secure Boot / SIP). Utilise le binaire pour analyses, VM (QEMU), PureDarwin, etc.
- Compiler les toutes dernières versions XNU sur des runners plus anciens peut échouer à cause d'incompatibilités toolchain; si tu veux compiler le "dernier" XNU, préfère `macos-15` (ou machine FRESH).
- Respecte les licences Apple pour l'utilisation des KDK/SDK.
- Les miroirs non officiels (dortania) sont pratiques mais non officiels — vérifie leur intégrité si c'est critique.

## Besoin d'aide ?
Dis‑moi :
- Quelle version XNU tu veux compiler (tag ou Darwin major) ?
- Veux-tu que je personnalise le workflow pour ARM64 (Apple Silicon) ?
- Préfères-tu que j'ajoute un job qui crée un kernel collection (.kextcache) ou une image VM prête à booter ?
