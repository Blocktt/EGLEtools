#' @title MIEGLEtools QC function
#'
#' @description Quality control function for MIEGLEtools to ensure all columns are found
#'
#' @details The Shiny app based on the R package MIEGLEtools requires that certain columns be included to ensure that
#' metric values and scores are legitimate. This function is a quality control function used in server.R prior to metric.values() calculation.
#'
#'There are a number of required fields (see below) for metric to calculation.
#' If any fields are missing the user will receive an error and the metric calculations will not be completed.
#'
#'
#'
#' Required Fields:
#'
#' * SAMPLEID (character or number, must be unique)
#'
#' * TAXAID (character or number, must be unique)
#'
#' * N_TAXA
#'
#' * EXCLUDE (valid values are TRUE and FALSE)
#'
#' * INDEX_NAME
#'
#' * INDEX_REGION (BCG or MMI site category; e.g., for BCG PacNW valid values are "hi" or "lo")
#'
#' * NONTARGET (valid values are TRUE and FALSE)
#'
#' * PHYLUM, SUBPHYLUM, CLASS, SUBCLASS, INFRAORDER, ORDER, FAMILY, SUBFAMILY, TRIBE, GENUS
#'
#' * FFG, HABIT, TOLVAL
#'
#' Valid values for FFG: CG, CF, PR, SC, SH
#'
#' Valid values for HABIT: BU, CB, CN, SP, SW
#'
#'
#' Columns to keep are additional fields in the input file that the user wants
#' retained in the output.  Fields need to be those that are unique per sample
#' and not associated with the taxa.  For example, the fields used in qc.check();
#' Area_mi2, SurfaceArea, Density_m2, and Density_ft2.
#'
#' If fun.MetricNames is provided only those metrics will be returned in the provided order.
#' This variable can be used to sort the metrics per the user's preferences.
#' By default the metric names will be returned in the groupings that were used for calculation.
#'
#' The fields TOLVAL2 and FFG2 are provided to allow the user to calculate metrics
#' based on alternative scenarios.  For example, HBI and NCBI where the NCBI uses
#' a different set of tolerance values (TOLVAL2).
#'
#' If TAXAID is 'NONE' and N_TAXA is "0" then metrics **will** be calculated with that record.
#' Other values for TAXAID with N_TAXA = 0 will be removed before calculations.
#'
#' For 'Oligochete' metrics either Class or Subclass is required for calculation.
#
#' @export
