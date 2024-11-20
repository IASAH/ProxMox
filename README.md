# Proxmox VM Tasks
This is a Collection of scripts that helps to automate some tasks in proxmox such as.
  - vmdk conversion to raw or vis versa
  - importing virtual disk to virtual machine 
  - importing ovf file and creat VM
you can use it directly in terminal with only the 3 script files that has ".sh" or in Web UI
  1- downloading all the files in the server with "git clone https://github.com/IASAH/Proxmox-VM-Tasks.git".
  2- cd into the folder by "cd Proxmox-VM-Tasks".
  3- change the "install.sh" to be executable "chmod +x install.sh".
  4- install the dependancies with "./install.sh".
  5- run the program with python3 "python3 app.py".
it will give you a link like this "http://Server-IP.5000" you should be able to open it in your browser.

***NOTE***
* This program requires Python3 , PIP , FLASK to run the Web UI.
* The scripts.sh does not require anything either than Proxmox server or KVM to be installed on that machine.
* It runs on the files that in the KVM/Proxmox server it is not converting files at your local computer.
* Python3 is mandatory while PIP / FLASK will be installed automatically if the program didn't find them.
