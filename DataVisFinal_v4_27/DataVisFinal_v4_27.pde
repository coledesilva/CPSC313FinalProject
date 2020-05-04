/*
  @authors: Kevin Shaw, Isak Bjornson, Cole deSilva
  @assignment: Final Project
  @date: 5/3/2020
  @version: v1.0
*/

// global vars
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

boolean artistLink = false;
boolean cityList = false;
boolean artTab = false;
int artTabIndex = -1;


int startingWork;
int imagePageNum;

void setup(){
  size(1800, 900);
  map = loadImage("EquiProjMap.png");
  // we resized the map because it did not fit the equirectangular projection
  map.resize(width, int(0.853333333*height));
  image(map, 0, 0);
  
  // increment variables for scrolling through artist' paintings
  startingWork = 1;
  imagePageNum = 1;
  
  // loading our csv file
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
  
  // filling our list variables with csv info
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
  
  // drawing each city on map
  drawCities(lat, lon);
}

void draw() {

  // checking what screen to display
  // artistList is the bar graphof artists in a city
  // artistTable is the table of information for a particular artist
  // else statement is default screen (map screen)
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

// creating buttons for each city on the map
void buttonsCreate(float[] lat, float[] lon) {
  buttons = new float[lat.length][2];
  
  for (int n = 0; n < lat.length; n++){
    
    buttons[n][0] = (lon[n]*(width/360.0))+10.0;
    buttons[n][1] = (lat[n]*(-height/180.0))-10.0;
  }
  
}

// handles all button presses throughout program
void mousePressed(){ 
  boolean cityListFlag = false;
  
  // checks if one of the cities is clicked
  for (int x = 0; x < buttons.length; x++){
    if(cityList == false &&
    (mouseY > (buttons[x][1]) &&  mouseY < (buttons[x][1]+(0.0111*width)))
    && (mouseX < (buttons[x][0]) &&  mouseX > (buttons[x][0]-(0.0111*width)))){
      idIndex = new IntList();
    }
  }
  
  // appending artist id's from city clicked above
  for (int id = 0; id < buttons.length; id++){
    if(cityList == false &&
    (mouseY > (buttons[id][1]) &&  mouseY < (buttons[id][1]+(0.0111*width)))
    && (mouseX < (buttons[id][0]) &&  mouseX > (buttons[id][0]-(0.0111*width)))){
       cityListFlag = true;
       idIndex.append(id);
    }
  }
  
  // handles clicks on the bars of the bar graphs
  if (cityList && !artTab) { 
    for (int y = 0; y < picButton.length; y++) {
      //println(picButton.length);
      if ((mouseX > picButton[y][0] && mouseX < (picButton[y][0 ]+ (.1* width))) && (mouseY > picButton[y][1] && mouseY < height)){
        artTab = true;
        artTabIndex = int(picButton[y][2]);
      }
    }
  }
  
  // back to map button
  if ((cityList) &&
  (mouseX < (0.1*width)) &&
  (mouseY < (0.05*height))) {
    cityList = false;
    idIndex.clear();
  }
  
  // closing specific artist window button
  if (artTab &&
  ((mouseX > 0.89 * width) && (mouseX < 0.91 * width)) &&
  ((mouseY > 0.09 * height) && (mouseY < 0.11 * height))) {
    artTab = false;
    startingWork = 1;
  }
  
  // link to wikipedia (kinda faulty with diff. width wikipedia links...sorry!)
  if(artTab && (mouseX > 0.177*width) && (mouseX < 0.4*width) &&
  (mouseY > 0.315*height) && (mouseY < 0.335*height)){
    artistLink = true;
  }
  
 // helper to appending artist id's (lines 131-139)
  if (cityListFlag) {
    cityList = true;
  }
  
}

// mouse events for when the user is scrolling through an artist's paintings
void mouseWheel(MouseEvent event){
  float e = event.getCount();
  if(artTab){
    if(e < 0 && startingWork >= 7){
      startingWork -= 6;
      imagePageNum--;
    }
    else if(e > 0 && startingWork + 6 <= paintings[artTabIndex]){
      startingWork += 6;
      imagePageNum++;
    }
  }
}

// gets the artist with the max paintings in a particular city
int getMaxPaintings(IntList orderedList){
  int max = 0;
  for(int i = 0; i < orderedList.size(); i++){
    if(max < paintings[orderedList.get(i)]){
      max = paintings[orderedList.get(i)];
    }
  }
 
    return max;
}

// draws all the circles for cities
void drawCities(float[] lat, float[] lon){
   fill(255);
   float hScale = height/180.0;
   float wScale = width/360.0;
   
   for (int j = 0; j < lon.length; j++){
     circle(lon[j]*wScale, lat[j]*(-hScale),(0.000005*(height*width)));
   }
}

// creates the bar graph screen
void artistList() {
  IntList orderedList = orderArtistByCount();
  
  background(255);
  textSize(35);
  fill(0);
  
  int maxPaintings = getMaxPaintings(orderedList);
   
  // uses most popular image from each artist to display as a bar
  // their bar is scaled based on how many paintings/works the artist has created
  // most creations on the left and least on the right
  picButton = new float[idIndex.size()][3];
  for (int i = 0; i < orderedList.size(); i++) {
    
    textSize(int(0.01367*width));
    fill(0);
    text(name[orderedList.get(i)], i*(0.15*width), (0.08*height));
    
    float paint = paintings[orderedList.get(i)];

    PImage artistImage = getArtistPopularWork(orderedList.get(i));
    float ypct = paint / maxPaintings;
    
    artistImage.resize(int (0.1*width), int(ypct * (height - (0.2*height))));
    image(artistImage, (i*(0.15*width)), height - artistImage.height);

    // first two indexes ([i][0] && [i][1])are the starting width & height of bar
    // final index ([i][2]) is index of the artist in the csv file
    picButton[i][0] = (i*(0.15*width));
    picButton[i][1] = height - artistImage.height;
    picButton[i][2] = orderedList.get(i);

  }
  fill(255);
  stroke(0);
  rect(0,0,(0.1*width), (0.05*height));
  fill(0);
  textSize(int(0.01367*width));
  text("Back to Map", (0.007813*width),(0.033*height));
}

// function to grab an image using the artists name & the photo id
public PImage getArtistWork(int artistIndex, int photoIndex){
  String artistName = name[artistIndex];
  String[] names = artistName.split(" ");
  
  String tempArtistName = "";
  for(int i = 0; i < names.length; i++){
    if(i != names.length - 1){
      tempArtistName += names[i] + "_";
    }
    else{
      tempArtistName += names[i];
    }
  }
 
  String imgPath = "images/" + tempArtistName + "/";
  imgPath += tempArtistName + "_" + photoIndex + ".jpg"; 
  return loadImage(imgPath);
 
}

// gets an artists most popular work
public PImage getArtistPopularWork(int artistIndex){
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
  String imgPath = "images/" + tempArtistName + "/";
  imgPath += tempArtistName + "_" + mostPopWork + "_popular.jpg";
  return loadImage(imgPath);
}

// orders the artists in a city from most to least works
IntList orderArtistByCount() {
  IntList tempList = new IntList();
  IntList tempList2 = new IntList();
  
  
  for (int j=0; j < idIndex.size(); j++) {
    tempList2.append(paintings[idIndex.get(j)]);
  }
  tempList2.sort();
  tempList2.reverse();
  
  for (int i = 0; i < tempList2.size(); i++){
    for (int k = 0; k < paintings.length; k++) {
      
      if (tempList2.get(i)==paintings[k] && idIndex.hasValue(k)){
        tempList.append(k);
      }
    }
  }
  return tempList;
}

// creates the information screen for a particular artist
void artistTable(int artistIndex) {
  // these variables are for sizing the images
  float boxWidthStart = 0.44 * width;
  // boxWidthEnd = 0.87 * width;
  // width = 0.45
  float boxHeightStart = 0.16 * height;
  // boxHeightEnd = 0.84 * height;
  // height = 0.7
  
  // each photo is .2 width and .22 height
  // gap of .03 in between each column
  // gap of .01 in between each row
  
  // the first rect is the gray background for the artist's info page
  fill(100);
  rect((0.1*width),(0.1*height),(0.8*width),(0.8*height));
  fill(255, 0, 0);
  
  // second rect is the red exit button in the top right corner of the artist's info page
  rect((0.89*width),(0.09*height),(0.02*width),(0.02*height));
  fill(255);
  text("X", 0.896 * width, 0.11 * height);
  
  // this is all textual data for an artist
  fill(255);
  textSize(int(0.00767*width));
  text(name[artistIndex],(0.12*width),(0.15*height));
  text("Birthplace: " + birthplace[artistIndex], (0.12*width), (0.18*height)); 
  text("Nationality: " + nationality[artistIndex], (0.12*width), (0.21*height));
  text("Years: " + years[artistIndex], (0.12*width), (0.24*height));
  text("Genre: " + genre[artistIndex], (0.12*width), (0.27*height));
  text("Number of paitnings: " + paintings[artistIndex], (0.12*width), (0.3*height));
  text("Wikipedia Link: ", (0.12*width), (0.33*height));
  fill(255, 128, 0);
  text(wikipedia[artistIndex], (0.177*width), (0.33*height));
  fill(255);
  text("Biography: " + bio[artistIndex], (0.12*width), (0.36*height), (0.3*width), (0.49*height));
  
  // this checks if the user has clicked on the link
  if(artistLink){
    link(wikipedia[artistIndex]);
    artistLink = false;
  }
  
  // this is a page counter for what page of images the user is currently viewing
  textSize(int(0.015*width));
  text("Page " + imagePageNum, boxWidthStart + (0.192 * width), (0.14 * height));
  
  // loop to pull the images of the current page of images the user is viewing
  // conditional helper deals with cases where the page contains less than 6 images
  int conditionalHelper;
  if(paintings[artistIndex] - startingWork < 6){
    conditionalHelper = paintings[artistIndex] - startingWork;
  }
  else{
    conditionalHelper = 6;
  }
  
  for(int i = startingWork; i <= (startingWork + conditionalHelper); i++){
    println(startingWork);
    PImage work;
    if(i == popWork[artistIndex]){
      work = getArtistPopularWork(artistIndex);
    }
    else{
      work = getArtistWork(artistIndex, i);
    }
    
    // standardized size for the image
    work.resize(int(width*0.2), int(height*0.22));
    
    // cases for location of images
    if(i == startingWork){
      image(work, boxWidthStart, boxHeightStart);
    }
    else if(i == startingWork + 1){
      image(work, boxWidthStart + (0.23 * width), boxHeightStart);
    }
    else if(i == startingWork + 2){
      image(work, boxWidthStart, boxHeightStart + (0.23 * height));
    }
    else if(i == startingWork + 3){
      image(work, boxWidthStart + (0.23 * width), boxHeightStart + (0.23 * height));
    }
    else if(i == startingWork + 4){
      image(work, boxWidthStart, boxHeightStart + (0.46 * height));
    }
    else if(i == startingWork + 5){
      image(work, boxWidthStart + (0.23 * width), boxHeightStart + (0.46 * height));
    }
  }
}
