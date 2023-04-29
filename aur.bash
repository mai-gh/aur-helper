function aur() {
  function cmd_help {
    echo "must provide a command, choices are:"
    echo 'clone $PKG_NAME'
    echo 'search $STR'
    echo 'sync'
  }

  case $1 in
    clone)
      git -C ~/work/aur clone -b packages/$2 --single-branch https://github.com/archlinux/svntogit-packages $2 ||
      git -C ~/work/aur clone https://aur.archlinux.org/$2.git
      sh -c "cd ~/work/aur/$2;
             [ -d trunk ] && cd trunk;
             if [ ! -f PKGBUILD ]; then
               echo 'NO PKGBUILD FOUND!';
               cd ~/work/aur;
               rm -rf $2;
               exit 1
             fi;
             PROMPT_COMMAND='PS1=\"[\[\e[38;5;105m\]AUR\[\e[0m\]]$PS1\";unset PROMPT_COMMAND'  bash -l
            "
      ;;
    search)
      pacman -Ss $2
      zgrep $2 ~/work/aur/packages.gz | sed 's|^|aur/|g'
      ;;
    sync)
      wget --continue --directory-prefix=$HOME/work/aur/ --content-disposition --trust-server-names https://aur.archlinux.org/{packages,pkgbase,users,packages-meta-v1.json,packages-meta-ext-v1.json}.gz
      ;;
    *)
      cmd_help
      ;;
esac
}
