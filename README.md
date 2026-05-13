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

**FluxyCore** est un mini-ETL local conçu pour l’analyse de données et l’automatisation avancée. Il tire parti de la simplicité de **Ruby** pour définir des pipelines de traitement (lecture → transformation → export) et de la performance de **Crystal** pour exécuter les opérations coûteuses (filtrage, extraction par regex, parsing de dates, tri, agrégations) de manière native et ultra‑rapide.

**Cas d’usage typiques :**
- Analyse de logs systèmes ou applicatifs
- Transformation de fichiers CSV volumineux
- Extraction et mise en forme de données système
- Automatisation locale de rapports

---

## 🧱 Architecture

┌─────────────┐ pipeline YAML ┌────────────────────┐
│ Ruby │──────────────────────▶│ Ruby Pipeline │
│ (orchestre)│ │ - lit les sources │
└─────────────┘ │ - génère config │
│ - lance Crystal │
└─────────┬──────────┘
│ stdin (JSON lines)
▼
┌────────────────────┐
│ Crystal Binary │
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


- **Ruby** parse le fichier YAML de pipeline, lit les données sources (fichiers, stdin), les convertit en flux JSON, exécute le binaire Crystal en lui passant la configuration des transformations, puis récupère le résultat pour l’écrire dans la destination choisie.
- **Crystal** reçoit les données ligne par ligne sur `stdin`, applique les transformations légères (filtre, map, regex, parsing) en streaming, et exécute les opérations nécessitant l’ensemble du jeu de données (`sort`, `aggregate`) une fois toutes les lignes lues. Le résultat est émis sur `stdout`.

---

## 📦 Installation

### Prérequis
- **Ruby** ≥ 3.0
- **Crystal** ≥ 1.9 (https://crystal-lang.org/install/)

### Cloner et compiler
```bash
git clone https://github.com/votre-compte/FluxyCore.git
cd FluxyCore
make build
