OpenVZ Script to automate the creation of container through the command line
----------------------------------------------------------------------------

<strike>This script has only one purpose, it is to help me create my OpenVZ containers.</strike>
<del>Since I use OpenVZ to create development servers I use a predefined amount of RAM
for my servers. The script could be modified in such a way that we could specified
this amount of RAM through the command line. I will probably end up doing it later.</del>
I did add some support for the RAM, check the usage #6.

This script now help me to define some alias shortcuts to manage my OpenVZ server.

#Installation
Include the bash script in your .bashrc file
	source /path/to/openvztools.sh

or 

Copy the script in your .bashrc file and then execute the command
	source ~/.bashrc

#Usage
1. Stop multiple containers<br/>
	vzstop 101 102 103
    
2. Start multiple containers<br/>
	vzstart 101 102 103
    
3. Destroy multiple containers<br/>
	vzdestroy 101 102
    
4. List all the containers even stopped one<br/>
	vzlist
    
5. Modify the DNS server of the VPS
    vzadddns 101 8.8.8.8
    
6. Create a container with specific amount of RAM
    vzcreate 101 'centos-6' '192.168.1.101' 1024 2048 centos-6-x86
    
7. Create a container with default RAM settings
    vzcreate 101 'centos-6' '192.168.1.101' centos-6-x86