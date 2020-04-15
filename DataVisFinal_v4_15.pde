/*
  @authors: Kevin Shaw, Isak Bjornson, Cole deSilva
  @assignment: Final Project
  @date: 4/13/2020
  @version: v1.0
*/

PImage map;
Table artistInfo;
//ArrayList<Integer> artistID;
int idIndex = 0;
float[][] buttons;


  
  String[] artistName;
  float[] lat;
  float[] lon;

void setup(){
  size(1280, 720);
  map = loadImage("EquiProjMap.png");
  map.resize(width-75, height);
  image(map, 0, 0);
  
  
  artistInfo = loadTable("Copy of artists_with_birthplace.csv", "header");
  
  artistName= new String[artistInfo.getRowCount()];
  lat = new float[artistInfo.getRowCount()];
  lon = new float[artistInfo.getRowCount()];
  
  for (int i = 0; i < artistInfo.getRowCount(); i++) {

     
     artistName[i] = artistInfo.getString(i,1);


     lat[i] = artistInfo.getFloat(i,9) - 90.0;
     
     lon[i] = artistInfo.getFloat(i,10) + 180.0;
     //println(lon[i]);
     
     buttonsCreate(lat, lon);

  }
  drawCities(lat, lon);
}

void draw() {
  
  //drawCities(lat, lon);
}

void buttonsCreate(float[] lat, float[] lon) {
  buttons = new float[lat.length][2];
  
  for (int n = 0; n < lat.length; n++){
    //println(lon[n]);
    buttons[n][0] = (lon[n]*(width/360.0))+10.0;
    buttons[n][1] = (lat[n]*(-height/180.0))-10.0;

  }
  
}

void mousePressed(){ 
  for (int id = 0; id < buttons.length; id++){
    if((mouseY > (buttons[id][1]) &&  mouseY<(buttons[id][1]+20.0))
    && (mouseX < (buttons[id][0]) &&  mouseX>(buttons[id][0]-20.0))){
       println("hazah!"); 
    }
    idIndex = id;
    //print(id);
  }
}


void drawCities(float[] lat, float[] lon){
   float hScale = height/180.0;
   float wScale = width/360.0;
   
   for (int j = 0; j < lon.length; j++){
     circle(lon[j]*wScale, lat[j]*(-hScale),10.0);
   }
}
