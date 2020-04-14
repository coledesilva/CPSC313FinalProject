/*
  @authors: Kevin Shaw, Isak Bjornson, Cole deSilva
  @assignment: Final Project
  @date: 4/13/2020
  @version: v1.0
*/

PImage map;
Table data;
ArrayList<Integer> artistID;
int idIndex = 0;

void setup(){
  size(1280, 720);
  map = loadImage("EquiProjMap.png");
  map.resize(width-75, height);
  image(map, 0, 0);
  
  data = loadTable("artists_with_birthplace.csv", "header");
  artistID = new ArrayList();
  for(TableRow row : data.rows()){
    int id = row.getInt("id");
  }  
}

void drawCities(){
    
}
