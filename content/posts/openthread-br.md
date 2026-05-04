---
title: "Running the OpenThread Border Router on OrangePI Zero3"
date: 2025-03-05T09:27:00
draft: false
category: ["nrf"]
tags: ["nRF52", "low-power wireless", "OpenThread"]
---

Open thread already has [excellent guides](https://openthread.io/guides/border-router/docker) on running the Border Router software on a Raspberry PI with the Nordic nRF52840 dongle as the radio co-processor.

>Since the SBCs lack a Thread radio, we make use of a Thread capable MCU board as this [radio co-processor](https://openthread.io/platforms/co-processor), flashed with a specific firmware `ot-rcp.bin` (available on the [OpenThread Github](https://github.com/openthread) for various boards) that communicate with the host application via the `Spinel` protocol.

I took a slightly cost effective approach with the Orange PI Zero3 and EasyIot ZB-GW04 (EFR32MG21) based [dongle](https://www.aliexpress.com/item/1005005271016330.html). Here are my notes and workarounds in this approach to achieve a working solution.

>As of this writing the Armbian and DietPI builds have a bug in detecting memory on the Zero3. My 1GB RAM board is *sometimes* detected as having 2GB wrongly (causing random crashes). We'll need to reboot until it is correctly detected, check by running `free -h`. More info [here](https://dietpi.com/forum/t/orange-pi-zero3-ram-intermittently-detected-incorrectly/22973).

I installed the DietPI port for this board onto an SD card and booted. Now to run the OpenThread Border Router host software I used Podman instead of Docker:

```
sudo apt install podman vim
```

We install vim as there are no editors installed by default. We need to modify the `/etc/containers/registries.conf` file to include:

```
unqualified-search-registries = ["docker.io"]
```

This way we get a docker like default repo resolution. Next run:

```
sudo podman pull openthread/otbr:latest
```

Plug in your dongle and check which device is associated (via `dmesg`). In our case it should be `dev/ttyUSB0`. Make sure it is re-flashed as per the preparation section below! Finally run (making sure to replace the **left** `ttyUSB0` with your instance):

```
sudo podman run --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv4.conf.all.forwarding=1 --sysctl net.ipv6.conf.all.forwarding=1 -p 8080:80 --dns=127.0.0.1 -it --volume /dev/ttyUSB0:/dev/ttyUSB0 --privileged openthread/otbr
```

Now the web interface is available on `dietpi:8080`.

You can also follow along with the [Simulated RCP](https://openthread.io/guides/border-router/docker/run#simulated_rcp). Note that the building step takes ages on the PI Zero3!

## Prepare the EasyIot ZB-GW04 dongle

This [repo](https://github.com/darkxst/silabs-firmware-builder) has all you need to reflash the dongle to a ot-rcp. In essence I had to run (make sure you match the firmware version to the indication on the PCB!):

```
universal-silabs-flasher --device /dev/ttyUSB0 flash --firmware ot-rcp-v2.4.5.0-zb-gw04-1v2-230400.gbl --allow-cross-flashing
```

Verify with:

```
universal-silabs-flasher --device /dev/ttyUSB0 --probe-method spinel --spinel-baudrate 230400 probe
```


# Sniffing Packets

\<TODO\>

