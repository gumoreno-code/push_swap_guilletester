#!/bin/bash

__nc()      	{ echo -e "\033[0m"; }
_red()      	{ echo -ne "\033[31m""$1"$(__nc); }
_green()   		{ echo -ne "\033[32m""$1"$(__nc); }
_yellow()		{ echo -ne "\033[33m""$1"$(__nc); }
_yellow_bold()  { echo -ne "\033[1;33m""$1"$(__nc); }
_blue()     	{ echo -ne "\033[34m""$1"$(__nc); }
_magenta()     	{ echo -ne "\033[35m""$1"$(__nc); }
_cian()     	{ echo -ne "\033[36m""$1"$(__nc); }

info(){
	tput cnorm
	echo -e "
$(_magenta  "push_swap_guilletester "eval" Version 1.4 by gumoreno")


   A battery of different tests will be run on your push_swap project.
   

   * How to use it:
	
	$(_yellow_bold "./push_swap_eval.sh")\t--> tester will be executed in normal mode
			
   * You can use the following flags:

	$(_yellow "--lite")
	
	$(_yellow  "--log")

	$(_yellow  "--lite_log")

	$(_yellow  "--silent")

   Enjoy it ;)

"
}

help(){
	echo -e "
$(_magenta  "push_swap_guilletester "eval" Version 1.4 by gumoreno")
	
	$(_yellow  "--help")
	"
}

handle_exec(){
	if [ ! -r ../push_swap ]; then
		if [ ! -r ../Makefile ]; then
			echo -e " your Makefile is missing...\n"
			exit 1
		fi
		echo -e "  executing your Makefile..."
		echo -e "\033[1A\033[1A"
		make -C ../ re > /dev/null
		echo -e "          ready!!               "
		sleep 1
		echo -e "\033[1A\033[1A"
		echo -e "                          "
		echo -e "\033[1A\033[1A"
	else
		make -C ../ > /dev/null
	fi
}

parsing(){
	if [ "$1" = "--help" ]; then
		info
		exit 0
	fi
	if ! [[ "$1" = "--silent" || "$1" = "--lite" || "$1" = "--lite_log" || "$1" = "--log" || -z "$1" ]]; then
		help
		exit 1
	fi
}

check_norminette(){
	local NORM=true

	if ! which norminette &> /dev/null ; then
		echo -e "\n\n Ooops... Norminette is not installed!! :(\n"
	else
		mkdir -p temp
		norminette ../ > temp/norminette_output.txt
		while IFS= read -r line
		do
			if [[ "$line" != *": OK!" ]]; then
				NORM=false
			fi
		done < temp/norminette_output.txt 
		if [ $NORM = true ]; then
			echo -e "\n\n"$(_green " ✔ ")" Norminette: OK\n"
		else 
			echo -e "\n\n"$(_red " ✘ ")" Norminette: failed\n"
		fi
	fi

}

init(){
	tput civis
	trap 'tput cnorm; rm -rf temp; exit 1;' INT TERM 
	trap 'tput cnorm; rm -rf temp; exit;' EXIT
}

parsing "$@"
init "$@"
clear
echo -e "\n"$(_blue "  EVALUATION TEST - PUSH_SWAP")"\n"
handle_exec
echo -e "\n"$(_yellow     "---------  Norminette  --------")
check_norminette
echo -e "\n"$(_yellow     "------  ARG Parsing test  -----")
./push_swap_parser.sh --only_failed | sed '2d'
echo -e 
if [ "$1" = "--lite" ]; then
	echo -e $(_yellow "-------------  3  -------------")
	./push_swap_tester.sh 3 20
	echo -e $(_yellow "-------------  5  -------------")
	./push_swap_tester.sh 5 30  
	echo -e $(_yellow "------------  100  ------------")
	./push_swap_tester.sh 100 30
	echo -e $(_yellow "------------  500  ------------")
	./push_swap_tester.sh 500 5
	echo -e $(_yellow "---------  500 strict  --------")
	./push_swap_tester.sh --strict
elif [ "$1" = "--lite_log" ]; then
	echo -e $(_yellow "-------------  3  -------------")
	./push_swap_tester.sh 3 20 --log
	echo -e $(_yellow "-------------  5  -------------")
	./push_swap_tester.sh 5 30 --log  
	echo -e $(_yellow "------------  100  ------------")
	./push_swap_tester.sh 100 30 --log
	echo -e $(_yellow "------------  500  ------------")
	./push_swap_tester.sh 500 5 --log
	echo -e $(_yellow "---------  500 strict  --------")
	./push_swap_tester.sh --strict --log
elif [ "$1" = "--silent" ]; then
	echo -e $(_yellow "-------------  3  -------------")
	./push_swap_tester.sh 3 50 --silent
	echo -e $(_yellow "-------------  5  -------------")
	./push_swap_tester.sh 5 100 --silent 
	echo -e $(_yellow "------------  100  ------------")
	./push_swap_tester.sh 100 200 --silent
	echo -e $(_yellow "------------  500  ------------")
	./push_swap_tester.sh 500 50 --silent
	echo -e $(_yellow "---------  500 strict  --------")
	./push_swap_tester.sh --strict --silent
elif [ "$1" = "--log" ]; then
	echo -e $(_yellow "-------------  3  -------------")
	./push_swap_tester.sh 3 50 --log
	echo -e $(_yellow "-------------  5  -------------")
	./push_swap_tester.sh 5 100 --log
	echo -e $(_yellow "------------  100  ------------")
	./push_swap_tester.sh 100 200 --log
	echo -e $(_yellow "------------  500  ------------")
	./push_swap_tester.sh 500 50 --log
	echo -e $(_yellow "---------  500 strict  --------")
	./push_swap_tester.sh --strict --log
else
	echo -e $(_yellow "-------------  3  -------------")
	./push_swap_tester.sh 3 50 
	echo -e $(_yellow "-------------  5  -------------")
	./push_swap_tester.sh 5 100  
	echo -e $(_yellow "------------  100  ------------")
	./push_swap_tester.sh 100 200
	echo -e $(_yellow "------------  500  ------------")
	./push_swap_tester.sh 500 50
	echo -e $(_yellow "---------  500 strict  --------")
	./push_swap_tester.sh --strict
fi
exit 0