# FluxyCore

**Local data processing toolbox – mini ETL powered by Ruby & Crystal**

FluxyCore lets you define lightweight ETL pipelines in Ruby and execute heavy transformations at native speed using Crystal. Perfect for local log analysis, CSV cleanup, system metrics crunching, or any ad‑hoc data task where performance matters.

---

## Architecture
┌─────────────┐ pipeline DSL ┌───────────────────┐
│ Ruby CLI │─────────────────────▶│ Pipeline definition│
│ (bin/fluxy) │ │ (read → transform │
└──────┬──────┘ │ → export) │
│ └────────┬──────────┘
│ spawns Crystal binaries │
▼ ▼
┌──────────────────┐ ┌──────────────────────┐
│ Crystal runner │◀─────────────│ Crystal transforms │
│ (fluxy_core) │ subcommands │ (filter, aggregate, │
│ native binary │ │ normalize, join …) │
└──────────────────┘ └──────────────────────┘


- **Ruby** handles pipeline orchestration, data sources (files, STDIN), simple transforms, and exports.  
- **Crystal** is compiled into a single `fluxy_core` binary that executes heavy operations (filtering millions of rows, aggregations, normalizations) with near‑C performance.  
- Communication: Ruby spawns the Crystal binary with arguments and reads/writes data via temporary files or pipes (configurable). Zero network overhead, fully local.

---

## Prerequisites

- **Ruby** ≥ 3.0 (with Bundler)
- **Crystal** ≥ 1.8 (to build the native binary)
- **Make** (optional, for convenience targets)

---

## Installation

```bash
git clone https://github.com/RaJharit77/FluxyCore.git
cd FluxyCore

# Install Ruby dependencies
bundle install

# Build the Crystal binary
cd crystal
shards install
make        # uses crystal build src/fluxy_core.cr -o ../bin/fluxy_core
cd ..

# Verify
bundle exec bin/fluxycore --version
