#!/bin/bash -i

function aur() {

  export AURPATH="${HOME}/work/aur"

  function cmd_help {
    echo "must provide a command, choices are:"
    echo 'clone $PKG_NAME'
    echo 'search $STR'
    echo 'sync'
  }

  function search_aur {
    PYCODE=$'
      import gzip,json,os,sys;
      q = sys.argv[1].lower();
      with gzip.open(os.getenv("AURPATH")+"/packages-meta-ext-v1.json.gz", "r") as f:
        for x in json.loads(f.read().decode("utf-8")):
          if ((q in x["Name"]) or
              (q in x["PackageBase"]) or
              ((x["Description"]) and (q in x["Description"].lower()))):
            c1 = "\x1b[38;5;105m" # blue on black
            c2 = "\x1b[38;5;118m"
            c3 = "\x1b[38;5;121m"
            r = "\x1b[0m"         # reset
            n = x["Name"]
            v = x["Version"]
            l = x["License"] if "License" in x else ["undefined"]
            d = x["Description"]
            u = x["URL"]
            print(f"{c1}AUR{r}/{c2}{n}{r}\t\t{v}\t{l}\\n    {c3}{d}{r}\\n    {u}")
    '
    PYCODE=`sed 's/^      //g' <<< "${PYCODE}"`
    python -c "${PYCODE}" $1
  }

  case $1 in
    clone)
      git -C $AURPATH clone -b packages/$2 --single-branch https://github.com/archlinux/svntogit-packages $2 ||
      git -C $AURPATH clone https://aur.archlinux.org/$2.git
      ( cd $AURPATH/$2;
        [ -d trunk ] && cd trunk;
        if [ ! -f PKGBUILD ]; then
          echo 'NO PKGBUILD FOUND!';
          cd $AURPATH;
          rm -rf $2;
          exit 1
        fi;
        PROMPT_COMMAND="PS1='[\[\e[38;5;105m\]AUR\[\e[0m\]]$PS1';unset PROMPT_COMMAND"  bash -l
      )
      ;;
    search)
      (pacman --color=always -Ss $2; search_aur $2) | less -FR
      ;;
    sync)
      wget --timestamping \
           --no-if-modified-since \
           --continue \
           --directory-prefix=$AURPATH \
           --content-disposition \
           --trust-server-names \
           https://aur.archlinux.org/packages-meta-ext-v1.json.gz
      ;;
    pip)
      pypi2pkgbuild.py --base-path $AURPATH --no-install --makepkg="-si" $2
      ;;
    *)
      cmd_help
      ;;
esac
}

# either source this script to get the aur command, or simply run this script to run the aur command
(return 0 2>/dev/null) || aur $@
