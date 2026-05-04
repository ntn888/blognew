---
title: "Alpine Linux intro"
description: "Discuss viability of Alpine Linux as a server OS"
date: 2025-05-17T13:26:00
draft: false
category: ["selfhosting"]
tags: ["NAS", "self-host", "server"]
---

In my adventures in selfhosting, I've noticed I never install anything (save firewall and Docker) on the host OS and run everything inside containers. This may be out of paranoia - more packages/dependencies, more chance of system breaking / update failure.

I've run Debian as the server OS for the longest time (admittedly a popular, and "everything just works" OS).. But this reflection calls for a reconsideration of the host OS. Enter Alpine Linux; small, lean, minimal. Even boots in seconds (on a PI).

>Although, the main factor behind this 'distrohop' is Podman. Looking to try out Podman (tempted by it's rootless feature), I was surprised how ancient the version in Debian is, missing important practical features.. Maybe Podman is not as widespread as I anticipated. Anyway..

One thing I'm fond of in the installer (which is a text based wizard like script), is it's simple sensible default partitioning option. No need to concern with part tools, complex layout selections if you don't want to.

A distinct feature (apart from it's `apk` package manager) is `OpenRC` inplace of systemd. Although the [wiki](https://wiki.alpinelinux.org/wiki/Main_Page) is more extensive, look at the [docs](https://docs.alpinelinux.org/) for our lean system maintenance.

[This Youtube video](https://www.youtube.com/watch?v=EaCCB3y1ZGM) has a quick walkthrough of it's important parts.

## mDNS

One of the first things to do in a local selfhost server is to assign a `.local` hostname (so it could be easily accessed from within the network). Once you've made sure you've set a `.local` suffix'd hostname, see [here](https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-hostname):

```
# Install, enable and start avahi with:
doas apk add avahi
doas rc-update add avahi-daemon
doas rc-service avahi-daemon start
```

