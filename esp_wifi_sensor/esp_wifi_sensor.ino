#include <WiFi.h>
#include <WebServer.h>
#include <WiFiUdp.h>


/* Put your SSID & Password */
const char* ssid = "LB2_ESP";  // Enter SSID here
const char* password = "12345678";  //Enter Password here
char* valueString;

float pin1Value = 0;
float pin2Value = 0;
float pin3Value = 0;

/* Put IP Address details */
IPAddress local_ip(192,168,1,1);
IPAddress gateway(192,168,1,1);
IPAddress subnet(255,255,255,0);

WebServer server(80);

WiFiUDP udp;

void setup() {
  Serial.begin(115200);

  // start the wifi server
  WiFi.softAP(ssid, password);
  WiFi.softAPConfig(local_ip, gateway, subnet);
  
  server.begin();
}

void loop(){

    // read sensor value from pin 34
    pin1Value = analogRead(34);

    Serial.println(pin1Value);

    // send packet
    udp.beginPacket("192.168.1.2",57222);
    udp.print(String(pin1Value));
    udp.endPacket();
  
  //Wait for 0.1 second
  delay(100);
  
}
