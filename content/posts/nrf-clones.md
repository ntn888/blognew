---
title: "nRF52840 board (Nice!Nano clones)"
date: 2023-11-07T20:27:00
draft: false
category: ["nrf"]
tags: ["nRF52", "embedded hobbyist"]
---

These Chinese Nicenano V2 clones have started popping up on AliExpress. This is great news for us low-power-wireless nerds; As this widens our choice for ready made boards.. As bonus, Zephyr has support for this board out of the box `promicro_nrf52840`.

>Nordic hasn't actually been welcoming towards hobbyists and this has resulted in scarcity of ready-made newbie friendly boards for prototyping (as opposed to esp32 or the ST's bluepill). Which has been a real game stopper for home IOT projects. We've discussed two possible boards in [this post](/posts/micro-bit-breakout). Here is a new viable option.

[NRF52840 Development Board Supermini Compatible With Nice!Nano V2.0](https://aliexpress.com/item/1005006035267231.html)

![Main board pics](/img/nrf_clone_pic.resized.png)

![Board pinouts](/img/nrf_clone_pinout.resized.png)

Features:

- Mini-sized (breadboard friendly)

- Built-in LiPo battery charger

- Supports charger boost jumper (100mA to 300mA) on the back side

There is a known issue with higher leak current than the original micro board. This one is reported to have a deep sleep current consumption of 700mA! ([reddit](https://redd.it/16q5b2c))

For more details and the workaround of the issue please follow the link to [this site](https://github.com/joric/nrfmicro/wiki/Alternatives#supermini-nrf52840). This is now fixed. See update below.

Unfortunately the SWD debug pins are not broken out as headers, but as pads underneath. We'd have to directly solder some wires onto this. I haven't checked it out personally, but they may be shipping with a bootloader for simply flashing purposes. Alternatively we can use a CMSIS-DAP debugger instead with the SWD pads underneath. I personally use a PI Pico flashed as [Debug probe](https://github.com/raspberrypi/debugprobe) as my probe.

![Debug link](/img/nrf-debug.jpg)

Zephyr by default sets the UART pins as \[0.9-TX, 0.10-RX\]. See [this post](/posts/usb-rules) for setting up access to the probe as non root user. Then we can use the following command to flash. Save the following into `.bashrc` file.

```
nrfflash ()
{
        openocd -f interface/cmsis-dap.cfg -f target/nrf52.cfg  -c "program $1 reset exit"
}
```

Then to flash: `nrfflash <out.hex>`. Replacing the appropriate filename.

A thing to note is the Zephyr board config has to be modified to redirect console output to the UART. To do this create the file `promicro_nrf52840_nrf52840.overlay` in the project root.

```
/ {
	chosen {
		zephyr,console = &uart0;
		zephyr,shell-uart = &uart0;
	};
};
```


As the maker and IoT communities continue to grow, it's exciting to see how this clone will contribute to the world of embedded systems and innovation. Whether you're a seasoned developer or just starting your journey, the Nicenano V2 clone is worth exploring for your next project.


>Update: As noted in the clones wiki above, now the batches have the resistor fix applied that fixes the higher idle power leak! 
