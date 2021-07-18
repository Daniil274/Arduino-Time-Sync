#include <TimeLib.h>
#include "GyverTM1637.h"

#define CLK 4
#define DIO 5

GyverTM1637 disp(CLK, DIO);

byte hours, minutes, seconds;
time_t t;

void setup() {
  Serial.begin(9600);
  disp.clear(); 
  disp.brightness(7);  // яркость, 0 - 7 (минимум - максимум)
  disp.clear();
  disp.displayByte(_c, _o , _1, _b);
}
void loop() {
// Читаем строку с unix time и переводим в нормальный формат времени
 boolean SerialReadFlag = true;
 while (SerialReadFlag) {
    if (Serial.available() > 0) {
      String tim = Serial.readString();
      t = tim.toInt();
      hours = hour(t);
      minutes = minute(t);
      seconds = second(t); 
      delay(500);
      SerialReadFlag = false;
    }
  }
  disp.point(true);
  // Код часов
  while (true) {
    if (seconds == 60) {
      seconds = 0;
      minutes++;
    }
    if (minutes == 60) {
      minutes = 0;
      hours++;
    }
    if (hours == 24) {
      hours = 0;
    }
    seconds++;
	// вывод на экран
    disp.displayClock(hours, minutes);
    disp.point(false);
    delay(500);
    disp.point(true);
    delay(500);
	// Вывод в Serial
    Serial.println();
    Serial.print("Время:");
    Serial.print(hours);
    Serial.print(":");
    Serial.print(minutes);
    Serial.print(":");
    Serial.print(seconds);
  };
}
