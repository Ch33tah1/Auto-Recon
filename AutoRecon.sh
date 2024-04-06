#!/bin/bash
# User Input - Domain name.
# Tool's Output - A list of Subdomains.

BOLD_GREEN="\033[1;32m"
BOLD_RED="\033[1;31m"
BOLD_BLUE="\033[1;34m"
RESET="\033[0m"
echo -e "${BOLD_GREEN}
+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +

       =        = =     = =  = = = = = = = =  = = = = = =
      = =       = =     = =  = = = = = = = =  = = = = = =
     = = =      = =     = =       = =         = =     = =
    = = = =     = =     = =       = =         = =     = =
   = =   = =    = =     = =       = =         = =     = =
  = = = = = =   = =     = =       = =         = =     = =
 = =       = =  = = = = = =       = =         = = = = = =
= =         = =  = = = = =        = =         = = = = = =


         = = = = = =   = = = = = =    = = = = =   = = = = = =  = =       = =
         = = = = = =   = = = = = =   = = = = =    = = = = = =  = = =     = =
         = =       =   = =          = =           = =     = =  = =  =    = =
         = = = = = =   = = = = = =  = =           = =     = =  = =   =   = =
         = = = =       = = = = = =  = =           = =     = =  = =    =  = =
         = =   = =     = =           = =          = =     = =  = =     = = =
         = =    = =    = = = = = =    = = = = =   = = = = = =  = =      = = =
         = =      = =  = = = = = =     = = = = =  = = = = = =  = =       = =

                                                                     V 3.0.1

+ + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
${RESET}"


url=$1
if [ ! -d "$url" ];then
    mkdir $url
fi

if [ ! -d "$url/recon" ]; then
        mkdir $url/recon
fi

cd $url/recon
#-----------------------------------------------------------------------------------
# ** Passive RECON **
#-----------------------------------------------------------------------------------
#1 - Sublist3r
echo -e "${BOLD_RED}[+] Starting Passive Enumeration of subdomains for $url ${RESET}"
echo -e "${BOLD_RED}[+] Running Sublist3r...${RESET}"
sublist3r -d $url -o $url-sublist3r.txt > /dev/null
#-----------------------------------------------------------------------------------
#2 - Subfinder
echo -e "${BOLD_RED}[+] Running Subfinder...${RESET}"
subfinder -d $url -o $url-subfinder.txt 2> /dev/null
#-----------------------------------------------------------------------------------
#3 - Amass
echo -e "${BOLD_RED}[+] Running subdomains with Amass...give it few minutes..${RESET}"
amass enum -passive -d "$url" -timeout 7 > amass.txt 2> /dev/null
cat amass.txt | grep FQDN | awk '{print $1;}' | sort | uniq > $url-Amass.txt
rm amass.txt
echo -e "${BOLD_GREEN}[+] Enumeration From Amass Saved in:\n$url/recon/$url-Amass.txt.${RESET}"
#-----------------------------------------------------------------------------------
#4 - Assetfinder
echo -e "${BOLD_RED}[+] Running subdomains with Assetfinder...${RESET}"
assetfinder --subs-only $url >> $url-assetfinder.txt
#-----------------------------------------------------------------------------------
#MERGE & SORT & UNIQ- Removes consecutive duplicate lines, ignoring differences in case.
cat $url-sublist3r.txt >> temp_subdomains.txt && cat $url-subfinder.txt >> temp_subdomains.txt && cat $url-Amass.txt >> temp_subdomains.txt && cat $url-assetfinder.txt >> temp_subdomains.txt
cat temp_subdomains.txt | sort | uniq -i > $url-all-subdomains.txt
rm temp_subdomains.txt
echo -e "${BOLD_GREEN}[+] The sorted list of subdomains can be found here:\n$url/recon/$url-all-subdomains.txt ${RESET}"
#-----------------------------------------------------------------------------------
# Unsorted results saved in a designated dir:
if [ ! -d "$url/recon/All-Subdomains" ]; then
        mkdir All-Subdomains
        chmod 777 All-Subdomains
else
        echo "Directory already exists: $url/recon/All-Subdomains"
fi

mv $url-sublist3r.txt $url-subfinder.txt $url-Amass.txt $url-assetfinder.txt All-Subdomains
echo -e "${BOLD_BLUE}[+] If you wish to see the full results by each search you can go to:\n$url/recon/All-Subdomains. ${RESET}"
#-----------------------------------------------------------------------------------
#5 - HTTProbe
echo -e "${BOLD_RED}[+] Probing for HTTP/HTTPS servers with httprobe...${RESET}"
cat $url-all-subdomains.txt | httprobe | sort | uniq >> httprobe.txt
echo -e "${BOLD_GREEN}[+] The sorted list of subdomains that responsed to HTTPROBE can be found here:\n$url/recon/$url-httprobe.txt ${RESET}"
#-----------------------------------------------------------------------------------
#6 - GoWitness
if [ ! -d "$url/recon/screenshots" ]; then
        mkdir screenshots
        chmod 777 screenshots
fi

echo -e "${BOLD_RED}[+] Enumerating via GoWitness so you could explore them visually... ${RESET}"
gowitness file -f $url-httprobe.txt > /dev/null

echo -e "${BOLD_GREEN}[+] The Screenshots are saved in:\n$url/recon/screenshots . Enjoy! ${RESET}"
#-----------------------------------------------------------------------------------
# ** Active RECON **
#-----------------------------------------------------------------------------------
#7 - Dirsearch
echo -e "${BOLD_RED}Do you want to go more active and run Dirsearch.py? dont be a pussy..(yes/no):${RESET}"
read answer
answer_lower=$(echo "$answer" | tr "[:upper:]" "[:lower:]")

if [[ "$answer_lower" = "yes" || "$answer_lower" = "y" ]]; then
        echo -e "${BOLD_GREEN}You Got it! Great choice..${RESET}"
        echo -e "${BOLD_RED}[+] Enumerating via Dirsearch.py...${RESET}"
        dirsearch.py -u "https://$url" -e "asp,aspx,htm,html,log,php,sql,txt,xml,/,js" -o "$url-dirsearch.txt"
        echo -e "${BOLD_GREEN}[+] The output is saved in:\n$url/recon/$url-dirsearch.txt . Enjoy! ${RESET}"
elif [[ "$answer_lower" = "no" || "$answer_lower" = "n" ]]; then
        echo -e "${BOLD_RED}Pussy is a pussy is a pussy...${RESET}"
        continue
else
        echo -e "${BOLD_RED}Invalid input. Please enter "yes" or "no".${RESET}"
fi
#-----------------------------------------------------------------------------------
#8 - Nuclei
echo -e "${BOLD_RED}How about Nuclei? (yes/no):${RESET}"
read answer
answer_lower=$(echo "$answer" | tr "[:upper]" "[:lower]")

if [[ "$answer_lower" = "yes" || "$answer_lower" = "y" ]]; then
        echo -e "${BOLD_GREEN}You Got it! Great choice..${RESET}"
        echo -e "${BOLD_RED}[+] Enumerating via Nuclei...${RESET}"
        nuclei -header "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.3945.88 Safari/537.36" -u "https://$url" -o "nuclei-output.txt"
        echo -e "${BOLD_GREEN}[+] The output is saved in:\n$url/recon/nuclei-output.txt . Enjoy!${RESET}"
elif [[ "$answer_lower" = "no" || "$answer_lower" = "n" ]]; then
        echo -e "${BOLD_RED}Pussy is a pussy is a pussy...${RESET}"
        continue
else
        echo -e "${BOLD_RED}Invalid input. Please enter yes or no.${RESET}"
fi
#-----------------------------------------------------------------------------------
# ** Auto-Recon is Done **
echo -e "${BOLD_BLUE} [!] AUTO-RECON IS DONE. DO NOT LOOK BACK. GOOD LUCK.${RESET}"
#[-]
#[+]
#[!]
