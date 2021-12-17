# PlutoSDR Kitchen
A C language development environment in HashiCorp Vagrant for the PlutoSDR.

The instructions and _Linaro_ toolchain from [2] was used for this virtual 
machine (VM) config. It is recommended to read the Quick Start guide at [1].

## Getting started
_The `$` character indicates terminal commands_

The _bootstrap.sh_ script will be run when the virtual machine (VM) starts and 
downloads the toolchain and sysroot, then configures the environment.

1. Prerequisites
    - Git
    - VS Code
2. Prerequisites (from Vagrant Quick Start)
    - Install the latest version of Vagrant (https://www.vagrantup.com/downloads)
    - Install VirtualBox
3. Clone this repository
4. Initialise and start virtual machine (VM) with `$ vagrant up`
5. Get the OpenSSH config to use in VS Code `$ vagrant ssh-config`
6. Connect to VM once it is started `$ vagrant ssh`
7. Configure VS Code as described below then the development environment is configured
8. Destroy the VM when you are done `$ vagrant destroy`

A clean environment can be created by destroying the VM and starting a new one. It 
is easy to try different Ubuntu/toolchain/sysroot versions by changing the 
`bootstrap.sh` or `Vagrantfile`.

## Visual Studio Code configuration
Get the OpenSSH config using `$ vagrant ssh-config`, it should look something like 
below:

```
Host vagrant
    HostName 127.0.0.1
    User vagrant
    Port 2222
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no
    IdentityFile C:/vTestPath/.vagrant/machines/default/virtualbox/private_key
    IdentitiesOnly yes
    LogLevel FATAL
```

In VS Code in the side bar go to the _Remote Explorer_ tab and select the 
_Configure_ gearwheel. Use the `C:\Users\<username>\.ssh\config` config file 
and add the OpenSSH config from the step above to the file.

You should now be able to connect to the running VM using _Connect to Host in New Windows_. 
On the remote host _Open Folder_ and navigate to the test directory 
at `/tmp/plutoapp/`. The `.vscode` folder contains example configuration files for 
C properties and tasks such as building the example file from [3]. These must be 
updated if you change toolchain or sysroot.

## Links
1. https://learn.hashicorp.com/collections/vagrant/getting-started
2. https://wiki.analog.com/university/tools/pluto/devs/embedded_code
3. https://raw.githubusercontent.com/analogdevicesinc/libiio/master/examples/ad9361-iiostream.c