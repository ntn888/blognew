---
title: "Ditch Proxmox. Incus is the powerful, modern, community driven solution"
description: "Caveats for setting up Incus as a VM solution"
date: 2025-05-17T18:26:00
draft: false
category: ["selfhosting"]
tags: ["NAS", "self-host", "server"]
---

>By default Incus is setup in `bridge` network type with NAT enabled! But we don't want NAT (a sub-network is created), to facilitate reaching our VMs outside of the host (from other computers in our home network). See [docs](https://linuxcontainers.org/incus/docs/main/reference/network_bridge/#configuration-options) on how to disable. Look for `ipv4.nat`, `ipv6.nat` boolean flags.

https://blog.simos.info/how-to-make-your-lxd-containers-get-ip-addresses-from-your-lan-using-a-bridge/

## Addressing quirks on Alpine Linux host

I choose to run Alpine as the hypervisor host. See [this article](/posts/alpine), it's very minimal and ideal for the purpose. You can see in the docs, how to install Incus on it. But I noticed a couple of quirks in running it..

When launching images I get an error in the likes of `tap<>: No such file or directory`. You need to enable the module `tun` before use:

```
echo tun | doas tee -a /etc/modules
reboot
```

Second the docs state that you need to add yourself to `incus-admin` group. This was not the case in my installation. I had to add to `incus` group instead and got admin privileges. To check which group to assign, run:

```
ls -l /var/lib/incus/unix.socket
srw-rw----    1 root     incus            0 May 16 23:47 /var/lib/incus/unix.socket
```


