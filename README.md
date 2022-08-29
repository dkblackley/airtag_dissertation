# Airtag Dissertation
A repository made to hold the code for my dissertation on the Apple AirTag/ Find My network

Everything in the OpenHaystack folder is creditted to:  https://github.com/seemoo-lab/openhaystack, but I have modified some of their code, like their BoringSSL obj C file, adding more uncompression methods etc.

Everything in the AirTag folder is my work. I plan to update this library more in the future, as most of the swift code is run in the constructor of the view class and dumps everything out to the terminal. 

## Usage
Run pod install under the AirTag folder to install all the libraries for the swift files. You can brew install cocoapods if you don't already have it. 

The python files in the pico_scripts folder requires a raspberry pi pico. Plug in the pico and install the pico script into the pico with something like Thonny. Remember to rename it to main.py! Then run main.py from the connected machine, changing the path to the device as required

The frida scripts are for disabling certficate pinning on macos 10.15, i just used frida scripts on iOS, but you can try these and see if they work.

