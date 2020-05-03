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
int[] popWork;

int maxPaintings;


boolean cityList = false;
boolean artTab = false;
int artTabIndex = -1;
//boolean artistList = false;


void setup(){
  size(1800, 900);
  //size(3000, 2000);
  map = loadImage("EquiProjMap.png");
  map.resize(width, int(0.853333333*height));
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
  popWork = new int[artistInfo.getRowCount()];
  
  
  for (int i = 0; i < artistInfo.getRowCount(); i++) {

     name[i] = artistInfo.getString(i,1);
     years[i] = artistInfo.getString(i,2);
     //println(artistInfo.getString(i,2));
     genre[i] = artistInfo.getString(i,3);
     nationality[i] = artistInfo.getString(i,4);
     bio[i] = artistInfo.getString(i,5);
     wikipedia[i] = artistInfo.getString(i,6);
     paintings[i] = artistInfo.getInt(i,7);
     birthplace[i] = artistInfo.getString(i,8);
     
     lat[i] = artistInfo.getFloat(i,9) - 101.5;
     lon[i] = artistInfo.getFloat(i,10) + 168.0;
     
     popWork[i] = artistInfo.getInt(i,11);
     
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
  //float tlon;
  //float tlat;
  
  for (int n = 0; n < lat.length; n++){
    
    buttons[n][0] = (lon[n]*(width/360.0))+10.0;
    buttons[n][1] = (lat[n]*(-height/180.0))-10.0;
  }
  
}

void mousePressed(){ 
  boolean cityListFlag = false;
  
  for (int x = 0; x < buttons.length; x++){
    if(cityList == false &&
    (mouseY > (buttons[x][1]) &&  mouseY < (buttons[x][1]+(0.0111*width)))
    && (mouseX < (buttons[x][0]) &&  mouseX > (buttons[x][0]-(0.0111*width)))){
      idIndex = new IntList();
    }
  }
  
  for (int id = 0; id < buttons.length; id++){
    if(cityList == false &&
    (mouseY > (buttons[id][1]) &&  mouseY < (buttons[id][1]+(0.0111*width)))
    && (mouseX < (buttons[id][0]) &&  mouseX > (buttons[id][0]-(0.0111*width)))){
       //println("hazah!");
       cityListFlag = true;
       idIndex.append(id);
       //println(id);
    }
  }
  
  if (cityList) { 
    for (int y = 0; y < picButton.length; y++) {
      //println(picButton.length);
      if ((mouseX > picButton[y][0] && mouseX < (picButton[y][0 ]+ (.1* width))) && (mouseY > picButton[y][1] && mouseY < height)){
        //println("woop");
        artTab = true;
        artTabIndex = int(picButton[y][2]);
        
      }
    }
  }
  
  if ((cityList) &&
  (mouseX < (0.1*width)) &&
  (mouseY < (0.05*height))) {
    cityList = false;
    idIndex.clear();
  }
  
  if (artTab &&
  ((mouseX > 0.88 * width) && (mouseX < 0.92 * width)) &&
  ((mouseY > 0.08 * height) && (mouseY < 0.12 * height))) {
    artTab = false;
  }
  
  
  if (cityListFlag) {
    cityList = true;
  }
  
}

/*void keyPressed() {
  if (keyCode == DOWN && cityList == true) {
    cityList = false; 
    idIndex.clear();
  }
}*/


int getMaxPaintings(IntList orderedList){
  int max = 0;
  for(int i = 0; i < orderedList.size(); i++){
    if(max < paintings[orderedList.get(i)]){
      max = paintings[orderedList.get(i)];
    }
  }
 
    return max;
}


void drawCities(float[] lat, float[] lon){
   fill(255);
   float hScale = height/180.0;
   float wScale = width/360.0;
   
   for (int j = 0; j < lon.length; j++){
     circle(lon[j]*wScale, lat[j]*(-hScale),(0.000005*(height*width)));
   }
}

void artistList() {
  IntList orderedList = orderArtistByCount();
  
  background(255);
  textSize(35);
  fill(0);
  
  int maxPaintings = getMaxPaintings(orderedList);
  //println(maxPaintings);
  
  picButton = new float[idIndex.size()][3];
  for (int i = 0; i < orderedList.size(); i++) {
    //println(orderedList.get(i));
    textSize(int(0.01367*width));
    fill(0);
    text(name[orderedList.get(i)], i*(0.15*width), (0.08*height));
    
    /*textSize(int(0.00967*width));
    fill(100,100,255);
    
    text("Birthplace:", i*(0.15*width), (0.15*height));
    fill(50,50,255);
    text(birthplace[orderedList.get(i)], i*(0.15*width), (0.18*height));*/
    
    float paint = paintings[orderedList.get(i)];
    //println(name[orderedList.get(i)] + ": " + paintings[orderedList.get(i)]);
    PImage artistImage = getArtistPopWork(orderedList.get(i));
    float ypct = paint / maxPaintings;
    //println(ypct + " " + name[orderedList.get(i)]);
    
    artistImage.resize(int (0.1*width), int(ypct * (height - (0.2*height))));
    image(artistImage, (i*(0.15*width)), height - artistImage.height);

    
    // rect((i*(0.15*width)+0.025), height-paint, (0.025*width), height);
    
    
    picButton[i][0] = (i*(0.15*width));
    picButton[i][1] = height - artistImage.height;
    picButton[i][2] = orderedList.get(i);
    //makePicClickable(20+(300*i), height-paint, 40, orderedList.get(i));
  }
  fill(255);
  stroke(0);
  rect(0,0,(0.1*width), (0.05*height));
  fill(0);
  textSize(int(0.01367*width));
  text("Back to Map", (0.007813*width),(0.033*height));
}
 
public PImage getArtistPopWork(int artistIndex){
  String artistName = name[artistIndex];
  String[] names = artistName.split(" ");
  int mostPopWork = popWork[artistIndex];
  
  String tempArtistName = "";
  for(int i = 0; i < names.length; i++){
    if(i != names.length - 1){
      tempArtistName += names[i] + "_";
    }
    else{
      tempArtistName += names[i];
    }
  }
  
  //println(tempArtistName);
  
  String imgPath = "images/" + tempArtistName + "/";
  imgPath += tempArtistName + "_" + mostPopWork + "_popular.jpg";
  //println(imgPath);
  
  return loadImage(imgPath);
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

void artistTable(int artistIndex) {
  float boxWidth;
  float boxHeight;
  
  fill(100);
  rect((0.1*width),(0.1*height),(0.8*width),(0.8*height));
  fill(0);
  rect((0.88*width),(0.08*height),(0.04*width),(0.04*height));
  
  fill(255);
  textSize(int(0.00767*width));
  text(name[artistIndex],(0.12*width),(0.15*height));
  text("Birthplace: " + birthplace[artistIndex], (0.12*width), (0.18*height)); 
  text("Nationality: " + nationality[artistIndex], (0.12*width), (0.21*height));
  text("Years: " + years[artistIndex], (0.12*width), (0.24*height));
  text("Genre: " + genre[artistIndex], (0.12*width), (0.27*height));
  text("Number of paitnings: " + paintings[artistIndex], (0.12*width), (0.3*height));
  text("Wikipedia Link: " + wikipedia[artistIndex], (0.12*width), (0.33*height));
  text("Biogrphy: " + bio[artistIndex], (0.12*width), (0.36*height),(0.3*width), (0.6*height));
  

  
}
