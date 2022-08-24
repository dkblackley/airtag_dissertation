//Turn on the Red LED until an OF device is found
digitalWrite(LED1, true);

// Start scanning
NRF.setScan(function(d) {  
  payload = d.data;
  if (payload[4] == 18) { //If the type is an OF device
    NRF.setAddress(d.id); // Copy the MAC address
    NRF.setAdvertising(payload, {interval:2000}); // replay the packet
    
    NRF.setScan(); // stop scanning
    
    digitalWrite(LED1, false); // Turn off red LED now an OF device is beimng replayed
    // Flash green LED if successful
    digitalWrite(LED2, true);
    setTimeout(function(){ 
      digitalWrite(LED2, false);
    }, 2000);  
  }
}, { filters: [{ manufacturerData:{0x004c:{}} }] }); // Filter to only Apple devices


// Blink green for 100ms
function blinkGreen() {
  LED2.write(true);
  setTimeout(function () { LED2.write(false); }, 100);
}

// Detect button press and blink green
setWatch(blinkGreen, BTN, { edge: "rising", repeat: true, debounce: 50 });
