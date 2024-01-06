# Cisco IOU License Generator. Originally found at http://www.routingloops.co.uk/cisco/gns3-v1-1-install-on-ubuntu-14-04-lts/, I have done a few changes to it for python3. Make the file executable with " chmod +x ciscoIOUkeygen.py " and execute it " ./ciscoIOUkeygen.py ".

# Cisco SD-WAN_eve-ng

## Overview

#=================================================================================================
# :cloud: Eve-NG in Google Cloud :cloud:
Install Eve-NG in Gcp Cloud

#### Create a Googe Cloud account which will give you $300US free credit for a new starter
https://cloud.google.com/ 

* Log in to GCP
* Click `Go To Console`
* Click `Select a project`
* Click `New Project`
* Project name = `eve-ng` just edit the default name including the last code numbers its quite critical
* Click '`Create`

Click `Activate Cloud Shell` (top right toolbar) 

> Create the nested virtualization supported image based on `Ubuntu 20.04 LTS` 

gcloud config set project eve-ng-0697
gcloud services enable compute.googleapis.com --project=eve-ng-0697

https://console.developers.google.com/apis/api/networkmanagement.googleapis.com/overview?project=eve-ng-0697 

https://console.developers.google.com/apis/api/iap.googleapis.com/overview?project=eve-ng-0697

Paste the below into the cloud shell terminal: 

```gcloud compute images create eve-ng --source-image-project=ubuntu-os-cloud --source-image-family=ubuntu-2004-lts --licenses="https://www.google.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"```

Say `yes` if asked to enable API on project

* Click burger menu on the top left and select `Compute Engine > VM Instances`
* Or search for 'vm instances' in the serach field at the top of the dashboard 
* Select the project if asked
* Click `Create`

Enter the below properties. 

Name = `eve-ng` 
Region = `Choose location closest or cheaper for you`
Zone = `Choose location closest or cheaper for you`

> Choosing a region closer to you is better from a latency perspective. 
- `webpage that Google Cloud offers us: http://www.gcping.com/ ``
> Look at the estimated price on the left, prices varies across different regions.

> To run IOS-XR, IOS-XRV or CSR1000v increase the CPU’s and memory. 

* Firewall = `Allow HTTP traffic` 

* Click Done
* Click Create

#### Create Firewall rules
* Search for 'firewall' in the serach field at the top of the dashboard
- Step 1: Navigation menu/VPC Network/Firewall rules
- Step 2: Create new firewall rule
- Step 3: Create an ingress FW rule; allow TCP ports 0-65335
- Step 4: Create an egress FW rule; allow TCP ports 0-65535

#### Create GCP bucket
* Search for 'storage' in the serach field at the top of the dashboard
* Create a GCP bucket and upload the IOL images and script to generate the license key
* Important note - name the bucket whatever you want BUT the folder containing the images must be named 'images'. Else the eve-ng-init-setup.sh script will fail. Modify the paths in script if needed.

* Navigate back to `Compute Engine > VM Instances`
* Click on `SSH`
```
sudo -i
```
* Install Eve-NG `wget -O - https://www.eve-ng.net/focal/install-eve-pro.sh | bash -i`
> After install completes, reboot the VM. Reconnect - ctrl+c and enter sudo -i
> Set root password, hostname, DHCP, Internet connection direct.
```

sudo -i
15.uname -r
16.cd /boot/
ls
17.mkdir backup_cfg
18.ls -alh
19.mv *5.11.0-1026-gcp* ./backup_cfg/
19.mv *5.17.8-eve-ng-uksm-wg+* ./backup_cfg/
20.sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 noquiet"/' /etc/default/grub
21.update-grub
22.shutdown -r n

sudo -i

#### feel free to check below link for cloning

# Example Installation Steps
git clone https://github.com/ditiro1/SD-WAN.git
* git clone or copy the shell script to eve-ng 
Go the folder with shell script and execute: 
bash eveng-init-setup.sh <bucket-name> 
```
You could also make the script executeable - `chmod +x eveng-init-setup.sh` and run as `./eveng-init-setup.sh <bucket-name>`

cd /root
ls
ls -ltr 
touch eve-ng-init-setup.sh
touch eve-ng.sh
ls
chmod +x eve-ng-init-setup.sh
chmod +x eve-ng.sh
ls -l

nano eve-ng-init-setup.sh   # copy contents of `eve-ng-init-setup.sh` and run it, it will do the magic tricks for you, save time
nano eve-ng.sh              # copy contents of `eve-ng.sh` and run it, it will do the magic tricks for you, save time

./eve-ng-init-setup.sh        
./eve-ng.sh 

* Fix the permissions using the below command: 
`/opt/unetlab/wrappers/unl_wrapper -a fixpermissions`



* Browse to the web GUI with your instance's public IP address
