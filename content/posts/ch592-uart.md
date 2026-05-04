---
title: "CH592 UART"
description: "WCH CH592 chip UART tutorial"
date: 2025-08-21T11:28:00
draft: false
category: ["ch592"]
tags: ["ch592", "sdk", "low-power wireless"]
---


Here's a program to send data over the UART:

```
// TXD3: PA5


#include "CH59x_common.h"
#include <string.h>


int main()
{
  char *s = "Hello world\r\n";
  SetSysClock(CLK_SOURCE_PLL_60MHz);
  
  GPIOA_ModeCfg(bTXD3, GPIO_ModeOut_PP_5mA);
  UART3_DefInit();  
  
  while (1) {
    UART3_SendString((uint8_t *)s, strlen(s));
    mDelaymS(1000);
  }
  
}

```

Note `bTXD3` is equivalent to `PA5`. Make sure to include `CH59x_uart3.c` in the compilation Makefile:

```
C_SOURCES = \
src/main.c \
../../vendor/StdPeriphDriver/CH59x_clk.c \
../../vendor/StdPeriphDriver/CH59x_gpio.c \
../../vendor/StdPeriphDriver/CH59x_pwr.c \
../../vendor/StdPeriphDriver/CH59x_sys.c \
../../vendor/StdPeriphDriver/CH59x_uart3.c \				# <== add this
../../vendor/RVMSIS/core_riscv.c \
```



## Using the DEBUG flag

There is a convenience offered in the SDK; the DEBUG flag. As per `CH59x_common.h` it can take one of these values:

```
#define Debug_UART0        0
#define Debug_UART1        1
#define Debug_UART2        2
#define Debug_UART3        3
```
Which is followed by the line:

```
#ifdef DEBUG
#include <stdio.h>
#endif
```
And in `CH59x_sys.h`:

```
#ifdef DEBUG
int _write(int fd, char *buf, int size)
{
    int i;
    for(i = 0; i < size; i++)
    {
#if DEBUG == Debug_UART0
        while(R8_UART0_TFC == UART_FIFO_SIZE);
        R8_UART0_THR = *buf++;
#elif DEBUG == Debug_UART1
        while(R8_UART1_TFC == UART_FIFO_SIZE);
        R8_UART1_THR = *buf++;
#elif DEBUG == Debug_UART2
        while(R8_UART2_TFC == UART_FIFO_SIZE);
        R8_UART2_THR = *buf++;
#elif DEBUG == Debug_UART3       
        while(R8_UART3_TFC == UART_FIFO_SIZE);
        R8_UART3_THR = *buf++;
#endif
    }
    return size;
}

#endif
```

These constructs enable us to use `printf()`. But there's more... In `CH592SFR.h`:

```
#ifdef  DEBUG
#define PRINT(X...) printf(X)
#else
#define PRINT(X...)
#endif
```

Which means if we use `PRINT(X)` instead, depending on the `DEBUG` flag, this expression will be evaluated and still not cause an compiling error if we are not in DEBUG condition.

We will see an example.

```
// TXD3: PA5


#define DEBUG	Debug_UART3
#include "CH59x_common.h"


int main()
{
  char *s = "Hello world\r\n";
  SetSysClock(CLK_SOURCE_PLL_60MHz);
  
#ifdef DEBUG
  GPIOA_ModeCfg(bTXD3, GPIO_ModeOut_PP_5mA);
  UART3_DefInit();
#endif
  
  while (1) {
    PRINT(s);
    mDelaymS(1000);
  }
  
}

```

Or to switch up the convenience, we could move the `#define DEBUG	Debug_UART3` flag to the makefile.

Insert this line at the top:

```
DEFINES = -DDEBUG=Debug_UART3
```

And change:

```
CFLAGS = $(MCU) $(C_INCLUDES) $(OPT) $(DEFINES) -Wall -fdata-sections -ffunction-sections
```

