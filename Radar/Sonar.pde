public class Sonar {
  private static final float ARC_WIDTH = 600;
  private static final float ARC_HEIGHT = 600;
  private static final float RAD_MEASURE = 0.26;
  private static final int TIME_UP = 5;
  private static final float SPEED = 0.04;
  private static final int xPos = 250;
  private static final int yPos = 450;
  private static final int OBJETO = 6;
  private static final float ESCALA = 0.6;
  private static final int GRAU_MAX = 360;
  //private static final int GRAU_MIN = 0;
  private static final float BEGIN = -HALF_PI;

  private Ajuste ajuste;
  private float degrees;
  private float count;
  private float range_limit;
  private int start;

  public Sonar(PApplet app, String user_dir) {
    count = 0;
    range_limit = 600*ESCALA;
    start = millis();
    ajuste = new Ajuste(app, user_dir);
    fill(0, 30, 0, 149);
    stroke(0, 255, 0);
    ellipse(xPos, yPos, 600*ESCALA, 600*ESCALA);
  }

  //Métodos privados

  private void drawCircles() {
    stroke(0, 80, 0, 10);
    noFill();
    ellipse(xPos, yPos, ESCALA*100, ESCALA*100);
    ellipse(xPos, yPos, ESCALA*200, ESCALA*200);
    ellipse(xPos, yPos, ESCALA*300, ESCALA*300);
    ellipse(xPos, yPos, ESCALA*400, ESCALA*400);
    ellipse(xPos, yPos, ESCALA*500, ESCALA*500);
    ellipse(xPos, yPos, ESCALA*500, ESCALA*500);
    ellipse(xPos, yPos, ESCALA*600, ESCALA*600);
  }

  private void drawCoordinates() {
    stroke(0, 150, 0, 10);
    float x1 = xPos + 212*ESCALA;  
    float x2 = xPos - 212*ESCALA;
    float y1 = yPos + 212*ESCALA;  
    float y2 = yPos - 212*ESCALA;
    line(xPos, yPos+300*ESCALA, xPos, yPos-300*ESCALA);
    line(xPos-300*ESCALA, yPos, xPos+300*ESCALA, yPos);
    line(x1, y2, x2, y1);
    line(x2, y2, x1, y1);
  }

  private void drawRange() {
    float xPos = this.xPos-20*ESCALA;
    textSize(10*ESCALA);
    fill(0, 130, 10);
    text("100", xPos, this.yPos-52*ESCALA);
    text("200", xPos, this.yPos-102*ESCALA);
    text("300", xPos, this.yPos-152*ESCALA);
    text("400", xPos, this.yPos-202*ESCALA);
    text("500", xPos, this.yPos-252*ESCALA);
  }

  private void drawDegrees() {
    textSize(15*(ESCALA));
    fill(0, 255, 0);
    text("00º", xPos-15*ESCALA, yPos-305*ESCALA);
    text("45º", xPos+213*ESCALA, yPos-211*ESCALA);
    text("90º", xPos+305*ESCALA, yPos);
    text("135º", xPos+215*ESCALA, yPos+220*ESCALA);
    text("180º", xPos-20*ESCALA, yPos+315*ESCALA);
    text("225º", xPos-250*ESCALA, yPos+225*ESCALA);
    text("270º", xPos-337*ESCALA, yPos);
    text("315º", xPos-245*ESCALA, yPos-221*ESCALA);
  }

  private boolean isBurned() {
    if (millis() - start >= TIME_UP) {
      start = millis();
      return true;
    }
    return false;
  }

  private void rastrear() {
    fill(10, 48, 10, 20);
    arc(this.xPos,
        this.yPos,
        ARC_WIDTH*ESCALA,
        ARC_HEIGHT*ESCALA,
        getRadsNow(true) + BEGIN,
        RAD_MEASURE +  getRadsNow(true) + BEGIN);
    
    fill(0,19,0,31);
    arc(this.xPos,
        this.yPos,
        ARC_WIDTH*ESCALA,
        ARC_HEIGHT*ESCALA,
        getRadsNow(true) + BEGIN + RAD_MEASURE,
        2*RAD_MEASURE +  getRadsNow(true) + BEGIN);
        
    fill(0,19,0,31);
    arc(this.xPos,
        this.yPos,
        ARC_WIDTH*ESCALA,
        ARC_HEIGHT*ESCALA,
        getRadsNow(true) + BEGIN - RAD_MEASURE,
        getRadsNow(true) + BEGIN);
  }

  private float getRadsNow() {
    if (isBurned())
      count += SPEED;
    if (count == GRAU_MAX)
      count = 0;
    return count + BEGIN;
  }

  private float getRadsNow(boolean b) {
    return radians(this.degrees);
  }


  //Métodos públicos

  public void setDegrees(float degrees) {
    this.degrees = degrees;
  }   

  public void detected(String obj) {
    int position =0;  
    try {
      position = (int)Float.parseFloat(obj);
    }
    //Multiple Point
    catch(NumberFormatException mp) {
      int index = obj.length();
      if (index > 0) {
        for (int i=0; i<obj.length(); i++) {
          if (obj.charAt(i) == '.') {
            index = i;
            break;
          }
        }
        String str = obj.substring(0, index);
        position = (int)Float.parseFloat(str);
      }
    }

    //Printa o objeto detectado
    if (position <= range_limit) {
      stroke(0, 255, 0);
      fill(0, 255, 0,255);
      ellipse(this.xPos + (position>>1)*cos(getRadsNow(true) + BEGIN + RAD_MEASURE/2), 
        this.yPos + (position>>1)*sin(getRadsNow(true) + BEGIN + RAD_MEASURE/2), 
        OBJETO*ESCALA, 
        OBJETO*ESCALA);

      ajuste.addData(obj);
    }
  }

  public void draw() {
    ajuste.draw();
    drawCircles();
    drawCoordinates();
    drawRange();
    drawDegrees();
    rastrear();
  }

  public String readSerialSequence(String serial, char begin) {
    int ini=0;
    int tamanho = serial.length();
    boolean encontrou = false;

    for (int i=0; i<tamanho; i++) {
      if (serial.charAt(i) == begin) {
        encontrou = true;
        ini = i+1;
        break;
      }
    }
    if (encontrou) {
      for (int i=ini; i<tamanho; i++) {
        if (serial.charAt(i) >= 65 && serial.charAt(i) <= 90) {
          return serial.substring(ini, i);
        }
      }
      if (serial.charAt(tamanho-1) >= 48 && serial.charAt(tamanho-1) <= 57) {
        return serial.substring(ini);
      }
    }
    return null;
  }
}