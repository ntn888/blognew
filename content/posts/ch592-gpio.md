---
title: "CH592 GPIO"
description: "WCH CH592 chip GPIO tutorial"
date: 2025-07-31T12:28:00
draft: false
category: ["ch592"]
tags: ["ch592", "sdk", "low-power wireless"]
---


We have seen the blinky project previously. In this note we will study the `main.c` and HAL functions of the SDK pertinent to GPIO module.

Here's the blinky `main.c` again:

```

#include "CH59x_common.h"

void board_led_init(void)
{
    GPIOA_SetBits(GPIO_Pin_8);
    GPIOA_ModeCfg(GPIO_Pin_8, GPIO_ModeOut_PP_5mA);
}

void board_led_toggle(void)
{
    GPIOA_InverseBits(GPIO_Pin_8);
}

void board_led_set(uint8_t set)
{
    if (set)
        GPIOA_ResetBits(GPIO_Pin_8);
    else
        GPIOA_SetBits(GPIO_Pin_8);
}

int main()
{
    uint8_t s;
    SetSysClock(CLK_SOURCE_PLL_60MHz);

    board_led_init();

    while(1)
    {
      mDelaymS(100);
      board_led_toggle(); 
      mDelaymS(100);
    }
}

```

## Clock setup

Note that these chips use only a fixed external crystal of 32MHz for operation!

The HAL files are located in `vendor/StdPeriphDriver`. Headers are in the `inc` subdirectory.

As you can see the clock is set for 60MHz operation. In the `CH59x_common.h` file it is defined:

```
#ifndef	 FREQ_SYS
#define  FREQ_SYS		60000000
#endif
```

So if we are going to configure other than 60Mhz system clock, we need to specifiy in `main.c` before including `CH59x_common.h`:

```
#define  FREQ_SYS		80000000    // 80MHz
#include "CH59x_common.h"
```

We will use the default 60Mhz, so we wont explicitly define in our file.

We then need to configure the clock in the main function:

```
SetSysClock(CLK_SOURCE_PLL_60MHz);
```

## Delays

We can use the delay function also defined in `CH59x_sys.h`, for micro and milli seconds respectively.

```
void mDelayuS(uint16_t t);
void mDelaymS(uint16_t t);
```

## GPIO

The ch592F chip has 20 GPIOs:

| Port   | Pins            |
| ------ | --------------- |
| 10* PA | 4,5,8-11,12-15  |
| 10* PB | 4,7,10-15,22,23 |


### Note on Alternate Functions

To use the pins as I/O for respective peripherals, the Alternate Functions system is used. After reset, all I/O are GPIO by default.

To set the relevant pin as I/O for required peripheral module, set the pin mode as shown in `section 7.3.1` in the datasheet. This table shows the suggested mode required for the module. To see the designated pin for each module, see table `7-7`. When the module (peripheral) is configured, it will automatically enable the Alternate Function on the attached pin.

Each module also has a secondary pin designated, known as Remap, which is also shown in the table. To activate the remap use the function as defined in the gpio header,

```
void GPIOPinRemap(FunctionalState s, uint16_t perph);
```

### Mode Config

See the gpio header for various gpio configuration and setting the output..

