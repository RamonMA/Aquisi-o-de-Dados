float const RESOLUCAO = 0.0048828125;   //Tensão de Voltagem 5v e 10bits de resolução do arduino
byte const SENSOR = A0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int AD = analogRead(SENSOR);
  float tensao = AD*RESOLUCAO;
  Serial.print("AD: ");
  Serial.print(AD);
  Serial.print("tensao: ");
  Serial.print(tensao);
}
