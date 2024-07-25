## Quick lil script to set up google drive o-auth for connecting to reading sheet
# https://gargle.r-lib.org/articles/non-interactive-auth.html#arrange-for-an-oauth-user-token-to-be-re-discovered

# NOTE: many issues w/ getting google to not think this was a scammy request (app kept getting blocked). reinstalling googledrive package eventually helped after redoing the process several times *eyeroll*
install.packages("googledrive")
library(googledrive)

# trigger auth on purpose --> store a token in the specified cache
drive_auth(cache = ".secrets")

library(googledrive)

options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = "*@gmail.com"
)

# now use googledrive with no need for explicit auth
drive_find(n_max = 5)


# Turns out, just make the google sheet public to anyone w/ the link and my problems are resolved *rolls eyes* 
# a bit annoying to have gone through all the gargle/o-auth stuff and it doesn't work (could get it to work locally but not in quarto preview for some reason)
# adding the book log url as a github secret so it's not as easily readable/findable
# https://stackoverflow.com/questions/56224610/storing-and-retrieving-oauth-token-used-by-api-package-rprofile-vs-renviron


# using renv to make a renv.lock file to fix gh issue?? for quarto publish?? having loads of issues w/ gh action and idk why
renv::snapshot()