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
    ursus = extract_ursidae(sp_list),
    ursus_eco = join_data(ursus, sp_eco, eco_list),
    ursus_neco = get_necoregions(ursus_eco),
    pan_tidy = tidy_pantheria(pantheria)
  )
}
