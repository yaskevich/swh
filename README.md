# swhtrans
##Swahili transcripting tool
###Simple tool for transcripting Swahili texts into IPA-based or Cyrillic presenatation.
Argument 1: path to file to process.

Argument 2: Cyrillic flag (any char)

Without arguments, demo-mode: built-in text is transcripted in Latin-based alphabet

File `about.txt` is just text from Swahili page about Swahili itself: https://sw.wikipedia.org/wiki/Kiswahili. Use it for tests.

File `swh-abc.json` contains Swahili alphabeth and appropriate transcripting rules for Roman/IPA-based transcription and for Cyrillic-based one.

###Dependencies
* Perl. Any version, any OS. Probably, you have it, if you are not on *nix, then try [Strawberry Perl](http://strawberryperl.com/).

* JSON.pm.
On Debian-based distros just do `apt-get install libjson-perl` or simply `cpan JSON`. The latter also works on OS X, or one can use for some reasons [Perlbrew](http://perlbrew.pl/) – if one's going to really deal with Perl.
