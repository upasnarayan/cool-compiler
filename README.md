cool-compiler
=============

Complete compiler in C++ for the COOL programming language.



##Installation

- Install packages:
`sudo apt-get install flex bison build-essential csh openjdk-6-jdk libxaw7-dev`

- Clone repo:
`git clone https://github.com/upasnarayan/cool-compiler.git`

- Add the bin directory to your $PATH environment variable. If you are using
bash, add to your .profile (or .bash_profile, etc. depending on your
configuration; note that in Ubuntu have to log out and back in for this to 
take effect): 
`PATH=$$REPO_DIR$$/bin:$PATH`

##Usage

Code for the lexer (regexp) can be found at `assignments/PA2/cool.flex`, and code for the parser (CFG rules) can be found at `assignments/PA3/cool.y`. Test the lexer and parser as follows:


    cd assignments/PA2
    make lexer
    ./lexer file.cl

##

    cd assignments/PA3
    make lexer parser
    ./parser file.cl
