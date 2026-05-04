---
title: "Prepare Fedora Linux for Buildroot compilation"
date: 2024-01-10T07:27:00
draft: false
category: ["embedded-linux"]
tags: ["embedded-linux", "linux", "buildroot", "milkv-duo"]
---


Here's a quick note on how to prepare Fedora for compiling Buildroot. The following worked for me for compiling a system for the [Milk-V Duo](/posts/linux-milkv-duo).

First install Fedora's equivalent of `build-essential` and ncurses (for menuconfig).

```
sudo dnf group install "C Development Tools and Libraries" "Development Tools"

sudo dnf install ncurses-devel
```

If when running `make` compilation results in missing Perl modules, install them via:

```
sudo dnf install 'perl(My::Module)'
```

Fortunately these missing Perl modules error appear at the very beginning of the compilation and causes the least hassle!
