cool-compiler
=============

Complete compiler for the COOL programming language.


Steps:

Install packages:
sudo apt-get install flex bison build-essential csh openjdk-6-jdk libxaw7-dev

Clone repo:
git clone https://github.com/upasnarayan/cool-compiler.git

Add the bin directory to your $PATH environment variable. If you are using
bash, add to your .profile (or .bash_profile, etc. depending on your
configuration; note that in Ubuntu have to log out and back in for this to 
take effect):
PATH=/usr/class/cs143/cool/bin:$PATH

Test the lexer and parser as follows:

cd assignments/PA2
make lexer
./lexer file.cl

cd assignments/PA3
make lexer parser
./parser file.cl

