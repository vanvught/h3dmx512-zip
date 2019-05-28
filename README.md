# Orange Pi Zero / Orange Pi One
## U-Boot

**First time setup**: Select the uboot-*.zip for your board. Unzip the file and use an img writer; for example [Etcher](https://etcher.io).

U-Boot Orange Pi Zero: [uboot-orangpi_zero.zip](https://github.com/vanvught/h3dmx512-zip/blob/master/uboot-orangpi_zero.zip?raw=true)

U-Boot Orange Pi One: [uboot-orangpi_one.zip](https://github.com/vanvught/h3dmx512-zip/blob/master/uboot-orangpi_one.zip?raw=true)

	When not using the latest uboot-*.zip then update SPI flash 

Orange Pi Zero: From [uboot-spi.zip](https://github.com/vanvught/h3dmx512-zip/blob/master/uboot-spi.zip?raw=true), copy file `uboot_zero.spi` to SDCard as `uboot.spi`

Orange Pi One: From [uboot-spi.zip](https://github.com/vanvught/h3dmx512-zip/blob/master/uboot-spi.zip?raw=true), copy file `uboot_one.spi` to SDCard as `uboot.spi` 

## Firmware uImage

- **Art-Net 4 Ethernet** DMX Node / **RDM** Controller / **Pixel (WS28xx/SK6812/APA102/UCSx903) controller** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx.zip?raw=true)}
- **Art-Net 4 Ethernet Pixel** (WS28xx/SK6812/UCSx903) controller **4 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_pixel_multi.zip?raw=true)} 
- **Art-Net 4 Ethernet** DMX Node / RDM Controller **2 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx_multi.zip?raw=true)} {*Orange Pi Zero*}
- **Art-Net 4 Ethernet** DMX Node / RDM Controller **4 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx_multi.zip?raw=true)} {*Orange Pi One*}
-  **sACN E1.31 Ethernet** DMX Bridge / **Pixel (WS28xx/SK6812/AP102/UCSx903) controller** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx.zip?raw=true)}
-  **sACN E1.31 Ethernet Pixel** (WS28xx/SK6812/UCSx903) controller **4 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_pixel_multi.zip?raw=true)}
-  **sACN E1.31 Ethernet** DMX Bridge **2 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx_multi.zip?raw=true)} {*Orange Pi Zero*}
-  **sACN E1.31 Ethernet** DMX Bridge **4 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx_multi.zip?raw=true)} {*Orange Pi One*}
- RDM Controller with USB [Compatible with **Enttec USB Pro protocol**] {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_dmx_usb_pro.zip?raw=true)}  {*Orange Pi Zero*}
- **DMX Real-time Monitor** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_dmx_monitor.zip?raw=true)} {*Orange Pi One*}
- **SMPTE** Timecode LTC Reader {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_ltc_reader.zip?raw=true)}  {*Orange Pi Zero*}
-  **OSC Ethernet** DMX Bridge / **Pixel (WS28xx/SK6812/AP102/UCSx903) controller** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_osc_dmx.zip?raw=true)}
- RDM Responder / **DMX Pixel (WS28xx/SK6812/AP102/UCSx903) controller** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_rdm_responder.zip?raw=true)}
- **Art-Net 3 Wifi** DMX Node / RDM Controller / Pixel (WS28xx/SK6812/AP102/UCSx903) controller {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_artnet_dmx.zip?raw=true)} {*Orange Pi Zero*}
- **sACN E1.31 Wifi** DMX Bridge  / Pixel (WS28xx/SK6812/AP102/UCSx903) controller {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_e131_dmx.zip?raw=true)} {*Orange Pi Zero*}
- **OSC Wifi** DMX Bridge / Pixel (WS28xx/SK6812/AP102/UCSx903) controller {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_osc_dmx.zip?raw=true)} {*Orange Pi Zero*}

Current limitation Ethernet versions: All nodes must be in the same network 

**SDCard uImage**

Orange Pi Zero: From the zip file, copy file `orangepi_zero.uImage` to SDCard as `uImage`

Orange Pi One: From the zip file, copy file `orangepi_one.uImage` to SDCard as `uImage`

<br>

All implementations are fully according to the standards.

Detailed information can be found here : [http://www.orangepi-dmx.org](http://www.orangepi-dmx.org)

<br>

> Special thanks to [@trebisky](https://github.com/trebisky/orangepi) (Thomas J. Trebisky), who helped me in understanding the H3 SoC. 