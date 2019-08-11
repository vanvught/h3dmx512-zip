# Orange Pi Zero / Orange Pi One
## U-Boot

**First time setup**: Select the uboot-*.zip for your board. Unzip the file and use an img writer; for example [Etcher](https://etcher.io).

U-Boot Orange Pi Zero: [uboot-orangpi_zero.zip](https://github.com/vanvught/h3dmx512-zip/blob/master/uboot-orangpi_zero.zip?raw=true)

U-Boot Orange Pi One: [uboot-orangpi_one.zip](https://github.com/vanvught/h3dmx512-zip/blob/master/uboot-orangpi_one.zip?raw=true)

	When not using the latest uboot-*.zip then update SPI flash 

Orange Pi Zero: From [uboot-spi.zip](https://github.com/vanvught/h3dmx512-zip/blob/master/uboot-spi.zip?raw=true), copy file `uboot_zero.spi` to SDCard as `uboot.spi`

Orange Pi One: From [uboot-spi.zip](https://github.com/vanvught/h3dmx512-zip/blob/master/uboot-spi.zip?raw=true), copy file `uboot_one.spi` to SDCard as `uboot.spi` 

**Firmware uImage**

Orange Pi Zero: From the zip file, copy file `orangepi_zero.uImage` to SDCard as `uImage`

Orange Pi One: From the zip file, copy file `orangepi_one.uImage` to SDCard as `uImage`

## Firmware uImage

* **Ethernet**
  * **Art-Net 4** DMX Node / **RDM** Controller / **Pixel (WS28xx/SK6812/APA102/UCSx903) controller** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx.zip?raw=true)}
  * **Art-Net 4 Pixel** (WS28xx/SK6812/APA102/UCSx903) controller **4 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_pixel_multi.zip?raw=true)}  {*Orange Pi Zero*} 
  * **Art-Net 4** DMX Node / RDM Controller **2 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx_multi.zip?raw=true)} {*Orange Pi Zero*}
  * **Art-Net 4** DMX Node / RDM Controller **4 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx_multi.zip?raw=true)} {*Orange Pi One*}
  * **sACN E1.31** DMX Bridge / **Pixel (WS28xx/SK6812/AP102/UCSx903) controller** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx.zip?raw=true)}
  * **sACN E1.31 Pixel** (WS28xx/SK6812/APA102/UCSx903) controller **4 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_pixel_multi.zip?raw=true)} {*Orange Pi Zero*}
  * **sACN E1.31** DMX Bridge **2 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx_multi.zip?raw=true)} {*Orange Pi Zero*}
  * **sACN E1.31** DMX Bridge **4 Ports** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx_multi.zip?raw=true)} {*Orange Pi One*}
  * **OSC** DMX Bridge / **Pixel (WS28xx/SK6812/AP102/UCSx903) controller** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_osc_dmx.zip?raw=true)}
  * **OSC Client** with support for buttons {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_osc_client.zip?raw=true)}
* **RDM**
  * RDM Controller with USB [Compatible with **Enttec USB Pro protocol**] {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_dmx_usb_pro.zip?raw=true)}  {*Orange Pi Zero*}
  * RDM Responder / **DMX Pixel (WS28xx/SK6812/AP102/UCSx903) controller** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_rdm_responder.zip?raw=true)}
* **DMX**
  * **Real-time Monitor** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_dmx_monitor.zip?raw=true)} {*Orange Pi One*}
*  **SMPTE LTC**
  * **SMPTE Timecode** LTC Reader / Writer / Generator {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_ltc_smpte.zip?raw=true)}  {*Orange Pi Zero*}
* **MIDI**
  * **MIDI** Sniffer {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_midi_sniffer.zip?raw=true)}  {*Orange Pi One*}
* **Wifi**
  * **Art-Net 3** DMX Node / RDM Controller / Pixel (WS28xx/SK6812/AP102/UCSx903) controller {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_artnet_dmx.zip?raw=true)} {*Orange Pi Zero*}
  * **sACN E1.31** DMX Bridge  / Pixel (WS28xx/SK6812/AP102/UCSx903) controller {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_e131_dmx.zip?raw=true)} {*Orange Pi Zero*}
  * **OSC** DMX Bridge / Pixel (WS28xx/SK6812/AP102/UCSx903) controller {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_osc_dmx.zip?raw=true)} {*Orange Pi Zero*}

Current limitation Ethernet versions: All nodes must be in the same network 

All implementations are fully according to the standards.

Detailed information can be found here : [http://www.orangepi-dmx.org](http://www.orangepi-dmx.org)

<br>

> Special thanks to [@trebisky](https://github.com/trebisky/orangepi) (Thomas J. Trebisky), who helped me in understanding the H3 SoC. 