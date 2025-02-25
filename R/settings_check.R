#' some checks for how a system is set up with respect to R, RStudio and git
#'
#' @param r_packages a character vector with package names. default is
#'          \code{NULL}, i.e. don't check any package availability.
#' @returns textual output
#' @export
#'
#' @details
#' The function tries to detect the system OS and depending on this, tries to
#'   locate setting files.
#' I don't guarantee it works everywhere.
#'
#'
#' @examples
#' settings_check()
#' settings_check(r_packages = c("lme4", "EloSteepness"))
settings_check <- function(r_packages = NULL) {
  if (Sys.info()["sysname"] == "Darwin") os <- "mac"
  if (Sys.info()["sysname"] == "Windows") os <- "win"
  if (Sys.info()["sysname"] == "Linux") os <- "linux"

  all_good <- TRUE


  # check if you have git installed:
  gitpresent <- tryCatch({
    system2("git", "-v", stdout = TRUE, stderr = NULL)
  }, error = function(e) {
    return(NULL)
  }, warning = function(e) {
    return(NULL)
  })

  cat("checking git installation:\n")
  cat("--------------------------\n")
  if (is.null(gitpresent)) {
    cat("it seems git is not installed\n\n")
  } else {
    cat("wohoo, it seems you have git (", gitpresent, " to be precise)\n\n", sep = "")
  }


  # check if quarto installed:
  quartopresent <- tryCatch({
    system2("quarto", "-v", stdout = TRUE, stderr = NULL)
  }, error = function(e) {
    return(NULL)
  }, warning = function(e) {
    return(NULL)
  })

  cat("checking quarto installation:\n")
  cat("-----------------------------\n")
  if (is.null(quartopresent)) {
    cat("it seems quarto is not installed\n\n")
  } else {
    cat("wohoo, it seems you have quarto (version ", quartopresent, " to be precise)\n\n", sep = "")
  }

  # check if LaTex installed:
  latexpressent <- tryCatch({
    system2("latex", "-v", stdout = TRUE, stderr = NULL)
  }, error = function(e) {
    return(NULL)
  }, warning = function(e) {
    return(NULL)
  })
  cat("checking LaTeX installation:\n")
  cat("----------------------------\n")
  if (is.null(quartopresent)) {
    cat("it seems LaTeX is not installed\n\n")
  } else {
    cat("wohoo, it seems you have LaTeX (I don't dare to guess which version exactly)\n\n", sep = "")
  }


  # Rstudio if active
  cat("checking RStudio installation:\n")
  cat("------------------------------\n")
  if ("rstudioapi" %in% installed.packages()[, "Package"]) {
    recentprojects <- character()
    if (os == "mac" | os == "linux") {
      rstudioprefs <- suppressWarnings(readLines("~/.config/rstudio/rstudio-prefs.json"))
      recentprojects <- suppressWarnings(readLines("~/.local/share/rstudio/monitored/lists/project_mru"))
    }
    if (os == "win") {
      rstudioprefs <- suppressWarnings(readLines(normalizePath(file.path(Sys.getenv("APPDATA"), "RStudio", "rstudio-prefs.json"))))
      recentprojects <- suppressWarnings(readLines(file.path(Sys.getenv("APPDATA"), "..", "Local/RStudio/monitored/lists/project_mru")))
    }
    if (!exists("rstudioprefs")) {
      cat("looks like RStudio is available, but I didn't find the settings file\n")
      return(invisible(NULL))
    }
    cat("looks like RStudio is installed, whoop whoop\n")


    x <- rstudioprefs[grepl("save_workspace", rstudioprefs)]
    if (isTRUE(grepl("never", x))) {
      cat("good, automatically saving the workspace in RStudio is turned off\n")
    } else {
      cat("RStudio Setting 'save workspace' is *not* never\n")
      all_good <- FALSE
    }

    x <- rstudioprefs[grepl("load_workspace", rstudioprefs)]
    if (isTRUE(grepl("false", x))) {
      cat("good, automatically loading the workspace in RStudio is turned off\n")
    } else {
      cat("RStudio Setting 'load workspace' is *not* disabeled\n")
      all_good <- FALSE
    }

    if (length(recentprojects) == 0) {
      cat("it seems you haven't yet used RStudio's project feature, yet, meh\n")
      cat("  (or you recently deleted the project history)\n")
    } else {
      cat("you have", length(recentprojects)," projects in your 'recent projects' list", "\n")
      cat("  (the oldest one in the list is ", shQuote(basename(recentprojects[length(recentprojects)])), ")\n", sep = "")
    }
  } else {
    cat("looks like RStudio is not installed\n")
    cat(" (or at least it's not been used with the current R installation)\n")
  }


  if (!is.null(r_packages)) {
    cat("\n")
    cat("checking R packages installation:\n")
    cat("---------------------------------\n")

    for (pk in r_packages) {
      if (!pk %in% installed.packages()[, "Package"]) {
        cat("NOOOO, package", shQuote(pk), "is missing\n")
      } else
        cat("nice, package", shQuote(pk), "is available\n")
    }
  }



  invisible(NULL)
}

