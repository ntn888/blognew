---
title: "The Ten Cent Microcontroller Space"
description: "Roundup of really cheap MCUs"
date: 2025-02-07T13:27:00
draft: false
category: ["misc"]
tags: ["low cost", "embedded hobbyist", "microcontrollers"]
---

Here are the contenders as of this writing.
- WCH ch32v003
- Puya py32f002
- stm32g030
- TI mspm0c1104

Although, ST's chip is slightly more costly at 70c. The Puya chip is the cheapest at 12c while the WCH one sells for around 20c. These were the prices off LCSC supplier.

There are cheap dev boards for both the ST and WCH chips at AliExpress for 5usd for a batch of 5!

![st dev board](/img/weact-st.png)

![wch dev board](/img/weact-wch.png)

It's general wisdom that ST's parts are far more energy efficient (if you're into battery / harvested power projects). While the Puya part claims just a quater of it in it's datasheet on low power mode comparison; I doubt it'll hold true in practice.

Ofcourse ST has the head up on the dev environment experience.. given it's maturity. So the real comparison is between the other two. I found that Puya's ecosystem (and the English manuals) was far ahead of WCH. This was surprising to me given how much more popular other chip is.

So given the edge in price and the developer experience, I sought to try out the Puya SDK. That's when I found out that there is a major bug in its parts that the reset vector map has to be located in the RAM. No wonder the RAM usage was high (as much as 40%!). Which is self-defeating..

Finally I resorted to the ST chip. Yeah, it's relatively more expensive but I emphasise the user experience. Since I'm not that well versed in the register level programming (been spoilt with HAL usage) it will suit me to move quicker and learn fast.

I think low level (without HALs) programming suits these constrained chips more.

Notable mention is the TI's MSPM0C1104 coming in at around 20c is renowned as the world's smallest microcontroller.

