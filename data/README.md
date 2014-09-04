Financial data used in the reseach
===================================

In this folder you can find all the public data sets used in this
research. Most of the data is in csv format and I highly recommend (if
you have sql skills) installing and using
[textql](https://github.com/dinedal/textql). Normally I include the
somehow processed data from the original data sources. To recognize each
one you can follow the next rules:

 * The original data source is the name of the index followed by the
   time span measured and with a '-full' at the end of the filename
(full meaning the entire data).
 * The modified data is the same name of the original data source
   replacing '-full' with the modification made to the data.

Installation instructions of textql in MacOSX 10.9.x
------------------------------------------------------

Your're going to need the next things:

 * Brew
 * Go
 * Git
 * Mercurial (optional)

For brew install check http://brew.sh/. Next steps:

    brew update && brew upgrade
    brew install go
    brew install git
    brew install mercurial
    mkdir $HOME/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    mkdir -p $GOPATH/src/github.com/ 

Now, install textql:

    export CC=clang
    go get -u github.com/dinedal/textql

If you're going to play with go, install gotour:

    go get code.google.com/p/go-tour/gotour
    gotour

