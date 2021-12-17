#!/usr/bin/env bash

# Leon Steenkamp
# 2021-12-15

TOOLCHAIN=gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf
# TOOLCHAIN=gcc-linaro-7.2.1-2017.11-i686_arm-linux-gnueabihf
SYSROOT=v0.30
# SYSROOT=v0.32

# Set timezone to - Africa/Johannesburg
timedatectl set-timezone Africa/Johannesburg

if [ -f /vagrant/$TOOLCHAIN.tar.xz ]; then
    echo "Found toolchain $TOOLCHAIN"
else
    echo "Toolchain $TOOLCHAIN not found, downloading."
    wget http://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/arm-linux-gnueabihf/$TOOLCHAIN.tar.xz -P /vagrant/
fi

if [ -f /vagrant/sysroot-$SYSROOT.tar.gz ]; then
    echo "Found sysroot-$SYSROOT"
else
    echo "sysroot-$SYSROOT not found, downloading."
    wget https://github.com/analogdevicesinc/plutosdr-fw/releases/download/$SYSROOT/sysroot-$SYSROOT.tar.gz -P /vagrant/
fi

tar -xf /vagrant/$TOOLCHAIN.tar.xz -C /usr/local/bin/
echo "PATH=\$PATH:/usr/local/bin/$TOOLCHAIN/bin" >> /home/vagrant/.profile
export PATH=$PATH:/usr/local/bin/$TOOLCHAIN/bin

tar zxf /vagrant/sysroot-$SYSROOT.tar.gz -C /home/vagrant/
mv /home/vagrant/staging /home/vagrant/pluto-$SYSROOT.sysroot

mkdir /tmp/plutoapp
cd /tmp/plutoapp
TESTFILE=ad9361-iiostream.c

if [ -f /vagrant/$TESTFILE ]; then
    echo "Found test file $TESTFILE"
else
    echo "Test file $TESTFILE not found, downloading."
    wget https://raw.githubusercontent.com/analogdevicesinc/libiio/master/examples/ad9361-iiostream.c -P /vagrant/
fi

cp /vagrant/$TESTFILE /tmp/plutoapp/
arm-linux-gnueabihf-gcc -mfloat-abi=hard  --sysroot=/home/vagrant/pluto-$SYSROOT.sysroot -std=gnu99 -g -o pluto_stream $TESTFILE -lpthread -liio -lm -Wall -Wextra
file pluto_stream > /home/vagrant/compiler_test

mkdir /tmp/plutoapp/.vscode/
cp /vagrant/vscode/* /tmp/plutoapp/.vscode
chown vagrant:vagrant /home/vagrant/compiler_test
chown -R vagrant:vagrant /tmp/plutoapp/

echo "Done with bootstrap"
