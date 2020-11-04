#' Write basic plan
#'
#' @return A drake plan
#' @export
#'
#' @importFrom drake drake_plan
#' @examples
write_plan <- function() {
  drake::drake_plan(
    eco_list = data_ecoregion(),
    sp_eco = data_mammals_ecoregions(),
    sp_list = data_mammals(),
    pantheria = data_pantheria(),
    # wrangle data
    ursus = extract_ursidae(sp_list),
    ursus_eco = join_data(ursus, sp_eco, eco_list),
    ursus_neco = get_necoregions(ursus_eco),
    pan_tidy = tidy_pantheria(pantheria),
    # figures
    fig1 = plot_necoregions(ursus_neco),
    fig2 = plot_gestation(pan_tidy),
    fig3 = get_worldmap(ursus_eco),
    # output
    out_fig1 = save_plot(fig1, "figure1_necoregions"),
    out_fig2 = save_plot(fig2, "figure2_gestation"),
    out_fig3 = save_plot(fig3, "figure3_worldmap")
  )
}
