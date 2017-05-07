# passpaperbak
Back Up and Restore UNIX Password-Store

## Description
passpaperbak enables an easy back-up of password-store on paper. Export your passwords as text or QR codes, print them and preserve them in a safe place.

In the case of loss of the genuine passwordfiles, scan the copys using OCR or the QR reader function of passpaperbak and the passwords will be restored automatically.

## Dependencies
passpaperbak depends on password-store, qrencode and zbar.

## Options
passpaperbak
	 -h: show this help
	 -i [FILE(S)]: import QR code(s) from file(s) into password-store
	 -t: export entries of password-store into unencrypted, seperate text files.
	 -T: export entries of password-store into one common, unencrypted text file.
	 -q: export entries of password-store to unencrypted QR codes.
