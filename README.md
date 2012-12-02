OpenVZ Script to automate the creation of container through the command line
----------------------------------------------------------------------------

This script has only one purpose, it is to help me create my OpenVZ containers.
This script defines some alias shortcuts to manage my OpenVZ server as well.
<del>Since I use OpenVZ to create development servers I use a predefined amount of RAM
for my servers. The script could be modified in such a way that we could specified
this amount of RAM through the command line. I will probably end up doing it later.</del>
I did add some support for the RAM, check the usage #6.


<br />
<br />
#Installation
Include the bash script in your .bashrc file
    <pre>
        <code>
        source /path/to/openvztools.sh
        </code>
    </pre>

or 

Copy the script in your .bashrc file and then execute the command
    <pre>
        <code>
        source ~/.bashrc
        </code>
    </pre>

#Usage
1. Stop multiple containers
    <pre>
        <code>
        vzstop 101 102 103
        </code>
    </pre>
    
2. Start multiple containers
    <pre>
        <code>
        vzstart 101 102 103
        </code>
    </pre>
    
3. Destroy multiple containers
    <pre>
        <code>
        vzdestroy 101 102
        </code>
    </pre>
    
4. List all the containers even stopped one
    <pre>
        <code>
        vzlist
        </code>
    </pre>
    
5. Modify the DNS server of the VPS
    <pre>
        <code>
        vzadddns 101 8.8.8.8
        </code>
    </pre>
    
6. Create a container with specific amount of RAM
    <pre>
        <code>
        vzcreate 101 'centos-6' '192.168.1.101' 1024 2048 centos-6-x86
        </code>
    </pre>
    
7. Create a container with default RAM settings
    <pre>
        <code>
        vzcreate 101 'centos-6' '192.168.1.101' centos-6-x86
        </code>
    </pre>
    
8. Modify the hostname of a container
    <pre>
        <code>
        vzhostname 101 'test.example.com'
        </code>
    </pre>

9. Specify a default nameserver other than 8.8.8.8
    <pre>
        <code>
        # Set the environment variable DEFAULT_NAMESERVER to the ip of
        # the DNS server of your choice
        echo 'export DEFAULT_NAMESERVER="192.168.1.254"' >> ~/.bashrc
        source ~/.bashrc
        </code>
    </pre>
    
10. Create a dump of your OpenVZ container
    You MUST have '''vzdump''' installed first.
    <pre>
        <code>        
        # Single container
        vzcreatedump 101
        
        # Multiple container
        vzcreatedump 101 102 103
        </code>
    </pre>
