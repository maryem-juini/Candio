# Nouvelles Fonctionnalités HR - Candio

## Vue d'ensemble

Ce document décrit les nouvelles fonctionnalités ajoutées à l'interface utilisateur du rôle HR (Ressources Humaines) dans l'application Candio.

## Fonctionnalités Principales

### 1. Gestion des Postes (`HRJobPostsScreen`)

**Localisation :** `lib/presentation/views/hr/hr_job_posts_screen.dart`

**Fonctionnalités :**

- ✅ **Publier un nouveau poste** : Formulaire complet avec tous les champs nécessaires
- ✅ **Modifier un poste existant** : Édition des informations du poste
- ✅ **Activer/Désactiver un poste** : Basculement du statut actif/inactif
- ✅ **Supprimer un poste** : Suppression avec confirmation
- ✅ **Voir les détails** : Affichage complet des informations du poste
- ✅ **Gérer les candidatures** : Accès direct aux candidatures pour chaque poste

**Champs du formulaire avancés :**

**Section 1: Informations de base**

- Titre du poste \* (avec exemples)
- Référence du poste (optionnel)
- Localisation \* (avec exemples)
- Type de contrat \* (CDI, CDD, Stage, Alternance, Freelance, Intérim)

**Section 2: Détails du poste**

- Description détaillée \* (5 lignes)
- Profil recherché (avec exemples)

**Section 3: Exigences et compétences**

- Compétences techniques (Flutter, Dart, Firebase...)
- Compétences soft skills (Communication, travail d'équipe...)
- Formation requise
- Expérience minimum

**Section 4: Conditions et rémunération**

- Fourchette salariale (avec exemples)
- Niveau d'expérience (Junior, Intermédiaire, Senior, Expert)
- Avantages sociaux (Mutuelle, tickets restaurant, CE...)
- Modalités de travail (Télétravail, hybride, présentiel)

**Section 5: Planning et dates**

- Date de début souhaitée
- Date limite de candidature \*
- Durée du contrat
- Urgence du recrutement (Faible, Moyenne, Élevée, Urgente)

**Section 6: Informations supplémentaires**

- Processus de recrutement
- Notes internes (optionnel, non visibles des candidats)

### 2. Gestion Avancée des Candidatures (`HRApplicationsManagementScreen`)

**Localisation :** `lib/presentation/views/hr/hr_applications_management_screen.dart`

**Fonctionnalités :**

- ✅ **Filtrage par statut** : Toutes, En attente, Acceptées, Rejetées
- ✅ **Voir les détails des candidats** : Profil complet avec informations de contact
- ✅ **Accepter/Rejeter les candidatures** : Actions directes sur les candidatures en attente
- ✅ **Gestion des statuts** : Suivi des candidatures acceptées/rejetées
- ✅ **Actions rapides** : Télécharger CV, Contacter, Planifier entretien
- ✅ **Informations détaillées** : Date de candidature, statut, poste associé

**Statuts des candidatures :**

- 🟠 **En attente** : Candidature en cours d'évaluation
- 🟢 **Acceptée** : Candidature validée par les RH
- 🔴 **Rejetée** : Candidature refusée

### 3. Navigation Mise à Jour

**Localisation :** `lib/presentation/views/hr/hr_main_screen.dart`

**Nouveaux onglets :**

1. **Dashboard** : Vue d'ensemble et statistiques
2. **Mes Postes** : Gestion des offres d'emploi
3. **Candidatures** : Gestion avancée des candidatures
4. **Profile** : Profil personnel du RH

## Architecture Technique

### Contrôleur HR (`HRController`)

**Nouvelles propriétés :**

```dart
// Filter for applications
final RxString selectedFilter = 'all'.obs;
```

**Méthodes existantes utilisées :**

- `createJobOffer()` : Création de nouveaux postes
- `updateJobOffer()` : Mise à jour des postes existants
- `deleteJobOffer()` : Suppression des postes
- `updateApplicationStatus()` : Gestion des statuts de candidature

### Entités Utilisées

**JobOfferEntity :**

- Gestion complète des offres d'emploi
- Statut actif/inactif
- Informations détaillées (titre, localisation, contrat, etc.)

**ApplicationEntity :**

- Statuts : pending, accepted, rejected
- Informations du candidat
- Lien avec l'offre d'emploi

## Utilisation

### Pour les RH

1. **Publier un poste :**

   - Aller dans l'onglet "Mes Postes"
   - Cliquer sur le bouton "+" en haut à droite
   - Remplir le formulaire et valider

2. **Gérer les candidatures :**

   - Aller dans l'onglet "Candidatures"
   - Utiliser les filtres pour trier par statut
   - Accepter/rejeter les candidatures en attente
   - Voir les détails des candidats

3. **Modifier un poste :**
   - Dans "Mes Postes", utiliser le menu "..." sur chaque poste
   - Sélectionner "Modifier"
   - Apporter les changements nécessaires

### Interface Utilisateur

- **Design moderne** : Interface Material Design avec thème personnalisé
- **Responsive** : Adaptation aux différentes tailles d'écran
- **Intuitif** : Navigation claire et actions visibles
- **Feedback** : Notifications de succès/erreur pour toutes les actions

## Sécurité et Validation

- **Validation des formulaires** : Vérification des champs obligatoires
- **Confirmation des actions** : Dialogs de confirmation pour les actions critiques
- **Gestion des erreurs** : Traitement gracieux des erreurs avec messages utilisateur
- **Permissions** : Accès restreint aux fonctionnalités RH

## Extensibilité

Les nouvelles fonctionnalités sont conçues pour être facilement extensibles :

- **Nouveaux statuts** : Ajout facile de nouveaux statuts de candidature
- **Actions supplémentaires** : Intégration de nouvelles actions (planification d'entretien, etc.)
- **Filtres avancés** : Possibilité d'ajouter des filtres supplémentaires
- **Notifications** : Intégration future de notifications push/email

## Tests et Qualité

- **Code propre** : Respect des conventions Flutter/Dart
- **Gestion d'état** : Utilisation de GetX pour la gestion réactive
- **Performance** : Chargement optimisé des données
- **Maintenabilité** : Code modulaire et bien structuré

## Support et Maintenance

Pour toute question ou problème avec ces nouvelles fonctionnalités :

1. Vérifier la console pour les erreurs
2. Consulter les logs de l'application
3. Vérifier la connectivité Firebase
4. Contacter l'équipe de développement

---

**Version :** 1.0.0  
**Date :** Décembre 2024  
**Auteur :** Équipe Candio
