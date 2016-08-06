float resolucao;

enum VoltageRef {Defalut, Internal};

void settings(){
  VoltageRef referencia = Defalut;
  switch(referencia){
    case Defalut: resolucao = 0.0048828125;    break;
    case Internal: resolucao = 0.00107421875;     
  }
}
 
byte const SENSOR = A0;

void setup() {
  Serial.begin(9600);
  settings();
  //analogReference(INTERNAL);  //Só pode ser usada para tensão de referência de 1.1V
}

void loop() {
  int AD = analogRead(SENSOR);
  float tensao = AD*resolucao;
  Serial.print("AD: ");
  Serial.print(AD);
  Serial.print("\t\ttensao: ");
  Serial.println(tensao,6);
}
