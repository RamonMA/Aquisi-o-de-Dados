//RFID - Controle de Acesso com leitor RFID 13.56
 
//Biblioteca do protocolo SPI
#include <SPI.h>
//Biblioteca do RFID
#include <MFRC522.h>
 
//Pinos de definição
#define SS_PIN 10
#define RST_PIN 9
//Cria a instacia do RFID (mfrc522)
MFRC522 mfrc522(SS_PIN, RST_PIN);  
 
int pinopir = 6;  //Pino ligado ao sensor PIR
int acionamento;  //Variavel para guardar valor do sensor
int buzzer  = 5;
int led = 7;
bool alarme_ativado = false;
bool detectado = false;
String conteudo= "";
boolean tagVerificada = false;
//Aqui colocamos as Tags que desejamos autorizar
String tagsCadastrada[2] ={"D7 A2 33 3B","9B 7C 43 41"};

void setup()
{
  // Inicia a serial
  Serial.begin(9600);
  //inicia a conexão SPI
  SPI.begin();  
  // Inicia MFRC522  
  mfrc522.PCD_Init();  
  Serial.println();
  //Metodo inicial (Menu)
  mensageminicial();
}
 
void loop()
{
 
  //Aguarda proximidade do cartão / tag
  bool leitura = lerCartao();
  if(leitura || alarme_ativado == true){
    if(leitura){
      //Mostra UID na serial
      Serial.print("UID da tag :");
      //String que armazenará o UID do cartão
      conteudo= "";
      //variavel que coletará os bytes lidos
      byte letra;
     
      //dentro deste FOR, armazena byte a byte e
      //concatena na variavel conteudo
    
      for (byte i = 0; i < mfrc522.uid.size; i++)
      {
         Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
         Serial.print(mfrc522.uid.uidByte[i], HEX);
         conteudo.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
         conteudo.concat(String(mfrc522.uid.uidByte[i], HEX));
      }
    
      Serial.println();
    
      //booleana que valida a tag lida
      //como autorizada ou não
      tagVerificada = false;
   
   
      Serial.print("Leitura : ");
   
      //coloca o valor da variavel conteudo toda em Maisculo
      conteudo.toUpperCase();
   }
    //verifica se a tag lida coincide com uma das tags
    //cadastada no array
   for(int indice =0; indice < sizeof(tagsCadastrada); indice++){
    //if (conteudo.substring(1) == "24 B4 8B 19") //UID 1
     if (conteudo.substring(1) == tagsCadastrada[0]) //UID 1
     {
      //tag encontrada
      tagVerificada = true;
      //Incia o processo novamente
      if(leitura){
        mensageminicial();
        //limpa a String conteudo para fazer nova leitura
        conteudo= "";
      }
      if(leitura)
        alarme_ativado = !alarme_ativado;
      
      if(leitura && alarme_ativado){  
        Serial.println("Alarme ativado");
        delay(1500);
      }
      else if(alarme_ativado == false){
        Serial.println("Alarme desativado");
        noTone(buzzer);
        detectado = false;
        digitalWrite(led,LOW);
        delay(2000);
       }
     }
    
      if((tagVerificada == false)&&(conteudo != "")){
       
        //Se ambas condições forem verdadeira
        //imprime no LCD e na Serial uma mensagem de negação ao usuario
        Serial.println("Usuario Desconhecido! ");
        Serial.println("Acesso Negado!!");
    
        //Incia o processo novamente
        mensageminicial();
        //limpa a String conteudo para fazer nova leitura
        conteudo= "";
      }
    }
    if(alarme_ativado){
      if(!detectado)
        detectado = isDetected();               
      if(detectado){
        tone(buzzer, 493.9);
        delay(300);
        tone(buzzer,622.3);
        delay(100);
        noTone(buzzer);
        delay(100);
        digitalWrite(led, HIGH);
      }
    }
  }
}
//Metodo Inicial que informa ao usuario o que deve ser feito   
void mensageminicial()
{
  Serial.println();
  Serial.println("Aproxime o seu cartao de leitor");
  Serial.println();
}

boolean isDetected(){
  if (digitalRead(pinopir) == LOW)               //Sem movimento, mantem led azul ligado
    return false;
  else{                                   //Caso seja detectado um movimento, aciona o led vermelho
    return true; 
 }
}
bool lerCartao(){
  if(!mfrc522.PICC_IsNewCardPresent()) 
    return false; 
  
  //Seleciona o cartão / tag
  if(!mfrc522.PICC_ReadCardSerial()) 
    return false;
  else 
    return true;
}
