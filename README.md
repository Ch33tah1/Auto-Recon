# Auto-Recon by Ch33tah1
Auto-Recon is a tool written in bash and designated to ease the job for pen-testers at the Web-App-Reconnaissance stage.
This tool is running a comprehensive search to enumerate subdomains with a given $url.
Some of the tools are passive while others are more active. Don't worry, you will be asked whether you'd like to go more active or not.

Passive recon – Not including engaement with the given domain.

Active recon – Including engaement with the given domain.

# # NOTICE # #
In order to use this tool, you have to make sure the next tools are pre-installed on your machine:

1. sublist3r || **passive** || Fast passive subdomain enumeration tool.
   Link to install here - https://github.com/aboul3la/Sublist3r

2. subfinder || **passive** || Fast passive subdomain enumeration tool.
   Link to install here - https://github.com/projectdiscovery/subfinder

3. amass || **passive** || The OWASP Amass Project performs network mapping of attack surfaces and external asset     discovery using open source information gathering and active reconnaissance techniques. In this tool we will       use a particular flag for our spesific purpose. This tool has given 7 minutes timeout but you can change it as     you see fit, depends on how big is the given url.
   Link to install here - https://github.com/owasp-amass/amass

4. assetfinder || **passive** || Find domains and subdomains potentially related to a given domain.
   Link to install here - https://github.com/tomnomnom/assetfinder

5. httprobe || **passive** || Receives a list of domains and probe for working http and https servers.
   Link to install here - https://github.com/tomnomnom/httprobe

6. gowitness || **passive** || A golang, web screenshot utility using Chrome Headless, to give you a prespective      of how each page looks like.
   Link to install here - https://github.com/sensepost/gowitness

7. dirsearch || **active** || Web path brute-forcing and directory enumeration of websites.
   Link to install here - https://github.com/maurosoria/dirsearch

8. nuclei || **active** || Vulnerability scanner based on simple YAML based DSL.
   Link to install here - https://github.com/projectdiscovery/nuclei

Now go make yourself a coffee until the run is over :)
