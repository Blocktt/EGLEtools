NEWS-MIEGLEtools
================

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->

    #> Last Update: 2020-07-28 14:09:13

# MIEGLEtools v0.1.1.934 (2020-07-28)

  - Updated thresholds for metric scoring to be obtained from within the
    `BioMonTools` package
      - The `BioMonTools` package has a thresholds excel file within the
        package that is referenced.
      - This Excel file would need to be edited to changed metric
        threshold values when scoring metrics.
  - Version changed to previous naming convention v0.1.1.934 rather than
    v0.1.0.9001.

# MIEGLEtools v0.1.0.9001 (2020-07-28)

  - Start adding elements to allow for package creation.
      - DESCRIPTION
          - Title, Description, authors, maintainer, IMPORTS, License,
            and URL
      - NEWS
          - Add file and update.
      - MIEGLEtools
          - Remove from base directory
      - .\_MIEGLEtools.Rmd
          - Add notebook for code to aid in creation of package
      - Vignette
          - Ensure each chunk had a unique name (single word only).
      - runShiny.R
          - Update URL in details.
      - README
          - Need to add RMD file for editing only have MD.
  - Shiny app updates
      - Add packages to DESCRIPTION.  
      - Comment out library() calls in ui.R and server.R.  
  - License
      - Recreated with usethis::use\_mit\_license(“Ben Block”)
  - Ran Check and addressed issues.
  - UI.r, update version number to the same as the package version.

# MIEGLEtools v0.1.0.9000 (2020-07-28)

  - Forked code from <https://github.com/Blocktt/MIEGLEtools>
