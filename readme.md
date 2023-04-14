## aur.bash

this is a super minimal aur helper that can search, clone, and throw you in a subshell to build a package

it also supports retrieving PKGBUILDS that are in the main arch repos

![cli](cli.png)


#### Setup / Usage

 
 1. `mkdir -p ~/work/aur`
 2. clone this repo
 3. add `source /path/to/this/repo/aur.bash` to `.bashrc`
 4. open a new terminal or run `source ~/.bashrc`
 5. run `aur sync` to download a list of all the aur packages
 6. run `aur search $SEARCH_TERM` to find a package 
 7. run `aur clone $PKG_NAME` to clone a repo, and spawn a subshell
 8. review / edit the PKGBUILD, then build+install with `makepkg -sAi`
 9. press `Ctrl + d` to exit the subshell and return to where you started from


