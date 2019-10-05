# Orange Pi Zero / Orange Pi One
Open Source and Open Hardware.
<br>
## SDCard

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
  * **Art-Net 4**
      * Pixel controller **WS28xx/SK6812/APA102/UCSx903** [Orange Pi Zero]
         * 1x 4 Universes {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_pixel.zip?raw=true)}
         * 4x 4 Universes {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_pixel_multi.zip?raw=true)}
         * 8x 4 Universes {*tbd*}
      * DMX Node / **RDM** Controller
         *  1 Port {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx.zip?raw=true)} {*Orange Pi Zero*}
         *  2 Ports {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx_multi.zip?raw=true)} {*Orange Pi Zero*}
         *  4 Ports {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_dmx_multi.zip?raw=true)} {*Orange Pi One*}
      * **Real-time Monitor** 1 Universe {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_artnet_monitor.zip?raw=true)} {*Orange Pi One - HDMI output*}
     * Stepper controller L6470 **RDM**
         * Sparkfun AutoDriver chaining {*tbd*} {*Orange Pi Zero*}
         * Roboteurs SlushEngine Model X LT  {*tbd*} {*Orange Pi One*}
  * **sACN E1.31** 
      * Pixel Controller **WS28xx/SK6812/AP102/UCSx903** [Orange Pi Zero]
         *  1x 4 Universes {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx.zip?raw=true)}
         *  4x 4 Universes {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_pixel_multi.zip?raw=true)} {*Orange Pi Zero*}
         *  8x 4 Universes {*tbd*}
      * DMX Bridge
         *  1 Ports {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx.zip?raw=true)} {*Orange Pi Zero*}
         *  2 Ports {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx_multi.zip?raw=true)} {*Orange Pi Zero*}
         *  4 Ports {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_dmx_multi.zip?raw=true)} {*Orange Pi One*}
      * **Real-time Monitor** 1 Universe {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_e131_monitor.zip?raw=true)} {*Orange Pi One - HDMI output*}
  * **OSC** 
      * DMX Bridge / **Pixel Controller (WS28xx/SK6812/AP102/UCSx903)** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_osc_dmx.zip?raw=true)}
      * **Client** with support for buttons {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_osc_client.zip?raw=true)}
      * **Real-time Monitor** 1 Universe {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_osc_monitor.zip?raw=true)} {*Orange Pi One - HDMI output*}
* **RDM** 
  * Controller with USB [Compatible with **Enttec USB Pro protocol**] {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_dmx_usb_pro.zip?raw=true)} {*Orange Pi Zero*}
  * Responder / **DMX Pixel Controller (WS28xx/SK6812/AP102/UCSx903)** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_rdm_responder.zip?raw=true)} {*Orange Pi Zero*}
  * Stepper controller L6470
     * Sparkfun AutoDriver chaining {*tbd*} {*Orange Pi Zero*}
     * Roboteurs SlushEngine Model X LT {*tbd*} {*Orange Pi One*}
* **DMX**
  * **Real-time Monitor** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_dmx_monitor.zip?raw=true)} {*Orange Pi One - HDMI output*}
* **SMPTE LTC**
  * **LTC SMPTE Timecode** Reader / Writer / Generator {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_emac_ltc_smpte.zip?raw=true)}  {*Orange Pi Zero*}
* **MIDI**
  *  **Real-time Monitor** {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/opi_midi_monitor.zip?raw=true)}  {*Orange Pi One*}
* **Wifi**
  * **Art-Net 3** DMX Node / RDM Controller / Pixel Controller (WS28xx/SK6812/AP102/UCSx903) {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_artnet_dmx.zip?raw=true)} {*Orange Pi Zero*}
  * **sACN E1.31** DMX Bridge  / Pixel Controller (WS28xx/SK6812/AP102/UCSx903) {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_e131_dmx.zip?raw=true)} {*Orange Pi Zero*}
  * **OSC** DMX Bridge / Pixel Controller (WS28xx/SK6812/AP102/UCSx903) {[zip](https://github.com/vanvught/h3dmx512-zip/blob/master/h3_wifi_osc_dmx.zip?raw=true)} {*Orange Pi Zero*}

Current limitation Ethernet versions: All nodes must be in the same network 

All implementations are fully according to the standards.

Detailed information can be found here : [http://www.orangepi-dmx.org](http://www.orangepi-dmx.org)

<br>

[PayPal.Me Donate](https://paypal.me/AvanVught?locale.x=nl_NL)