import controlP5.*;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.NoSuchElementException;

public class Ajuste{
  private ControlP5 cp5;
  private Button play;
  private Button stop;
  private Button pause;
  private LinkedList<String> datas;
  private ListIterator<String> it;
  private String user_dir;
  private boolean paused;

  public Ajuste(PApplet app, String user_dir) {
    cp5 = new ControlP5(app);
    this.user_dir = user_dir;
    play = cp5.addButton("Play");
    stop = cp5.addButton("Stop");
    pause = cp5.addButton("Pause");
    datas = new LinkedList<String>();
    drawStopButton();
    setPlayButton();
    setPauseButton();
    paused = false;
  }

  private void setPlayButton() {
    PImage playImage = loadImage(user_dir+"/Imagens/play-32px.png");
    play.setPosition(50, 210)
      .setImage(playImage)
      .setSize(playImage)
      .setVisible(false)
      .setSwitch(true)
      .setOff();
  }

  private void setPauseButton() {
    PImage pauseImage = loadImage(user_dir+"/Imagens/pause-32px.png");
    pause.setPosition(50, 210)
      .setImage(pauseImage)
      .setSize(pauseImage)
      .setSwitch(true)
      .setVisible(true)
      .setOn();
  }

  private void drawMoldura() {
    stroke(0, 255, 0);
    fill(0, 255, 0);
    textSize(15);
    text("AJUSTES", 60, 60);
    line(30, 30, 150, 30);
    line(150, 30, 150, 200);
    line(150, 200, 30, 200);
    line(30, 200, 30, 30);
  }

  public void switchFlagsButton(Button turnOn, Button turnOff) {
    turnOff.setVisible(false);
    turnOff.hide();
    fill(0, 0, 0);
    stroke(0, 0, 0);
    quad(50, 210, 80, 210, 80, 250, 50, 250);
    turnOn.setVisible(true);
  } 

  private String createFilePath() {
    int time = hour();
    String fileName = "data__" +Integer.toString(time) + "h-";
    time = minute();
    fileName += Integer.toString(time) + "m-";
    time = second();
    fileName += Integer.toString(time) + "s__";
    time = day();
    fileName += Integer.toString(time) + "d-";
    time = month();
    fileName += Integer.toString(time) + "m-";
    time = year();
    fileName += Integer.toString(time) + "y.txt";
    fileName = user_dir+"/Dados/"+fileName;
    return fileName;
  }

  private void eventStopButton() {
    String fileName = createFilePath();
    try {
      for (int i=0; i<25; i++)  datas.removeFirst();
      if (datas.size() > 0) {
        it = datas.listIterator();
        createOutput(fileName);
        String[] list = new String[datas.size()];
        while (it.hasNext())  list[it.nextIndex()] = it.next();
        saveStrings(fileName, list);
        flush();
      }
    }
    catch(NoSuchElementException e) {
      print("O programa não foi executado ");
      println("em tempo suficiente.");
      println("Dados não Salvos!");
    }
    finally {
      exit();
    }
  }

  private void drawStopButton() {   
    PImage stopImage = loadImage(user_dir+"/Imagens/stop-32px.png");
    stop.setPosition(100, 210)
      .setImage(stopImage)
      .setSize(stopImage)
      .unlock();
  }

  public void noPaused() {
    loop();
    if (paused) {
      switchFlagsButton(play, pause);
      paused = false;
    } else
      switchFlagsButton(pause, play);
  }

  public void addData(String obj) {
    datas.add(obj);
  }

  public void draw() {
    drawMoldura();
    if (stop.isPressed())
      eventStopButton();
    if (pause.isPressed()) {
      switchFlagsButton(play, pause);
      paused = true;
      noLoop();
    }
  }
}