---
title: "Best microcontroller for Beginners"
description: "Discussing capable beginner friendly microcontroller boards"
date: 2023-11-05T18:27:00
draft: false
category: ["misc"]
tags: ["stm32", "blue-pill", "embedded hobbyist", "microcontrollers"]
---

One of the most asked questions on *r/embedded* Reddit is *How do I get started in embedded electronics?* or *What is the best microcontroller for beginners?*. This post will aim to address that.

There are wide range of microcontrollers, here are some popular microcontrollers that are great choices for beginners:

1. **Arduino:** Arduino is widely considered one of the best options for beginners. It offers a user-friendly, open-source platform with a simple programming environment. The Arduino community is large and supportive, and there are numerous tutorials and projects available online. The Arduino Uno and Arduino Nano are notable starter boards.

2. **Raspberry Pi Pico:** The Raspberry Pi Pico is a microcontroller board from the Raspberry Pi Foundation. It's based on the RP2040 microcontroller and is great for beginners. It supports the MicroPython programming language, which is easy to learn and use. The Pico is affordable and has plenty of online resources.

3.  **STM32 Bluepill:** The Bluepill is an inexpensive minimal breadboard-friendly board with the STM32F103 MCU.

Many take the Arduino route. Although this may be a good idea; in this blog we're not concerned with Arduino; these are heavy frameworks. Simple, plain and close to metal frameworks are more performant and more importantly - exciting. The Raspberry Pi Pico is excellent for the beginner with plenty of documentation although it's caveat is poor power performance, and is not professionally viable..

Hence my suggestion is to begin with the widely available and inexpensive [blue-pill board](https://web.archive.org/web/20190428082446/http://wiki.stm32duino.com/index.php?title=Blue_Pill). It is powered by the ST's ARM Cortex-M3 STM32F103C8; A chip that is widely used in the industry. It's got enough RAM and flash to run your initial projects while you pick up some embedded skills.

Pairing it up with this book: [Beginning STM32](https://www.amazon.com/BEGINNING-STM32-DEVELOPING-LIBOPENCM3-Paperback/dp/1484245970), will give you a great start with step-by-step hand-holding. This book uses the [libopenCM3](https://github.com/libopencm3/libopencm3) HAL (that's Hardware Abstraction Layer) framework. In my opinion this framework is far superior to the ST's default cube HAL which is a botched mess.

![Begining STM32 cover](/img/begin_stm32.jpg)

Or if you're feeling adventurous I recommend the STM32G030 boards, as featured in our [low cost MCU article](/posts/10c-mcu). The *WeACT STM32G030F6P6* boards available from AliExpress, $3 for a 5 pack! Being relatively modern, they are more power efficient. More importantly, being of the uncomplicated Cortex-M0 architecture, they are great for Assembly language beginners if you seek to go down that route.

The bluepill has copious amount of guides online so you'd have a lot of initial hand-holding, which makes it an easier endeavour. Of course you may switch to the *G0* board after you've grasped the fundamentals.

To complement your microcontroller board and to do projects, you will need a set of commonly used electronic components. Fortunately one may find many *electronic starter-kits* on AliExpress that will suffice for a beginner hobbyist.

Finally you need a multimeter. Again Ali has you covered here. Note that the accuracy of the multimeter is denoted in *counts*. 4000 counts would probably be about right for hobbyist use; but the more the better.. See [here](https://instrumentationtools.com/multimeter-digits-counts/) for an explanation. See [here](/posts/multimeters) for a breakdown of various options.

[This post](/posts/building-lab) works through building an economical home lab.

