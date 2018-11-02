# TheAPP: some approaches from SRE/Systems Engineer  side to resolve a common challenge.

## Disclamer
This solution is under construction yet, but PR and comments are
welcome and really appreciate.

## Reasons
The details of the challenge are in the following link:
https://github.com/wuakitv/sysadmin-challenge/blob/master/README.md

## Requeriments
* [**VirtualBox** >= 5.2.10](https://www.virtualbox.org/)
* [**Vagrant** >= 2.1.1](https://www.vagrantup.com/)

## Installation for Ubuntu Users based on LTS flavours
For installing Virtualbox you need type in the Linux console the following commands as user with root privileges
```
apt-get update
apt-get install virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-additions-iso
```

For installing Vagrant you need type in your Linux console the following commands as user with root privileges
```
wget https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.deb
dpkg -i vagrant_2.1.1_x86_64.deb
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vbguest
```

## Installation for OSX Users
1. Download the Oracle/Hashicorp required packages:

    - Virtualbox 5.0.40 from http://download.virtualbox.org/virtualbox/5.2.10/VirtualBox-5.2.10-122088-OSX.dmg
    - VirtualBox Extension Package from: http://download.virtualbox.org/virtualbox/5.2.10/Oracle_VM_VirtualBox_Extension_Pack-5.2.10.vbox-extpack
    - Vagrant from Hashicorp: https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.dmg

2. Setup:

    - Install first the virtualbox DMG file following the steps that will appears in the GUI wizard.
    - When the VirtualBox setup ends, the extensions file will be associated directly with the new Virtualbox application and then a double-click over it will be enough to lets start the extension pack installation.
    - Install Vagrant DMG using their wizard.
    - When the Vagrant setup ends, open a Terminal and type the following commands:

          vagrant plugin install vagrant-share
          vagrant plugin install vagrant-vbguest

## What's an approach?
I slipt across  several "approaches" for the challenge using for each one
a different architecture and tools, each one might being saw in the
real world. That means each approach is a different implementation
to resolve the same problem, with itself strengths and weakness.

  * On **Approach** 0 is showed a simple VM provisioning a classic
  stack NGINX+THEAPP+MYSQL.
  * On **Approach 1** we can find a docker-compose stack.
  * On **Approach 2** a Docker Swarm stack with several services deployed with
  autohealing,scale-up and scale-down capabilities, in addition load balancers throught
   `overlay` networks.
  * The **Approach 3** is a fully and modern infrastructure in AWS using ECS + RDS,
  provisoned with Terraform on-the-fly and with Autoscaling Up/Down with Zero
    Downtime.


## Motivations and KeyWords
For each approach you can see the evolution in the architectures and some tools and best practices
like:

* **Automation**: I used Ansible for everything in the Vagrant side and Terraform for AWS.
* **Docker Friendly**: Docker is first of all a package system to delivery our applications, likewise docker is very flexible and sometimes is not used in the correct way, I put all my bests to ensure some best practice designing Dockers like:
  - One process per Docker is must.
  - Reduction the amount of non-useful filesystem layers.
  - Using the ENTRYPOINT as "parameter-watchdog" and sanitizer, likewise the CMD is used as executor of our "single process".
  - Unix signals collector using dumb-init to prevent the Zombies processes.
* **AutoHealing by default**: Using Swarm and ECS to ensure the max reliability out-the-box.
* **Scaling and Autoscaling**: Using Swarm to scale services manually or ECS + Lambda
    functions for Autoscaling Up/Down with Zero downtime.

## A rubber ring for the busy test-reviewer:
I know, this is probably one more of dozens of TechTests that you should to review
during a short period of time. However the whole of the approaches can be executed as
Vagrant VM in a easy way just typing:
```
vagrant up --provision
```
>**Note:** The approach_3 needs some configuration parameters for the AWS
credentials in `ansible/approach_03.yml` and also you should to review the
default configuration file in `approach_03/conf/ecs_stack.yml` to prevent
conflicts with your current subneting assignment.

Anywise if you don't have time for it or something was wrong in my code,
I provide you a tty "demo" recorded in my own laptop that might be watched
easily as a movie. :-)

For each approach folder you can found inside a subfolder called "demo"
as is showed below for the approach_0:

  ```
  ╰─$ ls -l approach_0/demo
total 312
-rw-rw-r-- 1 amonfa amonfa 287210 nov  1 08:40 approach0_lf
-rw-rw-r-- 1 amonfa amonfa  18930 nov  1 08:40 approach0_tf

  ```
These couple of files are the output of the script-scriptreplay execution
you can find more information about script in: [util-linux](https://github.com/karelzak/util-linux/tree/master/term-utils)

This software is included in the util-linux package available for the most famous
Linux distributions. I suggest you use a color terminal like xterm or gnome-terminal
in maximized mode before launch the next command:
```
─amonfa@emc2 ~/Development/Personal/TechTests/RAKUTENTV/rtv_tt_approaches  ‹master*›
╰─$ ls
ansible  approach_0  approach_1  approach_2  approach_3  doc  docker  README.MD  terraform  workspace
╭─amonfa@emc2 ~/Development/Personal/TechTests/RAKUTENTV/rtv_tt_approaches  ‹master*›
╰─$ scriptreplay --timing=approach_0/demo/approach0_tf approach_0/demo/approach0_lf
╭─amonfa@emc2 ~/Development/Personal/TechTests/RAKUTENTV/rtv_tt_approaches  ‹master*›
╰─$ scriptreplay -d 10 --timing=approach_0/demo/approach0_tf approach_0/demo/approach0_lf
```

`-d --divisor <num>`: speed up or slow down execution with time divisor.


## TODOs:
* **Architectural Diagrams**: To understand better the different pieces and components for each approach.
* **Extra Doc about Autoscaling EC2 Instance**: In that approach I used ASG Lifecycles, Lambda Functions,
   SQS and ECS API to drain containers form some instance before scale down,
   ensuring the Zero Downtime. This approach is a little tricky and should be explained in detail.
* **Monitoring**: one step beyound in Cloudwatch and other providers like
  Prometheus or NewRelic.
* **Refactoring**: The app by default it doesn't 100% docker friendly and it isn't
  to able to inform about his own state
* **CQRS**: In the real world our apps usually needs Commands and Querys we should
  provide the segregation and the event bus for it.
* **Event Sourcing**: our bussiness it isn't only that as our app do, our business
   is everything that our customers and clients done.
* **Serverless**: One approach about how the serverless help us to decrease our
  monthtly billing in the infrastructures side
* **Testing**: We should provide additional ways to test the code and the infrastructure.

## Authors
* **Albert Monfà** - *Initial work* - [albertmonfa](https://es.linkedin.com/in/albertmonfa)


## License
This project is licensed under the Apache 2 License - see the [LICENSE.md](LICENSE.md) file for details
