---
title: "WCH CH592 Begin"
description: "Overview of the WCH CH592 chip tutorial series"
date: 2025-07-30T17:24:00
draft: false
category: ["ch592"]
tags: ["ch592", "ble", "low-power wireless"]
---

In this series of articles we'll see the various aspects of programming the WCH CH592 mcu, including its HAL. I think it's got great balance of feature-to-cost, and equipped with ble5.4 radio, is excellent for IoT projects! At the time of this writing it can be had for under 50c at bulk.

Add to this WCH provides as part of the SDK, a lightwight custom networking stack on top of the 2.4GHz RF, which can be used in place of ble, if preferred. We'll take a look at it later.

I find the SDK relatively straightforward and a streamlined experience. It is well documented and in places where it's commented in Chinese, I just use the translator plugin in my web browser when needed (see following article on a script to batch translate the source files locally). The SDK is provided in [Github](https://github.com/openwch/ch592). Look for the folder named `EVT`. The datasheet is included.

One minor annoyance with this chip series is the use of a custom scheduler RTOS (called TMOS) used with the RF stack. And it's recommended by the vendor to use this and not freeRTOS when enabling RF in your project. Fortunately an English translated document is available for this scheduler. You can of-course use freeRTOS when not utilising RF, which is also provided in the SDK.

## Studying the SDK

The technical reference manual (TRM) document is grouped into the chip's datasheet and not provided separately like for the WCH CH32 series. I approached learning the SDK/HAL by going through the overview of the relevant chapter that I'm interested in and subsequently browsing through the peripheral's header file and matching `.c` file (if provided) in the `EVT/EXAM/SRC/` directory. It does involve a bit of guesswork going through the available functions and seeing if they match up with the requirements of the peripheral's documentation in the datasheet.

For peripherals that are not discussed in this blog, use this strategy. At any rate, study the first 6 chapters (excluding ch.3 Interrupts). Allowing you to understand the general concepts of the chip:

- Pinout
- System and memory layout
- System Control and Power states
- System clock

Also look at the section `7.3.1 Alternate Functions` containing table suggestions for GPIO configurations when used for peripheral modules. Followed by a handy table of Alternate Function remapping indicating the Default and Remapped pins. Remapping is covered in future article.

The SDK project files are setup to use with a custom IDE, Mournriver Studio. We'll of-course use plain Makefiles in our study. Given the simple structure of the SDK, it's easy to adopt. [My repo](https://code.simplycreate.online/ajit/ch592-projects).

