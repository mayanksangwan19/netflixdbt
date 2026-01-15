# 🎬 Netflix Analytics Engineering Platform  
**Snowflake • dbt • CI/CD • Analytics Engineering**

---

##  Project Overview

This project demonstrates a **production-ready analytics engineering pipeline** built using **Snowflake** and **dbt** on the MovieLens dataset.  

The objective is to:
- Transform raw data into **analytics-ready fact and dimension tables**
- Apply **star and snowflake schema modeling**
- Track historical changes using **dbt snapshots (SCD Type-2)**
- Ensure data quality with **tests**
- Document transformations with **dbt docs & lineage**
- Deploy safely using **CI/CD with GitHub Actions**

This project follows **real industry practices**, not tutorial shortcuts.

---

##  Complete Architecture

### End-to-End Flow

Source Data (MovieLens CSVs / API) → Snowflake RAW Layer → dbt Staging Models (Views) → dbt Intermediate Models (Views) → dbt Marts (Facts & Dimensions - Tables) →
 → Snapshots (SCD Type-2 History) → Analytics Consumption (Snowflake SQL / BI Tools)


### CI/CD wraps the entire system

Developer → GitHub → CI (tests) → Merge → CD → Snowflake PROD

---

## 🧱 Data Layers Explained

### 1️⃣ RAW Layer (Snowflake)
- Stores unmodified source data
- Acts as the system of record
- No transformations applied

---

### 2️⃣ Staging Layer (`stg_*`) — **Views**
Purpose:
- Rename columns
- Cast data types
- Standardize formats
- Minimal logic

Example:
- `stg_movies`
- `stg_ratings`
- `stg_tags`
- `stg_genome_scores`

---

### 3️⃣ Intermediate Layer (`int_*`) — **Views**
Purpose:
- Handle complex transformations
- Normalize multi-valued fields
- Keep marts clean

Example:
- `int_movie_genres` (explodes genres)

---

### 4️⃣ Marts Layer — **Tables**

#### 📊 Fact Tables
- `fct_ratings` (incremental)
- `fct_user_tags`
- `fct_genome_scores`

Facts store **events & measurements** and are optimized for analytics.

#### 📐 Dimension Tables
- `dim_movies`
- `dim_users`
- `dim_tags`
- `dim_genres` (snowflaked)

Dimensions provide **context** to facts.

---

## ⭐ Schema Design

- **Star Schema**  
  Used for core analytics (facts joined directly to dimensions)

- **Snowflake Schema**  
  Used where attributes are multi-valued (e.g. genres)

This hybrid approach is **industry standard** and avoids data duplication.

---

## ⏱️ Snapshots (Slowly Changing Dimensions)

Implemented **dbt snapshots (SCD Type-2)** to track historical changes in movie attributes.

### Snapshot:
- `movies_snapshot`

Tracks:
- Movie title changes
- Genre changes over time

Enables:
- Time-aware joins
- Historically correct analytics

---

## 🧪 Data Quality & Testing

The project enforces data quality using dbt tests:

- `not_null`
- `unique`
- Relationship tests between facts & dimensions

Tests are:
- Run locally during development
- Automatically enforced in CI before merge

---

## 📚 Documentation & Lineage (dbt Docs)

dbt docs are generated to provide:

- Model-level documentation
- Column-level descriptions
- Full lineage graphs
- Source-to-mart transparency

This ensures:
- Trust in data
- Easy onboarding
- Debuggable pipelines

Docs are generated using:
```bash
dbt docs generate
dbt docs serve




