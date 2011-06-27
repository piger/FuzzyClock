======================================================
FuzzyClock: Un orologio approssimativo e coatto in zsh
======================================================

Questo script zsh_ mostra l'ora attuale *approssimata a parole* in dialetto
romanaccio, ad esempio ``l'unnici evventi``; e' pensato per essere incluso
nella configurazione di un terminal multiplexer come screen_ o tmux_ per
sostituire la solita noiosa ora attuale con qualcosa di piu' simpatico.

Il funzionamento e' ispirato a quello di altri due software simili: fuzzy-clock_ e FuzzyClock_.

Other Languages (English)
-------------------------
This script can be easily translated in other languages; just edit the content
of the following arrays: **nomiMinuti** (minute), **nomiOre** (hour),
**giornata** and **settimana**.

Example translation in english language:

::

    nomiMinuti=(
        "%0 o'clock"
        "five past %0"
        "ten past %0"
        ...


Configurazione per tmux
-----------------------

::

    # right status bar (256 colors)
    set -g status-right "#[fg=green,bold]#($HOME/bin/fuzzyclock.zsh)#[default]"

Configurazione per screen
-------------------------

::

    caption always "%-Lw%{= BW}%50>%n%f* %t%{-}%+Lw%<"
    hardstatus alwayslastline
    hardstatus string '%H - %=%D %d %M %Y, %10`'

    backtick 10 	60	60		$HOME/bin/fuzzyclock.zsh

License
-------
Public domain.

.. _zsh: http://zsh.sourceforge.net/
.. _screen: http://www.gnu.org/software/screen/
.. _tmux: http://tmux.sourceforge.net/
.. _fuzzy-clock: http://code.google.com/p/fuzzy-clock/
.. _FuzzyClock: http://www.objectpark.org/FuzzyClock.html
