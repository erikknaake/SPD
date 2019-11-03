//Wordt gebruikt om te kijken of mousePressed boven een knop is
boolean muisInVierhoek(final float x, final float y, final float breedte, final float hoogte)
{
  return mouseX >= x && mouseX <= x + breedte && mouseY >= y && mouseY <= y + hoogte;
}
//deselecteerd alle kaarten op de tafel
boolean[] deselecteerAlles()
{
  for (int i = 0; i < selectie.length; i++)
    selectie[i] = false;
  return selectie;
}

//Selecteerd/deselecteer kaart afhankelijk van waar er is geklikt
boolean[] verwerkKlikVoorKaarten(final int posX, final int posY, final int breedte, final int hoogte)
{
  final int kaartBreedte = breedte / veldZijdeX;
  final int kaartHoogte = hoogte / VELDZIJDEY;
  //Voor elke kaart wordt gecontroleerd of er op geklickt is
  for (int i = 0; i < tafel.length; i++)
  {
    final float pos[] = positieNaarCoordinaten(i, posX, posY, breedte, hoogte); //X, Y
    if(pos.length < 2)
      return selectie;
    if (muisInVierhoek(pos[0], pos[1], kaartBreedte, kaartHoogte) && tafel[i].length() == EIGENSCHAPPEN.length) //als er op een kaart is gedrukt, die ook getekend kan worden
    {  
      if (selectie[i])
        selectie[i] = false;
      else if (!selectie[i] && aantalTrue(selectie) < EIGENSCHAPPEN.length)
        selectie[i] = true;
      break; //het heeft geen zin om naar nog een kaart te zoeken, je kunt met 1 klik precies 1 kaart selecteren
    }
  }
  return selectie;
}
//returnt welke kaarten er zijn geselecteerd
String[] bepaalGeselecteerdeKaarten()
{
  String[] geselecteerdeKaarten = new String[EIGENSCHAPPEN.length];
  int teller = 0;
  for (int i = 0; i < veldZijdeX * VELDZIJDEY; i++)
  {
    if (selectie[i])
    {
      geselecteerdeKaarten[teller] = tafel[i];
      teller++;
    }
  }
  return geselecteerdeKaarten;
}

void voegDrieKaartenToe()
{
  if (stapel.length < VELDZIJDEY)
    return;
  veldZijdeX++;
  for (int i = 0; i < VELDZIJDEY; i++) //voor alle kaarten die we toegvoegen, voeg toe aan selectie en leg nieuwe kaarten neer
  {
    tafel = append(tafel, stapel[stapel.length - 1]);
    selectie = expand(selectie);
    selectie[selectie.length - 1] = false;
    stapel = shorten(stapel);
  }
  tekenAlles();
  score -= 3;
}