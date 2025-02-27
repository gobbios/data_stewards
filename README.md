<div class="figure" style="text-align: center">
<img src="images/qr-code.png" width="30%" />
</div>




I assume you have some basic R knowledge.

You need a fairly recent R version (say 4.2 or so) and I highly recommend RStudio.

Also, you need the following R packages installed:
  
  - `usethis`

  - `gitcreds`

To check whether your system is ready, do this:

```
source("https://raw.githubusercontent.com/gobbios/data_stewards/refs/heads/main/R/settings_check.R")
settings_check(r_packages = c("usethis", "gitcreds"), min_r = 4.2)
```

These commands download an R script, which contains a simple function.
This function is run and should provide some informative messages relevant to your system setup.

Now at the latest you will know whether you have RStudio and git available.
The existence of `quarto` and `LaTeX` is also checked here but not required for the workshop.

# setup steps

The following steps need to be worked through.

- (install R and RStudio)

- (setup GitHub account)

- install git (described below)

- connect RStudio to GitHub (described below)


## install git

You only need to do this if the `settings_check()` indicated that you don't have git...

### git on Mac

- in the console/terminal (not in R)

```
xcode-select --install
```


### git on Windows

- install Git Bash from https://gitforwindows.org

- install below `C:/Program Files` 

- when asked about "Adjusting your PATH environment", select "Git from the command line and also from 3rd-party software"

- accept the defaults for everything else


### git on Linux

- I assume you know what you are doing

- if not:


```
# Ubuntu / Debian Linux:
sudo apt-get install git

# Fedora / RedHat Linux:
sudo yum install git
```

## connect RStudio, git and github to each other

If you already have a working setup with appropriate credentials, you can skip this part too.

### generate access token

- go to R:

```
usethis::create_github_token(description = "this is for trying out GitHub")
```

- browser opens, leave the settings (30 day expiration)

- click "Generate Token" at the bottom

- now copy the token into the clipboard and paste to a temporary place where you can retrieve it

- it looks something like `ghp_RFf45gW5gxxxxxxxxxxx`

- this is a PAT (personal access token)

- back to R

```
gitcreds::gitcreds_set()
```

- when asked, paste your PAT here

- (if you have an active set of credentials, you may want to keep working with that set or delete it to start fresh)

- you should see something like

```
-> Adding new credentials...
-> Removing credentials from cache...
-> Done.
```


```
usethis::git_sitrep(tool = "github", scope = "user")
```

- if this shows: `Personal access token for "https://github.com": <discovered>` we are good to go


- if this shows: `Personal access token for "https://github.com": <unset>` we have to try again

  - or get in touch with me


