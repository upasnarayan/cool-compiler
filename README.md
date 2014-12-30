cool-compiler
=============

Complete compiler in C++ for the COOL programming language. Stanford CS143 Compilers MOOC.



##Installation

- Install packages:
`sudo apt-get install flex bison build-essential csh openjdk-6-jdk libxaw7-dev`

- Clone repo: `git clone https://github.com/upasnarayan/cool-compiler.git`

- Setup spim MIPS simulator:
    ```
    sudo -p mkdir /usr/class/cs143/cool/lib
    sudo cp lib/trap.handler /usr/class/cs143/cool/lib/trap.handler
    ```

- Add the bin directory to your $PATH environment variable. If you are using
bash, add to your .profile (or .bash_profile, etc. depending on your
configuration; note that in Ubuntu have to log out and back in for this to 
take effect): 
`PATH=$$REPO_DIR$$/bin:$PATH`. For example, if the repo has been cloned in the home directory, add `PATH=$HOME/cool-compiler/bin:$PATH`.

##Usage

Code for the lexer (regexp) can be found at `assignments/PA2/cool.flex`, and code for the parser (CFG rules) can be found at `assignments/PA3/cool.y`. Test the lexer and parser as follows:


    cd assignments/PA2
    make lexer
    ./lexer file.cl

##

    cd assignments/PA3
    make lexer parser
    ./parser file.cl
