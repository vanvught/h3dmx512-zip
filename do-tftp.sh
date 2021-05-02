#!/bin/bash

echo '!tftp#1' | nc -u -p 10501 -w 1 $1 10501
echo '?tftp#' | nc -u -p 10501 -w 1 $1 10501

#cp orangepi_zero.uImage.gz orangepi_zero.uImage

if [ -f "orangepi_zero.uImage.gz" ]; then

tftp $1 << -EOF
binary
put orangepi_zero.uImage.gz
quit
-EOF

else

tftp $1 << -EOF
binary
put orangepi_zero.uImage
quit
-EOF

fi

echo '!tftp#0' | nc -u -p 10501 -w 1 $1 10501
echo '?tftp#' | nc -u -p 10501 -w 1 $1 10501
echo -e "\e[34mRebooting...\e[0m"
echo '?reboot##' | nc -u -p 10501 -w 1 $1 10501

ON_LINE=$(echo '?list#' | nc -u -p 10501 -w 1 $1 10501) || true

while  [ "$ON_LINE" == "" ]
 do
  ON_LINE=$(echo '?list#' | nc -u -p 10501 -w 1 $1 10501)  || true
done

echo -e "\e[36m[$ON_LINE]\e[0m"
echo -e "\e[36m$(echo '?version#' | nc -u -p 10501 -w 1 $1 10501)\e[0m"
