# wavEMS
EMS controls via audio signals  
  
EMS waves generated by audio.  
  
RN-52, piezo amp, DC-DC convertors, powered by 3.7V Li-ion battery.  

![wavems](https://github.com/rkmtlab/wavEMS/blob/master/images/wavems.jpg)

## How to Use  
Connect to wavEMS via Bluetooth and use audio output for controls.  
"wavEMS.pde" provides a simple UI, where you can test typical EMS waveforms.  
You can use any kind of audio, but always be careful that some signals can be painful/dangerous.  
Please also go through these [terms](https://github.com/rkmtlab/multi-ems/blob/multi-ems-3.1.1/TERMSOFUSE.md) before usage.  
    
  
## Components  
RN-52: Bluetooth Module  
[Breakout+Amp](https://shop.emergeplus.jp/hachiware-btamp-kit/)  
or any other breakouts (but requires to remove the input resistor from the following Amplifier)  
  
IFJM-001: Piezo Amplifier  
[IFJM-001](https://www.marutsu.co.jp/pc/i/1099677/)  
  
LTC3124: DC-DC Covertor (used to convert 3.7V input to 12V)  
[LTC3124](https://strawberry-linux.com/catalog/items?code=13124)  
  
MIWI06-24D05: DC-DC Convertor (used to convert 12V to +5V and -5V)  
[MIWI06-24D05](http://akizukidenshi.com/catalog/g/gM-06536/) 
  
  
## Implementation  
- Connect battery to LTC3124.
- Connect 12V output of LTC3124 to MIWI06-24D05 and IFJM-001.
- Connect +5V output of MIWI06-24D05 to IFJM-001 and RN-52, and -5V to IFJM-001.
- Connect RN-52 output to IJFM-001 input.
- Use 3.9kΩ resistor for the IJFM-001 bus voltage adjusting pins.
- Include a current limiting fuse etc. for safety.  
  
![system](https://github.com/rkmtlab/wavEMS/blob/master/images/system.jpg)  
  
## Issues  
- due to the filter, the amplitude are not the same for all waveforms  
- consumes high current. maybe changing the resistor (bus voltage) can slightly solve this.  
  
## Publications  
See the following for more details:  
Michinari Kono, and Jun Rekimoto. 2019. wavEMS: Improving Signal Variation Freedom of Electrical Muscle Stimulation. 2019 IEEE Conference on Virtual Reality and 3D User Interfaces Workshop on Human Augmentation and its Applications (IEEE VR ’19). 4 pages. [https://arxiv.org/abs/1902.03184](https://arxiv.org/abs/1902.03184)  
  
Also see...  
Michinari Kono, Yoshio Ishiguro, Takashi Miyaki, and Jun Rekimoto. 2018. Design and Study of a Multi-Channel Electrical Muscle Stimulation Toolkit for Human Augmentation. In Proceedings of the 9th Augmented Human International Conference (AH '18). ACM, New York, NY, USA, Article 11, 8 pages. DOI: https://doi.org/10.1145/3174910.3174913  
and [multi-ems](https://github.com/rkmtlab/multi-ems)

The following article includes a survey of EMS in HCI, and safety topics.

Michinari Kono, Takumi Takahashi, Hiromi Nakamura, Takashi Miyaki, and Jun Rekimoto. 2018. Design Guideline for Developing Safe Systems that Apply Electricity to the Human Body. ACM Trans. Comput.-Hum. Interact. 25, 3, Article 19 (June 2018), 36 pages. DOI: https://doi.org/10.1145/3184743  
  
## Authors

Michinari Kono, U-Tokyo ( mchkono[at]acm.org )

## Copyrights, License      
  
Copyright (c) 2019 Michinari Kono  
Released under the MIT license 
