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
$(_magenta  "push_swap_guilletester "parser" Version 1.4 by gumoreno")


   Test if push_swap is handling input arguments correctly (based on how \"checher_linux\" does it).


   * How to use it:
	
	$(_yellow_bold "./push_swap_parser.sh")
			
   * You can use the following flags:

	$(_yellow "--only_failed")

   Enjoy it ;)

"
}

help(){
	echo -e "
$(_magenta  "push_swap_guilletester "parser" Version 1.4 by gumoreno")
	
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
	else
		make -C ../ > /dev/null
	fi
	$(mkdir -p ./temp)
	$(cp ../push_swap ./temp/)
}

ARG_ERROR=(	
	'./temp/push_swap "" ' 
	'./temp/push_swap "    "' 
	'./temp/push_swap 1 1 2 3 '
	'./temp/push_swap 0-0 1 2 '
	'./temp/push_swap 1+1 2 3 '
	'./temp/push_swap -1 -1 2 '
	'./temp/push_swap -1 -001 -2 '
	'./temp/push_swap ++1 +2 +3 '
	'./temp/push_swap --1 -2 -3 '
	'./temp/push_swap +-1 +2 -3 '
	'./temp/push_swap 1- 2 3 '
	'./temp/push_swap 1+ 2 3 '
	'./temp/push_swap 1a 2 3'
	'./temp/push_swap 1 2 3 a 4 5'
	'./temp/push_swap 1a23 '
	'./temp/push_swap 1a23 -42'
	'./temp/push_swap - 1 2 3  '
	'./temp/push_swap 2147483648  '
	'./temp/push_swap -2147483649  '
	'./temp/push_swap 18446744073709551616  '
	'./temp/push_swap 18446744073709551615 -42 '
	'./temp/push_swap 42 -18446744073709551615 '
	'./temp/push_swap 12345678912345  '
	'./temp/push_swap 0 12345678912345  '
	'./temp/push_swap hello world '
	'./temp/push_swap "hello world" '
	'./temp/push_swap hello '
	'./temp/push_swap "world" '
	'./temp/push_swap a  '
	'./temp/push_swap "a"  '
	'./temp/push_swap 0 a  '
	'./temp/push_swap -  '
	'./temp/push_swap +  '
	'./temp/push_swap +-  '
	'./temp/push_swap ++  '
	'./temp/push_swap --  '
	'./temp/push_swap   -"2"8 -28   "5 1" '
	'./temp/push_swap   -'"'"2"'"'8 -28   "5 1" '
	'./temp/push_swap "-1 2 3 " 4 5 "6 7 '"'"23"'"' 8" 9 '
	)

ARG_OK=(	
	'./temp/push_swap '
	'./temp/push_swap "1" '
	'./temp/push_swap "1 " '
	'./temp/push_swap " 1" '
	'./temp/push_swap " 1 " '
	'./temp/push_swap -1 2 3  '
	'./temp/push_swap " -1 2 +3  " '
	'./temp/push_swap "1 2 3" '
	'./temp/push_swap "1 2 3 " '
	'./temp/push_swap " 1 2 3" '
	'./temp/push_swap " 1 2 3 " '
	'./temp/push_swap "42 2 3 -42" '
	'./temp/push_swap " -1 2 3  " "41 42 43" '
	'./temp/push_swap "-1 2 3" "41 42 43 " "500 501 502" '
	'./temp/push_swap "-1 2 3" 41 42 43 "500 501 502" '
	'./temp/push_swap "-1 2 3" "500 501 502" 41 42 43 '
	'./temp/push_swap "-1 2 3 " 4 5 "6 7 8" 9 '
	'./temp/push_swap -0 '
	'./temp/push_swap +0 1 2 '
	'./temp/push_swap  -01 002 +00003  '
	'./temp/push_swap 000000000  '
	'./temp/push_swap -000000000  '
	'./temp/push_swap 00004200  '
	'./temp/push_swap -00004200  '
	'./temp/push_swap 00000000000000000000000000000000  '
	'./temp/push_swap -00000000000000000000000000000000  '
	'./temp/push_swap 000000000000000000000000000000009  '
	'./temp/push_swap -000000000000000000000000000000009 '
	'./temp/push_swap 2147483647 '
	'./temp/push_swap -2147483648 '
	'./temp/push_swap   '"'"'2 3 4 '"'"' 5 6 7 '"'"' 8 9 '"'"' '
	'./temp/push_swap   '"'"'2 3 4 '"'"' 5 6 7 " 8 9 " '
	'./temp/push_swap   -'"'"2"'"'8 -2 8  "35 100" '
	) 

check_parsing(){
	local PARSE_STATUS=1
	local FIRST_ERROR_FAILED=true
	local FIRST_OK_FAILED=true

	if [[ $ONLY_FAILED = false ]]; then
			echo -e $(_cian "Wrong args check (output should be \"Error\"):")"\n"
	fi
	for arg in "${ARG_ERROR[@]}"; do
 		OUTPUT=$(eval "$arg" 2>&1)
		if ! [[ "$OUTPUT" = "Error"* ]]; then
			if [[ $FIRST_ERROR_FAILED = true  && $ONLY_FAILED = true ]]; then
				echo -e $(_cian "Wrong args check (output should be \"Error\"):")"\n"
				FIRST_ERROR_FAILED=false
			fi
			echo -e $(_red " ✘ ")"."${arg:6}
			# echo -e  "\t\t" {"$OUTPUT"}"  "
			PARSE_STATUS=0;
		elif [ $ONLY_FAILED = false ]; then
			echo -e $(_green " ✔ ")"."${arg:6}
			# echo -e  "\t\t" {"$OUTPUT"}"  "
		fi
    done
	if [[ $ONLY_FAILED = true && $FIRST_ERROR_FAILED = false ]]; then
			echo -e 
	fi
	if [[ $ONLY_FAILED = false ]]; then
			echo -e "\n"$(_cian "Valid args check (output should not be \"Error\"):")"\n"
	fi
	for arg in "${ARG_OK[@]}"; do
 		OUTPUT=$(eval $arg 2>&1)
		if [[ "$OUTPUT" = "Error"* ]]; then
			if [[ $FIRST_OK_FAILED = true && $ONLY_FAILED = true ]]; then
				echo -e $(_cian "Valid args check (output should not be \"Error\"):")"\n"
				FIRST_OK_FAILED=false
			fi
			echo -e $(_red " ✘ ")"."${arg:6}
			# echo -e  "\t\t" {"$OUTPUT"}"  "
			PARSE_STATUS=0;
		elif [ $ONLY_FAILED = false ]; then
			echo -e $(_green " ✔ ")"."${arg:6}
			# echo -e  "\t\t" {"$OUTPUT"}"  "
		fi
    done
	if [[ $PARSE_STATUS = 1 && $ONLY_FAILED = true ]]; then
		echo -e $(_green " ✔ ")" Parsing: OK    "
	fi
	echo -e 
	if [[ $ONLY_FAILED = true && $FIRST_OK_FAILED = true && $PARSE_STATUS = 0 ]]; then
		echo -e "\033[1A\033[1A"
	fi
}

parsing(){
	if [ "$1" = "--help" ]; then
		info
		exit 0
	fi
	if ! [[ "$1" = "--only_failed" || -z "$1" ]]; then
		help
		exit 1
	fi
}

init(){
	ONLY_FAILED=false
	if [ "$1" = "--only_failed" ]; then
		ONLY_FAILED=true
	fi
	tput civis
	trap 'tput cnorm; rm -r temp;' INT TERM 
	trap 'tput cnorm; rm -r temp; exit;' EXIT
}

parsing "$@"
init "$@"
echo -e "\n"$(_blue "PARSING TEST - PUSH_SWAP")"\n"
handle_exec
check_parsing
exit 0