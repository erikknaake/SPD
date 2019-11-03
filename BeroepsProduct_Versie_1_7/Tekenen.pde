void tekenKaarten(final String[] kaarten, final int posX, final int posY, final int breedte, final int hoogte)
{
  for (int i = 0; i < kaarten.length; i++)
    tekenKaart(kaarten[i], i, posX, posY, breedte, hoogte, selectie[i]);
}

void tekenKaart(final String eigenschappen, final int positie, final int posX, final int posY, final int breedte, final int hoogte, final boolean isGeselecteerd)
{
  //verkrijg coordinaten om de kaart te tekenen
  final float[] pos = positieNaarCoordinaten(positie, posX, posY, breedte, hoogte);
  //Error afhandeling
  if (pos.length <= 0)
  {
    println("Pos is niet valide!");
    return;
  }
  if (eigenschappen.length() < EIGENSCHAPPEN[0].length())
    return; //niets om te tekenen

  //tekent de kaart (achtergrond)
  final float kaartHoogte = hoogte / VELDZIJDEY;
  final float kaartBreedte = breedte / veldZijdeX;
  if (isGeselecteerd)
    fill(#F6FF0D);
  else
    fill(255); // wit
  rect(pos[0], pos[1], kaartBreedte, kaartHoogte);

  //Zorgt ervoor dat de symbolen de juiste kleur krijgen.
  setSymboolKleur(eigenschappen.substring(1, 2));
  //tekend de symbolen op de kaart
  tekenSymbolen(eigenschappen.substring(0, 1), eigenschappen.substring(2, 3), kaartHoogte, kaartBreedte, pos);
}

void setSymboolKleur(final String kleurEigenschap)
{
  if(kleurEigenschap.equals(""))
    return;
  if(kleurEigenschap.equals("r")) {
    fill(255, 0, 0); //rood
  }
  if(kleurEigenschap.equals( "g")) {
    fill(0, 255, 0); //groen
  }
  if(kleurEigenschap.equals( "b")) {
    fill(0, 0, 255); //blauw
  }
  else { 
    println("Er is geen gedrag gedefinieerd voor deze kleureigenschap!");
  }
}

float bepaalYSymbool(final float y, final int nummerSymbool, final int aantal, final float kaartHoogte, final float symboolHoogte)
{
  float ySymbool = y + nummerSymbool * kaartHoogte / aantal;
  //Het aantal symbolen heeft invloed op de formule:
  if (aantal == 3)
    ySymbool += symboolHoogte / aantal / 2;
  else if (aantal == 2)
    ySymbool += symboolHoogte / aantal;
  else
    ySymbool += symboolHoogte / aantal + symboolHoogte * 0.5;
  return ySymbool;
}

void tekenSymbool(final String eigenschap, final float middelpuntX, final float halveSymboolBreedte, final float ySymbool, final float symboolBreedte, final float symboolHoogte)
{
    //rechthoek
  if(eigenschap.equals("r"))  {
    rect(middelpuntX - halveSymboolBreedte, ySymbool, symboolBreedte, symboolHoogte);
  }
    //ellipse
  if(eigenschap.equals("e")) {
    ellipse(middelpuntX, ySymbool + symboolHoogte * 0.5, symboolBreedte, symboolHoogte);
  }
    //driehoek
  if(eigenschap.equals("d")) {
    final float lageY = ySymbool + symboolHoogte;
    triangle(middelpuntX - halveSymboolBreedte, lageY, middelpuntX, ySymbool, middelpuntX + halveSymboolBreedte, lageY);
  }
  else {
    println("Er is geen gedrag gedefinieerd voor deze vormeigenschap!");
  }
}

void tekenSymbolen(final String aantalSymbolen, final String vorm, final float kaartHoogte, final float kaartBreedte, final float[] pos)
{
  final int aantal = int(aantalSymbolen);
  for (int i = 0; i < aantal; i++)
  {
    //Variabelen voor de uitlijning van de symbolen (eigenschappen)
    final float symboolHoogte = kaartHoogte * 0.25;
    final float symboolBreedte = kaartBreedte * 0.8;
    final float middelpuntX = pos[0] + kaartBreedte * 0.5;
    final float halveSymboolBreedte = symboolBreedte * 0.5;
    final float ySymbool = bepaalYSymbool(pos[1], i, aantal, kaartHoogte, symboolHoogte);
    //Tekend een symbool met de hierboven uitgerekende informatie
    tekenSymbool(vorm, middelpuntX, halveSymboolBreedte, ySymbool, symboolBreedte, symboolHoogte);
  }
}

void tekenScore(final int posX, final int posY, final int breedte)
{
  final int hoogte = height - posY;
  //Schaalbare text
  int textGrootte = hoogte / 6;
  setTextSize(textGrootte, breedte);
  line(posX, posY, width, posY);
  fill(255);
  printScores(posX, posY, textGrootte);
  //Knop voor hint aan de rechterkant
  line(posX + breedte / 2, posY, posX + breedte / 2, posY + hoogte);
  text("Geef me\neen hint", posX + breedte / 5 * 3, posY + hoogte / 3);
  
  line(posX + breedte / 4 * 3, posY, posX + breedte / 4 * 3, posY + hoogte);
  //Bepaal text voor de rechter knop zodat de gebruiker kan zien of het bruikbaar is
  String extraKaartenKnop = "Niet genoeg\nkaarten in\nde stapel";
  if(stapel.length >= VELDZIJDEY)
    extraKaartenKnop = "Ik zie\ngeen set";
  text(extraKaartenKnop, posX + breedte / 5 * 4, posY + hoogte / 3);
}

void tekenBord(final int posX, final int posY, final int breedte, final int hoogte)
{
  background(100);
  tekenKaarten(tafel, posX, posY, breedte, round(hoogte * FACTOR_HOOGTE_SPEELVELD));
  tekenFooter(posX, posY + round(hoogte - (1 - FACTOR_HOOGTE_SPEELVELD) * hoogte), breedte);
}

void tekenGameOver(final int posX, final int posY, final int breedte)
{
  final int hoogte = height - posY;
  //Schaalbare text
  int textGrootte = hoogte / 6;
  setTextSize(textGrootte, breedte);
  //Lijn boven de footer
  line(posX, posY, breedte, posY);
  //Text in linker gedeelte van de footer, weergeeft de score
  fill(255);
  text("GameOver!", posX, posY + textGrootte);
  printScores(posX, posY  + textGrootte, textGrootte);
  //Knop voor nog een keer aan de rechterkant
  line(posX + breedte / 2, posY, posX + breedte / 2, posY + hoogte);
  text("Nog een keer!", posX + 2.5 * breedte / 4, posY + hoogte / 2);
}
void setTextSize(final int textGrootte, final int breedte)
{
  textSize(constrain(textGrootte, 1, breedte / 33));
}
void printScores(final int posX, final int posY, final int textGrootte)
{
  text("U heeft " + aantalGevondenSets + " set(s) gevonden\nEr liggen nog " + stapel.length + " kaarten op de stapel\nScore: " + score + "\nEr liggen " + aantalSetsOpTafel() + " set(s) op tafel", posX, posY + textGrootte);
}
void tekenFooter(final int posX, final int posY, final int breedte)
{
  //Bepaald of de gameover of score footer wordt getekend
  if (aantalSetsOpTafel() == 0)
    tekenGameOver(posX, posY, breedte);
  else
    tekenScore(posX, posY, breedte);
}

void tekenAlles()
{
  tekenBord(0, 0, width, height);
}