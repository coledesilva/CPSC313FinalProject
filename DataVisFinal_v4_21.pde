/*
  @authors: Kevin Shaw, Isak Bjornson, Cole deSilva
  @assignment: Final Project
  @date: 4/13/2020
  @version: v1.0
*/

PImage map;
Table artistInfo;
IntList idIndex;
float[][] buttons;
float picButton[][];

String[] name;
String[] years;
String[] genre;
String[] nationality;
String[] bio;
String[] wikipedia;
int[] paintings;
String[] birthplace;
float[] lat;
float[] lon;


boolean cityList = false;
boolean artTab = false;
int artTabIndex = -1;
//boolean artistList = false;


void setup(){
  size(2560, 1500);
  map = loadImage("EquiProjMap.png");
  map.resize(width, 1280);
  image(map, 0, 0);
  
  
  artistInfo = loadTable("artists_with_birthplace.csv", "header");
  
  name = new String[artistInfo.getRowCount()];
  years = new String[artistInfo.getRowCount()];
  genre = new String[artistInfo.getRowCount()];
  nationality = new String[artistInfo.getRowCount()];
  bio = new String[artistInfo.getRowCount()];
  wikipedia = new String[artistInfo.getRowCount()];
  paintings = new int[artistInfo.getRowCount()];
  birthplace = new String[artistInfo.getRowCount()];
  lat = new float[artistInfo.getRowCount()];
  lon = new float[artistInfo.getRowCount()];
  
  
  for (int i = 0; i < artistInfo.getRowCount(); i++) {

     name[i] = artistInfo.getString(i,1);
     years[1] = artistInfo.getString(i,2);
     genre[i] = artistInfo.getString(i,3);
     nationality[i] = artistInfo.getString(i,4);
     bio[i] = artistInfo.getString(i,5);
     wikipedia[i] = artistInfo.getString(i,6);
     paintings[i] = artistInfo.getInt(i,7);
     birthplace[i] = artistInfo.getString(i,8);
     
     lat[i] = artistInfo.getFloat(i,9) - 101.5;
     lon[i] = artistInfo.getFloat(i,10) + 168.0;
     
     buttonsCreate(lat, lon);

  }
  drawCities(lat, lon);
}

void draw() {

  if (cityList && !artTab){
    artistList();
  } else if (artTab) {
    artistTable(artTabIndex);
  } else {
    background(200,200,200);
    image(map, 0, 0);
    drawCities(lat, lon);
  }
}

void buttonsCreate(float[] lat, float[] lon) {
  buttons = new float[lat.length][2];
  
  for (int n = 0; n < lat.length; n++){
    buttons[n][0] = (lon[n]*(width/360.0))+10.0;
    buttons[n][1] = (lat[n]*(-height/180.0))-10.0;

  }
  
}

void mousePressed(){ 
  boolean cityListFlag = false;
  
  for (int x = 0; x < buttons.length; x++){
    if(cityList == false &&
    (mouseY > (buttons[x][1]) &&  mouseY < (buttons[x][1]+20.0))
    && (mouseX < (buttons[x][0]) &&  mouseX > (buttons[x][0]-20.0))){
      idIndex = new IntList();
    }
  }
  
  for (int id = 0; id < buttons.length; id++){
    if(cityList == false &&
    (mouseY > (buttons[id][1]) &&  mouseY < (buttons[id][1]+20.0))
    && (mouseX < (buttons[id][0]) &&  mouseX > (buttons[id][0]-20.0))){
       //println("hazah!");
       cityListFlag = true;
       idIndex.append(id);
       //println(id);
    }
  }
  
  if (cityList) { 
    for (int y = 0; y < picButton.length; y++) {
      //println(picButton.length);
      if ((mouseX > picButton[y][0] && mouseX < (picButton[y][0]+40)) && (mouseY > picButton[y][1] && mouseY < height)){
        println("woop");
        artTab = true;
        artTabIndex = int(picButton[y][2]);
        
      }
    }
  }
  
  if (cityListFlag) {
    cityList = true;
  }
  
}

void keyPressed() {
  if (keyCode == DOWN && cityList == true) {
    cityList = false; 
    idIndex.clear();
  }
}



void drawCities(float[] lat, float[] lon){
   fill(255);
   float hScale = height/180.0;
   float wScale = width/360.0;
   
   for (int j = 0; j < lon.length; j++){
     circle(lon[j]*wScale, lat[j]*(-hScale),10.0);
   }
}

void artistList() {
  IntList orderedList = orderArtistByCount();
  
  background(255);
  textSize(20);
  fill(0);
  
  picButton = new float[idIndex.size()][3];
  for (int i = 0; i < orderedList.size(); i++) {
    //println(orderedList.get(i));
    text(name[orderedList.get(i)], 20+(300*i), 30);
    float paint = paintings[orderedList.get(i)];
    
    rect(20+(300*i), height-paint, 40, height);
    
    
    picButton[i][0] = 20+(300*i);
    picButton[i][1] = height-paint;
    picButton[i][2] = orderedList.get(i);
    //makePicClickable(20+(300*i), height-paint, 40, orderedList.get(i));
  }
}
  

IntList orderArtistByCount() {
  IntList tempList = new IntList();
  IntList tempList2 = new IntList();
  
  
  for (int j=0; j < idIndex.size(); j++) {
    tempList2.append(paintings[idIndex.get(j)]);
    //println(paintings[idIndex.get(j)]);
  }
  tempList2.sort();
  tempList2.reverse();
  
  for (int i = 0; i < tempList2.size(); i++){
    for (int k = 0; k < paintings.length; k++) {
      
      if (tempList2.get(i)==paintings[k] && idIndex.hasValue(k)){
        tempList.append(k);
        //tempList2.set(i,0);
      }
    }
  }
  //println(tempList2);
  return tempList;
}

/*void makePicClickable(float x, float y, float wid, int id) {
  picButton = new float[idIndex.size()][4];
  
  for (int n = 0; n < picButton.length; n++){
    picButton[n][0] = x;
    picButton[n][1] = y;
    picButton[n][2] = wid;
    picButton[n][3] = id;

  }
  //println(picButton.length);
  
}*/

void artistTable(int artistIndex) {
  
  fill(0);
  rect(300,200,1960,1100);
  
  fill(255);
  text(name[artistIndex],1000,500);
  
}
