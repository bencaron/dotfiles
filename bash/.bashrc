# /etc/bash.bashrc
[ -f /etc/profile ] && . /etc/profile

function knife-lab(){
    knife $@ --config=~/.chef/lab/knife.rb
}

setxkbmap -option "ctrl:nocaps,grp:shift_toggle"
#export PYTHONPATH=/home/benoit/workspace/virtualarmada/varmada/lib
export PYTHONPATH=/home/benoit/src/lib-python
#http://jbowes.wordpress.com/2008/05/13/installing-ruby-gems-in-your-home-directory/
#export GEM_HOME=$HOME/.gems
#export GEM_PATH=$HOME/.gems:/usr/lib/ruby/gems/1.8/
#export PATH=$PATH:$HOME/.gems/bin

export GEM_HOME=$HOME/gems
#export GEM_PATH=/home/benoit/gems:/home/benoit/.gem:/usr/lib/ruby/gems/1.8
export GEM_PATH=$GEM_HOME:/usr/lib/ruby/gems/1.8

 #supposer mettre le path dans le tab, et changer le titre de la fenetre ; marche pas ici..
# trouver la:
# http://www.debian-administration.org/articles/548
# commentaire #2
#PROMPT_COMMAND='PWDF=`pwd|sed "s/.*\/\(.*\)/\1/"`; echo -ne "\033]0;$TTY:${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007\033] 30;${HOSTNAME%%.*}:${PWDF}\007"'

## Commandes de Pascal pour ripper/graver les DVD
#dvdbackup -M -i /dev/cdrom -o /home/xaphan/tmp/ 
#mkisofs -dvd-video -o /DVD_PROJECTS/homedvd.img /DVD_PROJECTS/HOMEDVD/  
#isoinfo -i homedvd.img -l 
#growisofs -dvd-compat -Z /dev/dvd=/home/xaphan/SinCity.iso 

# Vi mode!
#set -o vi

#export KDEDIR=/usr
#export QTDIR=/usr/share/qt3

export VISUAL=/usr/bin/vim
export EDITOR=$VISUAL

# Mes ajouts
###############################################

# Java - pour AWS
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/jre

# AWS
export AWS_AUTO_SCALING_HOME=/opt/autoscaling
export AWS_ELB_HOME=/opt/elasticloadbalancing
export AWS_CREDENTIAL_FILE=$HOME/.credential
export EC2_PRIVATE_KEY=$HOME/Documents/Amazon/pk-x509.pem
export EC2_CERT=$HOME/Documents/Amazon/cert-H7UMQIAQK6BM6WAMTPFYLTU6KXTDRP3R.pem

#export PATH=$PATH:$HOME/bin:$HOME/gems/bin:$HOME/.gem/ruby/1.8/bin:/var/lib/gems/1.8/bin:$AWS_AUTO_SCALING_HOME/bin:$JAVA_HOME/bin
export PATH=$PATH:$HOME/bin:$HOME/gems/bin:$HOME/.gem/ruby/1.8/bin:$AWS_AUTO_SCALING_HOME/bin:$AWS_ELB_HOME/bin:$JAVA_HOME/bin

# Load aliases file
. $HOME/.bash_aliases

alias webserver-here='python -m SimpleHTTPServer'


# alias pour mutt
alias mutt='mutt -f ~/Maildir/'
alias ducks='du -cks * |sort -rn |head -11'
alias lt='ls -alth'
alias lr='ls -althr'
alias ll='ls -lh'
alias la='ls -ah'
#alias sshcanoe='ssh -l bcaron -p 22022 '
alias vim-bashrc='vim ~/.bashrc && source ~/.bashrc '
alias histogrep='history | grep '
alias hgrep='history | grep '
#alias apt-get='sudo aptitude '

alias mountimg='sudo mount -o loop,offset=32256 '

alias netcat-receive='nc -v -v -l -n -p 2222 >/dev/null'
alias netcat-send='time yes|nc -v -v -n 192.168.1.75 2222 >/dev/null'

alias rreloadbashrc='source /home/benoit/.bashrc'

#gnome
alias terminal='gnome-terminal'


function mysqltunnel(){
    server=$1
    portplus=$((3300 + `echo $server | awk -F. '{print $4}'`))
    ssh -f -L $portplus:$server:3306 probe.cakemail.local sleep 20
}


# d'apres http://www.gnome.org/~federico/misc/git-cheat-sheet.txt
#function upload-varmada-to-svn() {
#    rm -rf ~/tmp/varmada.git
#    git clone --bare . ~/tmp/varmada.git ;
#    git --bare --git-dir=/home/benoit/tmp/varmada.git/  update-server-info ; 
#    chmod +x /home/benoit/tmp/varmada.git/hooks/post-update
#    rsync -av -e ssh  /home/benoit/tmp/varmada.git/ bcaron@svn.in.canoe.com:/home/bcaron/git
#}

function loadec2(){
    export EC2_PRIVATE_KEY=/home/benoit/Documents/Amazon/pk-x509.pem
    export EC2_CERT=/home/benoit/Documents/Amazon/cert-H7UMQIAQK6BM6WAMTPFYLTU6KXTDRP3R.pem
}

# vz
function getveth() {
perl -e ' printf qq(%x\n), $ARGV[0] ;' $1
}

# utilise ethereal pour figuer sur quel switchs on roule - source, Bruno
alias ethereal-switch-buster='sudo ethereal -i eth0 -V -f "ether host 01000ccccccc" -c 2'

#function uploadvm() {
#	echo "fixme ; ajouter check si existe"
#	echo "Upload de ${1} vers /home/vm sur Ghost..."
#	rsync -avz --delete -e ssh /var/images/$1 bcaron@ghost.internal.canoe.com:/home/vm/
#}

function cdrecordfull() {
	sudo cdrecord dev=1,0,0 $1
	eject
}

function backup_photos_vers_oreo() {
    echo "Rsync de mes photos vers Oreo..."
    rsync -va /home/benoit/Photos/ oreo.cookie:/home/photos/Photos/
}


#alias vpnstart="sudo openvpn --config /etc/openvpn/bcaron.ovpn"
#function start_vpn() {
#    sudo /etc/init.d/dnsmasq stop
#    sudo /etc/init.d/openvpn start
#}

function stop_vpn() {
    sudo /etc/init.d/openvpn stop
    sudo /etc/init.d/dnsmasq start
}

function dvdrecordfull() {
	sudo growisofs -dvd-compat -Z /dev/dvd=$1
	eject
}

function save_session_kde4() {
    dbus-send --dest=org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.saveCurrentSession
}

# import en renommant vers yyyy/mm/dd/yyyymmdd_hhmmss_origfilename-copynumber.extention
# voir http://www.sno.phy.queensu.ca/~phil/exiftool/filename.html 
function importphotos() {
    if [ -d $1 ] 
    then
        origdir=$PWD
        #exiftool -o -r -d /home/benoit/photos/%Y/%m/%d/%Y%m%d_%H%M%S_%%f-%%c.%%e "-filename<datefileoriginal" $1
        #cd /home/benoit/photos/
        pwd
        #exiftool -r -d %Y/%m/%d/%Y%m%d_%H%M%S_%%f-%%c.%%e "-filename<datefileoriginal" $origdir/$1
        #exiftool -r -d %Y/%m/%d/%Y%m%d_%H%M%S_%%f-%%c.%%e "-filename<datefileoriginal" $origdir/$1
        #exiftool -r '-FileName<datefileoriginal' -d %Y/%m/%d/%Y%m%d_%H%M%S_%%f%%-c.%%e $origdir/$1
        exiftool -r '-FileName<datefileoriginal' -d %Y/%m/%d/%Y%m%d_%H%M%S_%%f%%-c.%%e $1
        #exiftool -r -d %Y/%m/%d/%Y%m%d_%H%M%S_%%f-%%c.%%e "-filename<datefileoriginal" $origdir/$1
        #cd $origdir
        pwd
    else
        echo "Erreur, $1 n'existe pas!"
    fi
}

###########################3
## Pour aider a coder!

# Ajoute les fichiers aux tags pour VIM
# D'apres http://code.djangoproject.com/wiki/UsingVimWithDjango
function djangotagvim() {
         gvim "+cd $1" "+TlistAddFilesRecursive . [^_]*py\|*html\|*css" +TlistOpen
}


#httpd:b4t34u@sentinelle.tva.ca/opt/tva_medias/
#wrap-up autour de ssh
#function ssh(){
#    b4=`dcop $KONSOLE_DCOP_SESSION sessionName`
#    args=$#           # Number of args passed.
#    msg=${!args}
#    dcop $KONSOLE_DCOP_SESSION renameSession "ssh $msg"
#    /usr/bin/ssh $@
#    dcop $KONSOLE_DCOP_SESSION renameSession "$b4"
#}
alias metal='sshmetal '
function sshmetal() {
    myparams=' -l bcaron -p 22 '
    /usr/bin/ssh $myparams "metal-$@".pieix.in.canoe.com
}
function montest() {
	prevschema=`dcop $KONSOLE_DCOP_SESSION schema`
	dcop $KONSOLE_DCOP_SESSION setSchema DarkPicture.schema
	xssh fudgeeo fudgeeo
	dcop $KONSOLE_DCOP_SESSION setSchema "$prevschema"
}

function xmaison() {
    xhost +maison
 xssh maison -X notezbien.homeip.net
}
function maison() {
 #xssh maison -L 9143:192.168.1.50:143 maison
 xssh maison notezbien.homeip.net
}
function link() {
 xssh link -p 22222 bcaron@192.168.220.170
}
function linktunnel80() {
 sudoxssh link -p 22222 -L80:$1:80 bcaron@link.netgraphe.com
}
function linktunnel443() {
 sudoxssh link -p 22222 -L443:$1:443 bcaron@link.netgraphe.com
}

#
###
# ssh-agent - tire de Linux Server Hacks, #69
export SSH_ASKPASS=/usr/bin/ssh-askpass

if [ -f ~/.agent.env ]; then
  . ~/.agent.env -s > /dev/null

  if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
    echo
    echo "Stale agent file found.  Spawning new agent..."
    eval `ssh-agent -s | tee ~/.agent.env`
    ssh-add < /dev/null
  fi
else
  echo "Starting ssh-agent..."
  eval `ssh-agent -s | tee ~/.agent.env`
  ssh-add < /dev/null
fi


# obtenu de mon .bashrc de la maison
# If running interactively, then:
if [ "$PS1" ]; then

    # http://www.webupd8.org/2010/11/alternative-to-200-lines-kernel-patch.html
    #mkdir -p -m 0700 /dev/cgroup/cpu/user/$$ > /dev/null 2>&1
    #echo $$ > /dev/cgroup/cpu/user/$$/tasks
    #echo "1" > /dev/cgroup/cpu/user/$$/notify_on_release

    #http://www.ukuug.org/events/linux2003/papers/bash_tips/
    shopt -s histappend
    # voir ou on set PROMPT_COMMAND
    #PROMPT_COMMAND='history -a'

    # don't put duplicate lines in the history. See bash(1) for more options
    #export HISTCONTROL=ignoredups
    export HISTCONTROL=ignoreboth
    export HISTFILESIZE=5000
    export HISTSIZE=5000
    #export HISTIGNORE=ls
#    export HISTTIMEFORMAT=ls

    # enable color support of ls and also add handy aliases
    #eval `dircolors -b`
    #eval `dircolors -b $HOME/bin/colors.env`
    LS_COLORS='no=00:fi=00:di=01;36:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:';
    export LS_COLORS
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'

    # some more ls aliases
    alias ll='ls -l'
    alias la='ls -A'
    #alias l='ls -CF'
    alias l='ls -l'

    # Les alias de BEN
    alias oreo='ssh oreo'
    alias fudgee='ssh fudgee-o'

    # set a fancy prompt
    #PS1='\u@\h:\w\$ '
    # Add git curent branch
    PS1='\u@\h:\w$(__git_ps1 "(%s)") \$ '


    # If this is an xterm set the title to user@host:dir
    case $TERM in
    xterm*)
        PROMPT_COMMAND='history -a ; echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *)
        ;;
    esac

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc).
    if [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi


