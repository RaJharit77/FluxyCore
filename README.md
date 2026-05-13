<!-- README.md -->
<p align="center">
  <img src="https://www.ruby-lang.org/images/logo-ruby.svg" width="80" alt="Ruby logo"/>
  <img src="https://crystal-lang.org/images/logo.svg" width="80" alt="Crystal logo"/>
</p>

<h1 align="center">FluxyCore</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white" alt="Ruby"/>
  <img src="https://img.shields.io/badge/Crystal-000000?style=for-the-badge&logo=crystal&logoColor=white" alt="Crystal"/>
  <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge" alt="License MIT"/>
</p>

<p align="center">
  <strong>Système de traitement de données local (mini ETL)</strong><br>
  <em>Ruby orchestre, Crystal exécute les transformations lourdes à grande vitesse.</em>
</p>

---

## 🚀 Présentation

**FluxyCore** est un mini‑ETL local conçu pour l’analyse de données et l’automatisation avancée.  
Il tire parti de la simplicité de **Ruby** pour définir des pipelines de traitement (lecture → transformation → export) et de la performance de **Crystal** pour exécuter les opérations coûteuses (agrégations, parsing de logs, filtrage) de manière native et ultra‑rapide.

### Cas d’usage typiques
- Analyse de logs systèmes ou applicatifs (Apache, NGINX, custom)
- Transformation de fichiers CSV volumineux (ventes, données IoT)
- Extraction et mise en forme de données système
- Automatisation de rapports locaux sans dépendance externe

---

## 🧱 Architecture

┌─────────────┐ pipeline Ruby ┌────────────────────┐
│ Ruby │──────────────────────────▶│ Pipeline Ruby │
│ (orchestre) │ │ - lit les sources │
└─────────────┘ │ - génère config │
│ - lance Crystal │
└─────────┬──────────┘
│ stdin (JSON lines)
▼
┌────────────────────┐
│ Binary Crystal │
│ (transformateur) │
│ - streaming │
│ - batch (sort, │
│ aggregate) │
└─────────┬──────────┘
│ stdout (JSON lines)
▼
┌────────────────────┐
│ Ruby │
│ - écrit sink │
└────────────────────┘

- **Ruby** : lit les fichiers sources (CSV, JSON, lignes de texte), sérialise les données en flux JSON, appelle le binaire Crystal avec la configuration souhaitée, puis récupère le résultat pour l’écrire dans la destination (CSV, JSON, stdout).
- **Crystal** : reçoit les données ligne par ligne sur `stdin`, applique les transformations (agrégation, parsing de logs) et renvoie le résultat sur `stdout`, toujours en JSON lignes.

---

## 📦 Installation

### Prérequis
- **Ruby** ≥ 3.0 (avec Bundler)
- **Crystal** ≥ 1.9 ([installation officielle](https://crystal-lang.org/install/))

### Cloner et compiler
```bash
git clone https://github.com/votre-compte/FluxyCore.git
cd FluxyCore
make build          # compile le binaire Crystal → bin/fluxy_transformer
bundle install      # installe les dépendances Ruby