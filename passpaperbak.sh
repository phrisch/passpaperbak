#!/bin/bash
# passpaperbak
# 2017-05-06
# Simon Frisch <hallo@phrisch.de>
# exports password-store to QR code and text
# depends on qrencode, password-store

SCRIPTNAME=passpaperbak
PASSDIR=~/.password-store/
OUTPUTDIR=output/
OUTPUTFILE=password-store.bak.txt

# OPTIONS
OPT_i=0;OPT_t=0;OPT_T=0;OPT_q=0;

while getopts hi:tTq opt
do
case $opt in
	i) OPT_i=1 #import
		 INPUTFILE="$OPTARG";;
	t) OPT_t=1;; #export into separte textfiles
	T) OPT_T=1;; #export into common textfile
	q) OPT_q=1;; #export as QR codes
	*) echo "$SCRIPTNAME" # -h, help
		 echo -e "\t -h: show this help."
		 echo -e "\t -i [FILE(S)]: import QR code(s) from file(s) into password-store."
		 echo -e "\t -t: export entries of password-store into unencrypted, seperate text files."
		 echo -e "\t -T: export entries of password-store into one common, unencrypted text file."
		 echo -e "\t -q: export entries of password-store to unencrypted QR codes."
		;;
esac
done

# IMPORT
if [ $OPT_i -eq 1 ]
then
	echo Importing QR codes into password-store
	echo
	# import/recover passwords from QR codes into password-store
	zbarimg -q $INPUTFILE | sed s/QR-Code://g | bash
fi

# EXPORT
if [ $(( $OPT_t+$OPT_T+$OPT_q )) -ge 1 ]
then
	echo "Exporting from password-store:"
	echo -e "/!\\ \t All passwords are being exported without encryption."
	echo -e "\t Delete the export files immediately  after printing!"
	echo

	mkdir -p $OUTPUTDIR

	if [ $OPT_T -eq 1 ]
	then
		echo -e "# $(date)\n# For recovery\n#\t1) chmod +x <NAME OF THIS FILE>\n#\t2) ./<NAME OF THIS FILE>\n#" >> $OUTPUTDIR/"$OUTPUTFILE"
	fi
	#for entry in $(find $PASSDIR -name "*.gpg" -type f)
	find $PASSDIR -name "*.gpg" -type f -print0 | while IFS= read -r -d '' entry
	do
		# strip PASSDIR
		entry=$(echo $entry | sed s#$PASSDIR##g)
		
		# strip suffix
		entry=${entry%.*}

		# strip prefix
		entry=${entry#*/}

		# strip slashes in order to generate valid file name
		entryfile=$(echo $entry | sed s#/#_#g)

		# echo name/path of entry
		echo $entry

		if [ $OPT_t -eq 1 ]
		then
			# write password into single text files
			echo -e "pass insert -m $entry	<<cc\n$(pass show "$entry")\ncc" >> $OUTPUTDIR/"$entryfile".txt
		fi

		if [ $OPT_T -eq 1 ]
		then
			# write passwords into common text file
			echo -e "pass insert -m $entry	<<cc\n$(pass show "$entry")\ncc" >> $OUTPUTDIR/"$OUTPUTFILE"
			echo -e "#-----------------" >> $OUTPUTDIR/"$OUTPUTFILE"
		fi
			
		if [ $OPT_q -eq 1 ]
		then
			# save entry as QR code
			echo -e "pass insert -m $entry	<<cc\n$(pass show "$entry")\ncc" | qrencode -o $OUTPUTDIR/"$entryfile".png
		fi
	done
fi
