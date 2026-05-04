---
title: "The STM32WB series"
date: 2025-02-26T18:24:00
draft: false
category: ["efr32"]
tags: ["stm32", "efr32", "low-power wireless"]
---

Choosing the SiLabs' EFR chips is a mistake in a hobby setting. It has

- lack of breadboard friendly dev boards
- lack of low cost flashers

That second one is a dealbreaker. They use the Segger ecosystem of programmers, and boy are they expensive! I looked at several options to make use of a CMSIS-DAP (cortex-M universal) flasher. But couldn't get them to work.

- Blackmagic Probe has no support for the series 2 family
- `pyocd` did claim support via DFP packs but it didn't actually work. (Gave memory transfer errors)
- The `stlink-reflasher` software from Segger, turns an stlink into a j-link (effectively). But it's illegal to use it outside of ST's parts. (Also this reflasher only runs on Windows (yuk!)).

![stm32wb hero image](/img/stm32wbic.jpg)

This brings us to ST's STM32WB series chips. Announced in [2019](https://www.hackster.io/news/stmicro-s-stm32wb55-chips-finally-available-after-13-month-wait-a92ea30182fd), they offer a family of low power MCUs featuring BLE and Thread. [A year later](https://www.hackster.io/news/stmicro-s-stm32wb-family-gets-a-lower-cost-entry-point-with-new-value-line-parts-starting-at-1-57-2a37e6488764) they introduced the value line series in this family.

ST may have been late to the wireless MCU portfolio party, but their stronghold in a mature ecosystem in general reflects in the new series too. The are ideal for the hobbyists (battery powered apps). Cheap flashers, vast documentation, plethora of online guides, and lastly \[even if not elegant\] beginner friendly tools and software ecosystem (ahem, CubeMX).

The cost conscious Nucleo Boards have coverage for this series. But even cheaper and breadboard friendly is the [We-Act board](https://www.aliexpress.com/item/1005007119406784.html). So there is no fiddling with the (already scarce) SMD packages or making DIY breakouts for them. It's all off-the-shelf.

If we look at the SDK, we are supplied with the CubeIDE (a concept that has been replicated by many vendors!). I personally dislike it and prefer command line development. But it's certainly a start. Included is a click-and-pick peripheral config tool - CubeMX. Of note is the family's Cube firmware package which is downloaded as needed. In our case [stm32cubeWB](https://github.com/STMicroelectronics/STM32CubeWB). It contains all the HAL and CMSIS drivers. It also contains the needed middleware libraries such as, freeRTOS and OpenThread. Therefore you can always ditch the CubeIDE and go simple Makefiles! We'll explore this in a further post.

