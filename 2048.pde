color backgr;
Grid grid = new Grid();
//width = 1028
//height = 698

bool detectando = false;
int direccion;
//arriba = 1
//derecha = 2
//abajo = 3
//izquierda = 4
float distanciaRecorrida = 0;
bool isSwiped = false;

void setup() {
   size(screenWidth, screenHeight);
   backgr = color(random(256), random(256), random(256));
   textAlign(CENTER,CENTER);
   textSize(40);
   strokeWeight(2);
}

void draw() {
   background(backgr);
   DetectarSwipe();
   fill(170);
   rect(165,0,698,698);
   //rect(185,20,658,658);
   grid.DrawBoxes();
}

void DetectarSwipe(){
   if(mousePressed){
      if(!isSwiped && grid.mb.size() == 0){
         if(abs(mouseX - pmouseX) - abs(mouseY - pmouseY) > 0){
            if(mouseX - pmouseX > 0){
               if(direccion != 2){
                  direccion = 2;
                  distanciaRecorrida = 0;
                  distanciaRecorrida += mouseX - pmouseX;
               }
               else {
                  distanciaRecorrida += mouseX - pmouseX;
                  OnDistanciaRecorrida();
               }
            }
            else if(mouseX - pmouseX < 0){
               if(direccion != 4){
                  direccion = 4;
                  distanciaRecorrida = 0;
                  distanciaRecorrida += pmouseX - mouseX;
               }
               else {
                  distanciaRecorrida += pmouseX - mouseX;
                  OnDistanciaRecorrida();
               }
            }
         }
         else if(abs(mouseX - pmouseX) - abs(mouseY - pmouseY) < 0){
            if(mouseY - pmouseY > 0){
               if(direccion != 3){
                  direccion = 3;
                  distanciaRecorrida = 0;
                  distanciaRecorrida += mouseY - pmouseY;
               }
               else {
                  distanciaRecorrida += mouseY - pmouseY;
                  OnDistanciaRecorrida();
               }
            }
            else if(mouseY - pmouseY < 0){
               if(direccion != 1){
                  direccion = 1;
                  distanciaRecorrida = 0;
                  distanciaRecorrida += pmouseY - mouseY;
               }
               else {
                  distanciaRecorrida += pmouseY - mouseY;
                  OnDistanciaRecorrida();
               }
            }
         }
      }
   }
   else isSwiped = false;
}


void OnDistanciaRecorrida(){
   if(distanciaRecorrida > 100){
      isSwiped = true;
      distanciaRecorrida = 0;
      switch(direccion){
         case 1:
         grid.SwipeUp();
         break;
         case 2:
         grid.SwipeRight();
         break;
         case 3:
         grid.SwipeDown();
         break;
         case 4:
         grid.SwipeLeft();
         break;
      }
   }
}

class Grid {
   
   Box[] boxes = new Box[16];
   ArrayList<MovingBox> mb = new ArrayList<MovingBox>();
   
   Grid() {
      for(int i = 0; i < 16; i++){
         boxes[i] = new Box();
         switch(i % 4){
            case 0:
            boxes[i].x = 185;
            break;
            case 1:
            boxes[i].x = 354.5;
            break;
            case 2:
            boxes[i].x = 524;
            break;
            case 3:
            boxes[i].x = 693.5;
            break;
         }
         switch((i - (i % 4)) / 4){
            case 0:
            boxes[i].y = 20;
            break;
            case 1:
            boxes[i].y = 189.5;
            break;
            case 2:
            boxes[i].y = 359;
            break;
            case 3:
            boxes[i].y = 528.5;
            break;
         }
      }
      RandomNumberNewBox();
      RandomNumberNewBox();
      for(int i = 0; i < 16; i++) boxes[i].last = false;
   }
   
   void RandomNumberNewBox(){
      for(int i = 0; i < 16; i++) boxes[i].last = false;
      int rndm1 = RandomNumber(16);
      int rndm2 = RandomNumber(4);
      if(boxes[rndm1].value == 0){
         if(rndm2 == 0) boxes[rndm1].value = 4;
         else boxes[rndm1].value = 2;
         boxes[rndm1].last = true;
      }
      else RandomNumberNewBox();
   }
   
   int RandomNumber(int max){
      float number = random(max);
      for(int i = 1; i < max + 1; i++){
         if(number < i) return i - 1;
      }
   }
   
   void DrawBoxes(){
      for(int i = mb.size() - 1; i >= 0; i--){
         mb.get(i).UpdatePos();
         if(mb.get(i).IsFinished()){
            boxes[mb.get(i).newBoxIndex].value += mb.get(i).value;
            mb.remove(i);
            if(mb.size() == 0) RandomNumberNewBox();
         }
      }
      
      for(int i = 0; i < 16; i++){
         switch(boxes[i].value){
            case 0:
            fill(255);
            break;
            case 2:
            fill(#EEE4DA);
            break;
            case 4:
            fill(#EDE0C8);
            break;
            case 8:
            fill(#F2B179);
            break;
            case 16:
            fill(#F59563);
            break;
            case 32:
            fill(#F67C60);
            break;
            case 64:
            fill(#F65E3B);
            break;
            case 128:
            fill(#EDCF73);
            break;
            case 256:
            fill(#EDCC62);
            break;
            case 512:
            fill(#EDC850);
            break;
            case 1024:
            fill(#EDC53F);
            break;
            case 2048:
            fill(#EDC22D);
            break;
            default:
            fill(#EDC22D);
            break;
         }
         if(boxes[i].last) stroke(255, 233, 0);
         rect(boxes[i].x, boxes[i].y, Box.grosor, Box.grosor, Box.smoothing);
         stroke(0);
         if(boxes[i].value != 0){
            fill(0);
            text(boxes[i].value, boxes[i].x + Box.grosor/2, boxes[i].y + Box.grosor/2);
         }
      }
      
      for(int i = mb.size() - 1; i >= 0; i--){
         if(!mb.get(i).IsFinished()){
            switch(mb.get(i).value){
               case 2:
               fill(#EEE4DA);
               break;
               case 4:
               fill(#EDE0C8);
               break;
               case 8:
               fill(#F2B179);
               break;
               case 16:
               fill(#F59563);
               break;
               case 32:
               fill(#F67C60);
               break;
               case 64:
               fill(#F65E3B);
               break;
               case 128:
               fill(#EDCF73);
               break;
               case 256:
               fill(#EDCC62);
               break;
               case 512:
               fill(#EDC850);
               break;
               case 1024:
               fill(#EDC53F);
               break;
               case 2048:
               fill(#EDC22D);
               break;
               default:
               fill(#EDC22D);
               break;
            }
            rect(mb.get(i).x, mb.get(i).y, Box.grosor, Box.grosor, Box.smoothing);
            fill(0);
            text(mb.get(i).value, mb.get(i).x + Box.grosor/2, mb.get(i).y + Box.grosor/2);
         }
      }
   }
   
   void SwipeUp(){
      int[] box = new int[16];
      bool[] isSumado = new bool[16];
      for(int i = 0; i < 16; i++){
         box[i] = boxes[i].value;
         isSumado[i] = false;
      }
      for(int j = 0; j < 4; j++){
         for(int i = 1; i < 4; i++){
            if(box[j + i*4] != 0){
               for(int k = i-1; k >= 0; k--){
                  if(box[j + k*4] != 0){
                     if(box[j + k*4] == box[j + i*4] && !isSumado[j + k*4]){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, j + k*4, 1));
                        box[j + k*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        isSumado[j + k*4] = true;
                     }
                     break; 
                  }
                  else {
                     if(k == 0){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, j + k*4, 1));
                        box[j + k*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        break;
                     }
                     if(box[j + (k - 1)*4] != 0 && (box[j + (k - 1)*4] != box[j + i*4] || isSumado[j + (k - 1)*4])){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, j + k*4, 1));
                        box[j + k*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        break;
                     }
                  }
               }
            }
         }
      }
   }
   
   void SwipeDown(){
      int[] box = new int[16];
      bool[] isSumado = new bool[16];
      for(int i = 0; i < 16; i++){
         box[i] = boxes[i].value;
         isSumado[i] = false;
      }
      for(int j = 0; j < 4; j++){
         for(int i = 2; i >= 0; i--){
            if(box[j + i*4] != 0){
               for(int k = i+1; k < 4; k++){
                  if(box[j + k*4] != 0){
                     if(box[j + k*4] == box[j + i*4] && !isSumado[j + k*4]){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, j + k*4, 3));
                        box[j + k*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        isSumado[j + k*4] = true;
                     }
                     break;
                  }
                  else {
                     if(k == 3){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, j + k*4, 3));
                        box[j + k*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        break;
                     }
                     else if(box[j + (k + 1)*4] != 0 && (box[j + (k + 1)*4] != box[j + i*4] || isSumado[j + (k + 1)*4])){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, j + k*4, 3));
                        box[j + k*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        break;
                     }
                  }
               }
            }
         }
      }
   }
   
   void SwipeLeft(){
      int[] box = new int[16];
      bool[] isSumado = new bool[16];
      for(int i = 0; i < 16; i++){
         box[i] = boxes[i].value;
         isSumado[i] = false;
      }
      for(int i = 0; i < 4; i++){
         for(int j = 1; j < 4; j++){
            if(box[j + i*4] != 0){
               for(int k = j-1; k >= 0; k--){
                  if(box[k + i*4] != 0){
                     if(box[k + i*4] == box[j + i*4] && !isSumado[k + i*4]){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, k + i*4, 4));
                        box[k + i*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        isSumado[k + i*4] = true;
                     }
                     break;
                  }
                  else {
                     if(k == 0){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, k + i*4, 4));
                        box[k + i*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        break;
                     }
                     else if(box[k - 1 + i*4] != 0 && (box[k - 1 + i*4] != box[j + i*4] || isSumado[k - 1 + i*4])){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, k + i*4, 4));
                        box[k + i*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        break;
                     }
                  }
               }
            }
         }
      }
   }
   
   void SwipeRight(){
      int[] box = new int[16];
      bool[] isSumado = new bool[16];
      for(int i = 0; i < 16; i++){
         box[i] = boxes[i].value;
         isSumado[i] = false;
      }
      for(int i = 0; i < 4; i++){
         for(int j = 2; j >= 0; j--){
            if(box[j + i*4] != 0){
               for(int k = j+1; k < 4; k++){
                  if(box[k + i*4] != 0){
                     if(box[k + i*4] == box[j + i*4] && !isSumado[k + i*4]){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, k + i*4, 2));
                        box[k + i*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        isSumado[k + i*4] = true;
                     }
                     break;
                  }
                  else {
                     if(k == 3){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, k + i*4, 2));
                        box[k + i*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        break;
                     }
                     else if(box[k + 1 + i*4] != 0 && (box[k + 1 + i*4] != box[j + i*4] || isSumado[k + 1 + i*4])){
                        mb.add(new MovingBox(box[j + i*4], j + i*4, k + i*4, 2));
                        box[k + i*4] += box[j + i*4];
                        box[j + i*4] = 0;
                        boxes[j + i*4].value = 0;
                        break;
                     }
                  }
               }
            }
         }
      }
   }
}

class Box {
   int value = 0;
   float x;
   float y;
   static float grosor = 149.5;
   static float smoothing = 28;
   bool last = false; 
   Box() {
      
   }
}

class MovingBox extends Box {
   
   int newBoxIndex;
   int sentido;
   float velocidad = 35;
   
   MovingBox(int _value, int _boxIndex, int _newBoxIndex, int _sentido) {
      value = _value;
      x = grid.boxes[_boxIndex].x;
      y = grid.boxes[_boxIndex].y;
      newBoxIndex = _newBoxIndex;
      sentido = _sentido;
   }
   
   void UpdatePos(){
      switch(sentido){
         case 1:
         y -= velocidad;
         break;
         case 2:
         x += velocidad;
         break;
         case 3:
         y += velocidad;
         break;
         case 4:
         x -= velocidad;
         break;
      }
   }
   
   bool IsFinished(){
      switch(sentido){
         case 1:
         if(y < grid.boxes[newBoxIndex].y){
            return true;
         }
         break;
         case 2:
         if(x > grid.boxes[newBoxIndex].x){
            return true;
         }
         break;
         case 3:
         if(y > grid.boxes[newBoxIndex].y){
            return true;
         }
         break;
         case 4:
         if(x < grid.boxes[newBoxIndex].x){
            return true;
         }
         break;
      }
      return false;
   }
}
