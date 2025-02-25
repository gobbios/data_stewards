#' some checks for how a system is set up with respect to R, RStudio and git
#'
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
settings_check <- function() {
  if (Sys.info()["sysname"] == "Darwin") os <- "mac"
  if (Sys.info()["sysname"] == "Windows") os <- "win"
  if (Sys.info()["sysname"] == "Linux") os <- "linux"

  all_good <- TRUE

  if (!"lme4" %in% installed.packages()[, "Package"]) {
    cat("package lme4 is missing\n")
    all_good <- FALSE
  }

  # check if you have git installed:
  gitpresent <- tryCatch({
    system2("git", "-v", stdout = TRUE, stderr = NULL)
  }, error = function(e) {
    return(NULL)
  }, warning = function(e) {
    return(NULL)
  })
  if (is.null(gitpresent)) {
    cat("it seems git is not installed\n\n")
  } else {
    cat("wohoo, it seems you have git (", gitpresent, " to be precise)\n\n", sep = "")
  }

  # Rstudio if active
  if ("rstudioapi" %in% installed.packages()[, "Package"]) {
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

    x <- rstudioprefs[grepl("save_workspace", rstudioprefs)]
    if (!grepl("never", x)) {
      cat("RStudio Setting 'save workspace' is *not* never\n")
      all_good <- FALSE
    } else {
      cat("good, automatically saving the workspace in RStudio is turned off\n")
    }

    x <- rstudioprefs[grepl("load_workspace", rstudioprefs)]
    if (!grepl("false", x)) {
      cat("RStudio Setting 'load workspace' is *not* disabeled\n")
      all_good <- FALSE
    } else {
      cat("good, automatically loading the workspace in RStudio is turned off\n")
    }

    if (length(recentprojects) == 0) {
      cat("it seems you haven't yet used RStudio's project feature, meh\n")
      cat("  (or you recently deleted the project history)\n")
    } else {
      cat("you have", length(recentprojects)," projects in your 'recent projects' list", "\n")
      cat("  (the oldest one in the list is ", shQuote(basename(recentprojects[length(recentprojects)])), ")\n", sep = "")
    }
  } else {
    cat("looks like RStudio is not installed\n")
    cat(" (or at least it's not been used with the current R installation)\n")
  }

  if (all_good) {
    cat("looking good\n")
  }
  invisible(NULL)
}

