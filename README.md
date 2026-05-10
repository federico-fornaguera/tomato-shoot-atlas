# tomato-shoot-atlas
Exploratory analysis of tomato shoot-apex single-nucleus atlas data for epidermal and trichome developmental context.

## Data source and scope

This repository uses the tomato shoot-apex single-nucleus RNA-seq atlas from Tian et al. (2020) as a reference for exploratory marker/module scoring. The original atlas was generated from *Solanum lycopersicum* cv. M82 seedlings, using shoot apices dissected from 2-week-old plants and retaining the shoot apical meristem (SAM) together with early leaf primordia up to P3.

This analysis builds on the authors’ cell annotations, especially epidermis, trichome, meristem, mesophyll, vasculature, and rib zone categories. The atlas is used here to explore epidermis-to-trichome developmental context rather than to assign definitive mature trichome subtype identity.

## What this workflow does

- Loads the published tomato shoot-apex atlas.
- Maps curated tomato trichome/development/metabolism candidate genes to atlas gene IDs.
- Scores developmental gene modules across author-defined atlas cell categories.
- Compares curated candidate genes with atlas-derived trichome marker genes.
- Exports summary tables and figures.
- Uses ggPlantmap separately in R to project module scores onto a manually reconstructed shoot-apex schematic.

## Repository structure

```text
notebooks/
  tomato_shoot_atlas_trichome_context.ipynb

data/
  curated_gene_modules_github.csv

figures/
  Fig1_developmental_module_overview.png
  Fig2_shoot_apex_roi_anatomy_guide.png

scripts/
  ggPlantMap_final_figures.R
