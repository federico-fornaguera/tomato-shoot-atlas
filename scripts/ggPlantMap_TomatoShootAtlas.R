# ============================================================
# ggPlantMap final GitHub figures — tomato shoot apex
# ============================================================

setwd("C:/Users/fforn/tomato_atlas/GitHub/Final666")

library(dplyr)
library(ggplot2)
library(readr)
library(patchwork)
library(scales)

# ---- Paths ----
data_dir <- "data"
fig_dir  <- "figures"

dir.create(data_dir, showWarnings = FALSE)
dir.create(fig_dir, showWarnings = FALSE)

# ---- Input files ----
roi_points_file <- file.path(data_dir, "split_meristem_ggplantmap_clean_points.csv")

if (!file.exists(roi_points_file)) {
  roi_points_file <- "split_meristem_ggplantmap_clean_points.csv"
}

if (!file.exists(roi_points_file)) {
  stop(
    "Missing ROI point table. Expected data/split_meristem_ggplantmap_clean_points.csv ",
    "or split_meristem_ggplantmap_clean_points.csv\n",
    "Current directory: ", getwd(), "\n",
    "Files here: ", paste(list.files(), collapse = ", "), "\n",
    "Files in data/: ", paste(list.files(data_dir), collapse = ", ")
  )
}

values_file <- file.path(data_dir, "ggplantmap_module_and_gene_values_FINAL_RESTORED.csv")

if (!file.exists(values_file)) {
  values_file <- "ggplantmap_module_and_gene_values_FINAL_RESTORED.csv"
}

if (!file.exists(values_file)) {
  stop(
    "Missing restored final values table. Expected:\n",
    "data/ggplantmap_module_and_gene_values_FINAL_RESTORED.csv\n",
    "or\n",
    "ggplantmap_module_and_gene_values_FINAL_RESTORED.csv\n\n",
    "Current directory: ", getwd(), "\n",
    "Files here: ", paste(list.files(), collapse = ", "), "\n",
    "Files in data/: ", paste(list.files(data_dir), collapse = ", ")
  )
}

message("Using ROI point table: ", roi_points_file)
message("Using module values table: ", values_file)

# ---- Load data ----
tomato_map <- read_csv(roi_points_file, show_col_types = FALSE)
module_values <- read_csv(values_file, show_col_types = FALSE)

message("Available features:")
print(unique(module_values$feature))

# ---- Final restored module features ----
module_features <- c(
  "epidermal_identity_score",
  "trichome_morphogenesis_score",
  "glandular_regulation_score",
  "typeIV_acylsugar_metabolism_score",
  "typeVI_terpene_metabolism_score",
  "reference_control_score"
)

module_title_lookup <- c(
  epidermal_identity_score = "Epidermal identity",
  trichome_morphogenesis_score = "Trichome morphogenesis",
  glandular_regulation_score = "Glandular regulation",
  typeIV_acylsugar_metabolism_score = "Type IV acylsugar metabolism",
  typeVI_terpene_metabolism_score = "Type VI terpene metabolism",
  reference_control_score = "Reference control"
)

missing_features <- setdiff(module_features, unique(module_values$feature))

if (length(missing_features) > 0) {
  stop(
    "The values table is missing expected restored module features:\n",
    paste(missing_features, collapse = "\n"),
    "\n\nAvailable features:\n",
    paste(unique(module_values$feature), collapse = "\n")
  )
}

# ---- Plot settings ----
fig_width <- 15
fig_height <- 9
fig_dpi <- 300

feature_low_color  <- "#2166AC"
feature_mid_color  <- "white"
feature_high_color <- "#B2182B"
feature_na_color   <- "grey90"

polygon_linewidth <- 0.16

map_xlim <- range(tomato_map$x, na.rm = TRUE)
map_ylim <- range(tomato_map$y, na.rm = TRUE)

# ---- Plot one module ----
plot_module_map <- function(feature_name) {
  
  selected_values <- module_values %>%
    filter(feature == feature_name) %>%
    select(ROI.name, value_z)
  
  map_feature <- tomato_map %>%
    left_join(selected_values, by = "ROI.name")
  
  ggplot(
    map_feature,
    aes(x = x, y = y, group = ROI.id, fill = value_z)
  ) +
    geom_polygon(color = "black", linewidth = polygon_linewidth) +
    scale_fill_gradient2(
      low = feature_low_color,
      mid = feature_mid_color,
      high = feature_high_color,
      midpoint = 0,
      na.value = feature_na_color,
      name = "Relative\nscore"
    ) +
    coord_equal(xlim = map_xlim, ylim = map_ylim, expand = FALSE) +
    labs(title = module_title_lookup[[feature_name]]) +
    theme_void() +
    theme(
      plot.title = element_text(
        hjust = 0.5,
        face = "bold",
        size = 10.5,
        margin = margin(b = 2)
      ),
      legend.position = "right",
      legend.title = element_text(size = 7.5),
      legend.text = element_text(size = 7),
      legend.key.height = unit(0.32, "cm"),
      legend.key.width = unit(0.25, "cm"),
      plot.margin = margin(2, 2, 2, 2)
    )
}

# ---- Figure 1: module overview ----
module_plots <- lapply(module_features, plot_module_map)

fig1 <- wrap_plots(module_plots, ncol = 3) +
  plot_annotation(
    title = "Developmental and glandular metabolism modules across the tomato shoot apex",
    theme = theme(
      plot.title = element_text(
        hjust = 0.5,
        face = "bold",
        size = 16,
        margin = margin(b = 6)
      )
    )
  )

print(fig1)

ggsave(
  file.path(fig_dir, "Fig1_developmental_module_overview.png"),
  fig1,
  width = fig_width,
  height = fig_height,
  dpi = fig_dpi
)

# ---- Anatomy guide ----
anatomy_colors <- c(
  "AbaxialMesophyll"     = "#8C83F6",
  "AdaxialMesophyll"     = "#FF8C1A",
  "LeafEpidermis"        = "#E6A400",
  "LeafMargin"           = "#FF4D4D",
  "MeristemEpidermis"    = "#00BFA5",
  "MeristemNoEpidermis"  = "#F6BFC3",
  "OC"                   = "#C76EF3",
  "RibZone"              = "#1F4E9A",
  "Trichome"             = "#00AEEF",
  "Vasculature"          = "#8CBF00"
)

plot_anatomy_guide <- function() {
  
  legend_df <- data.frame(
    ROI.name = names(anatomy_colors),
    x = 1,
    y = 1
  )
  
  ggplot() +
    geom_polygon(
      data = tomato_map,
      aes(x = x, y = y, group = ROI.id, fill = ROI.name),
      color = "black",
      linewidth = 0.18,
      show.legend = FALSE
    ) +
    geom_point(
      data = legend_df,
      aes(x = x, y = y, fill = ROI.name),
      shape = 21,
      size = 5,
      color = "black",
      alpha = 0
    ) +
    scale_fill_manual(
      values = anatomy_colors,
      name = "ROI anatomy"
    ) +
    coord_equal(xlim = map_xlim, ylim = map_ylim, expand = FALSE) +
    labs(title = "Shoot-apex ROI anatomy guide") +
    theme_void() +
    theme(
      plot.title = element_text(
        hjust = 0.5,
        face = "bold",
        size = 16,
        margin = margin(b = 6)
      ),
      legend.position = "right",
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 8.5),
      legend.key.size = unit(0.42, "cm")
    ) +
    guides(
      fill = guide_legend(
        ncol = 1,
        title.position = "top",
        override.aes = list(alpha = 1, shape = 21, size = 4.5, color = "black")
      )
    )
}

fig2 <- plot_anatomy_guide()
print(fig2)

ggsave(
  file.path(fig_dir, "Fig2_shoot_apex_roi_anatomy_guide.png"),
  fig2,
  width = 8.5,
  height = 6.5,
  dpi = fig_dpi
)

message("Saved ggPlantMap figures to: ", fig_dir)