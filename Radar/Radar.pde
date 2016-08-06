import processing.serial.*;
//import java.lang.System;

Sonar sonar;
Serial myPort;
String val[];
//private int width;
//private int height;
//private int xPos;
//private int yPos;

void settings() { 
  size(500, 750);
}

void setup() {
  frameRate(40);
  surface.setLocation(30, 20);
  background(0);
  String path = "C:/Users/Almeida/Documents/Processing/Radar";
  sonar = new Sonar(this, path);

  try { 
    myPort = new Serial(this, Serial.list()[0], 9600);
    delay(500);
    pegarLixo();
  }
  //ArrayIndexOutOfBoundsException
  catch(ArrayIndexOutOfBoundsException e) {
    println("Arduino não conectado!");
    exit();
  }
}

void draw() {
  sonar.draw();

  if (myPort.available() > 0) {
    String serial = myPort.readString();
    String distancia = sonar.readSerialSequence(serial, 'D');
    String radar = sonar.readSerialSequence(serial, 'G'); 
    println("distancia:"+distancia);
    println("grau:"+radar);
    if(distancia != null)
      sonar.detected(distancia);
    if(radar != null)  
      sonar.setDegrees(Float.parseFloat(radar));
  }
}

void pegarLixo(){
  for(int i=0; i<10; i++){
    if (myPort.available() > 0 ){
     String lixo = myPort.readString();
     }
  }
}

void mousePressed() {
   sonar.ajuste.noPaused();
}