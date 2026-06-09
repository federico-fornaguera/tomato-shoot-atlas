# Tomato shoot-apex single-nucleus atlas: trichome marker re-analysis

Exploratory re-analysis of the tomato shoot-apex snRNA-seq atlas to detect trichome developmental, glandular regulatory, and metabolic marker programs.

## Data source and scope
This repository uses the tomato shoot-apex single-nucleus RNA-seq atlas from Tian et al. (2020), generated from *Solanum lycopersicum* cv. M82 shoot apices from 2-week-old seedlings.

Using author annotations and literature-reported markers, this analysis explores whether Type IV-like and Type VI-like glandular trichome marker signals can be detected within the shoot-apex atlas, and whether these signals are strong enough to support subtype annotation in trichome single-cell datasets.


## What this workflow does

- maps curated tomato trichome/development/metabolism marker genes to atlas gene IDs;
- scores literature-supported marker modules across atlas-defined cell categories;
- evaluates enrichment of curated markers in atlas-defined trichome nuclei;
- defines Type IV-like and Type VI-like metabolic marker groups;
- exports summary tables and figures;
- uses ggPlantMap in R to project module scores onto a manually reconstructed shoot-apex schematic.

## Key findings

- Trichome morphogenesis and glandular regulation modules are enriched in atlas-defined trichome nuclei.
- The epidermal identity module is strongest in epidermal contexts and reduced in trichome-labelled nuclei.
- Type IV acylsugar and Type VI terpene metabolic markers are detected in only subsets of trichome nuclei.
- Most trichome nuclei are metabolic-marker-negative, consistent with early developmental stage and snRNA-seq limitations.
- No clean Type IV versus Type VI mature subtype separation is recovered; the data support partial marker-program states.

## Repository structure

```text
.
├── README.md
├── notebooks/
│   ├── 00_author_trichome_marker_discovery.ipynb
│   └── 01_tomato_trichome_shoot_apex_atlas.ipynb
├── scripts/
│   └── ggPlantMap_TomatoShootAtlas.R
├── data/
│   ├── final_module_definitions.csv
│   ├── literature_candidate_gene_table.csv
│   ├── ggplantmap_module_and_gene_values.csv
│   ├── ggplantmap_module_gene_lookup.csv
│   ├── ggplantmap_key_gene_values.csv
│   └── split_meristem_ggplantmap_clean_points.csv
├── figures/
└── tables/
```
## References

- Tian, C., Du, Q., Xu, M., Du, F., & Jiao, Y. (2020). *Single-nucleus RNA-seq resolves spatiotemporal developmental trajectories in the tomato shoot apex*. bioRxiv. https://doi.org/10.1101/2020.09.20.305029

- EMBL-EBI Single Cell Expression Atlas. *Single-nucleus RNA-seq resolves spatiotemporal developmental trajectories in the tomato shoot apex* — accession `E-ENAD-53`. https://www.ebi.ac.uk/gxa/sc/experiments/E-ENAD-53

- Jo, L. & Kajala, K. (2024). *ggPlantmap: An open-source R package for informative ggplot maps from plant images*. Journal of Experimental Botany, 75(17), 5366–5376. https://doi.org/10.1093/jxb/erae043
- https://github.com/leonardojo/ggPlantmap
