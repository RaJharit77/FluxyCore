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

```
┌─────────────┐      pipeline Ruby       ┌────────────────────┐
│   Ruby      │──────────────────────────▶│  Pipeline Ruby     │
│ (orchestre) │                           │  - lit les sources │
└─────────────┘                           │  - génère config   │
                                          │  - lance Crystal   │
                                          └─────────┬──────────┘
                                                    │ stdin (JSON lines)
                                                    ▼
                                          ┌────────────────────┐
                                          │  Binary Crystal    │
                                          │  (transformateur)  │
                                          │  - streaming       │
                                          │  - batch (sort,    │
                                          │    aggregate)      │
                                          └─────────┬──────────┘
                                                    │ stdout (JSON lines)
                                                    ▼
                                          ┌────────────────────┐
                                          │       Ruby         │
                                          │  - écrit sink      │
                                          └────────────────────┘
```

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
```

Le binaire compilé `bin/fluxy_transformer` est indispensable pour les transformations accélérées.

---

## ⚡ Utilisation

### 1. Lancer un pipeline
```bash
bin/fluxycore examples/csv_aggregation.rb
bin/fluxycore examples/log_analysis.rb
```

### 2. Définir un pipeline (Ruby DSL)

```ruby
require 'fluxycore'

FluxyCore.pipeline do
  source :file, path: 'data/ventes.csv', format: :csv
  transform :aggregate, group_by: 'produit', sum: 'montant', count: true
  sink :csv, path: 'output/resultat.csv'
end
```

### 3. Transformations disponibles

| Transformation   | Description                                                  |
|------------------|--------------------------------------------------------------|
| `aggregate`      | Groupement + somme, moyenne, comptage (accéléré par Crystal) |
| `parse_logs`     | Extraction de champs depuis des logs Apache combined (Regex) |
| Bloc Ruby custom | Transformations arbitraires via `transform { |row| ... }`    |

### 4. Sources & sinks supportés

**Sources :**
- `:file` (format `:csv`, `:json`, `:lines`)
- `:inline` (tableau Ruby passé directement)

**Sinks :**
- `:csv`, `:json` (écrit dans un fichier)
- `:stdout` (affichage formaté)

---

## 🧪 Tests

### Lancer tous les tests
```bash
make test
```
Ceci exécute :
- Les **tests Ruby** (MiniTest) : `bundle exec ruby test/test_pipeline.rb`
- Les **tests Crystal** (spec) : `cd src/crystal && crystal spec`

### Tester individuellement
```bash
# Ruby
bundle exec ruby test/test_pipeline.rb

# Crystal
cd src/crystal && crystal spec
```

### Linting
```bash
make lint
```
Vérifie le style Ruby via **RuboCop** et Crystal via **Ameba**.

---

## 🐳 Docker

Une image Docker prête à l’emploi est disponible.

### Construire l’image
```bash
make docker-build
```

### Exécuter un pipeline avec Docker
```bash
make docker-run
```
Par défaut, cela lance `examples/csv_aggregation.rb`.  
Montez vos propres volumes pour traiter vos fichiers :
```bash
docker run --rm \
  -v $(pwd)/mes_données:/app/data \
  -v $(pwd)/mes_sorties:/app/output \
  fluxycore examples/mon_pipeline.rb
```

---

## 🔄 CI/CD

Un workflow GitHub Actions est fourni (`.github/workflows/ci.yml`).  
Il exécute à chaque push et PR :
1. Installation de Ruby et Crystal
2. Linting (RuboCop + Ameba)
3. Compilation du binaire Crystal
4. Tests unitaires Ruby et Crystal

Les badges de statut peuvent être ajoutés dans ce README une fois le dépôt configuré.

---

## 📂 Structure du projet

```
FluxyCore/
├── bin/
│   ├── fluxycore              # Lanceur Ruby
│   └── fluxy_transformer      # Binaire Crystal (généré par la compilation)
├── lib/
│   └── fluxycore/             # Code source Ruby (pipeline, runner, source/sink/transform)
├── src/crystal/               # Code source Crystal (transformateurs + spec)
├── examples/                  # Pipelines d'exemple
├── test/                      # Tests Ruby
├── Makefile
├── Dockerfile
├── Gemfile
└── .github/workflows/ci.yml  # CI GitHub Actions
```

---

## 🤝 Contribuer

Les contributions sont les bienvenues !  
- Forkez le projet
- Créez une branche (`git checkout -b feature/ma-fonctionnalite`)
- Commitez vos changements
- Poussez et ouvrez une Pull Request

Merci de respecter le style de code en exécutant `make lint` avant de soumettre.

---

## 📄 Licence

Ce projet est distribué sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.
