String[] genereerKaarten()
{
  //Wordt gebruikt om de return waarde in op te slaan tot de return
  String[] kaarten = new String[0];
  //Als er niet genoeg eigenschappen zijn returnen we een lege array
  if (EIGENSCHAPPEN.length <= 0 || EIGENSCHAPPEN[0].length() <= 0)
  {
    println("eigenschappen is niet valide");
    return kaarten;
  }

  //Itereert door alle combinaties van eigenschappen
  for (int i = 0; i < EIGENSCHAPPEN.length; i++)
  {
    for (int j = 0; j < EIGENSCHAPPEN[i].length(); j++)
    {
      for (int n = 0; n < EIGENSCHAPPEN[i].length(); n++)
      {
        //En slaat ze op in kaarten
        kaarten = append(kaarten, EIGENSCHAPPEN[0].substring(i, i + 1) + EIGENSCHAPPEN[1].substring(j, j + 1) + EIGENSCHAPPEN[2].substring(n, n + 1));
      }
    }
  } 
  return kaarten;
}

String[] schudKaarten(String[] kaarten)
{
  //Niet genoeg kaarten om te schudden
  if (kaarten.length < 2)
  {
    println("te weinig kaarten om te schudden"); 
    return kaarten;
  }
  //for een groot aantal keer
  for (int i = 0; i <= pow(kaarten.length, 3); i++)
  {
    //verwisseld twee willekeurige kaarten
    int rand1 = floor(random(0, kaarten.length)); 
    int rand2 = floor(random(0, kaarten.length)); 
    String temp = kaarten[rand1]; 
    kaarten[rand1] = kaarten[rand2]; 
    kaarten[rand2] = temp;
  }
  return kaarten;
}

boolean isSet(String[] kaarten)
{
  if (!zijnKaartenValide(kaarten))
    return false;
  //zet de kaarten weergegeven als string array om naar 2d getallen array
  int[][] kaartenAlsNummers = new int[kaarten.length][kaarten[0].length()];
  for (int i = 0; i < kaarten.length; i++)
  {
    for (int j = 0; j < kaarten[i].length(); j++)
    {
      int nieuwNummer = -1;
      String waarde = kaarten[i].substring(j, j + 1);
      if (waarde.equals("1") || waarde.equals("r"))
        nieuwNummer = 1;
      else if (waarde.equals("2") || waarde.equals("g") || waarde.equals("e"))
        nieuwNummer = 2;
      else if (waarde.equals("3") || waarde.equals("b") || waarde.equals("d"))
        nieuwNummer = 3;
      kaartenAlsNummers[i][j] = nieuwNummer;
    }
  }
  //is het een set?
  for (int i = 0; i < kaartenAlsNummers.length; i++)
  {
    int som = 0;
    for (int j = 0; j < kaartenAlsNummers[i].length; j++)
    {
      if (kaartenAlsNummers[j][i] == -1)
        return false;
      som += kaartenAlsNummers[j][i];
    }
    if (som % 3 != 0)
      return false;
  }
  return true;
}

int aantalSetsOpTafel()
{
  int sets = 0; 
  //For alle kaarten op tafel, is het een set? als dat zo is hoog sets op met een
  for (int i = 0; i < tafel.length - 2; i++)
  {
    for (int j = i + 1; j < tafel.length; j++)
    {
      for (int n = j + 1; n < tafel.length; n++)
      {
        final String[] kaarten = {tafel[i], tafel[j], tafel[n]};
        if (zijnKaartenValide(kaarten))
          if (isSet(kaarten))
            sets++;
      }
    }
  }
  return sets;
}

//Voor hints
boolean[] selecteerTweeKaartenVanEenSet(boolean[] selectie)
{
  deselecteerAlles();
  //Selecteerd de eerste twee kaarten van de 'eerste' set op tafel
  for (int i = 0; i < tafel.length - 2; i++)
  {
    for (int j = i + 1; j < tafel.length; j++)
    {
      for (int n = j + 1; n < tafel.length; n++)
      {
        final String[] kaarten = {tafel[i], tafel[j], tafel[n]};
        if (zijnKaartenValide(kaarten))
        {
          if (isSet(kaarten))
          {
            selectie[i] = true;
            selectie[j] = true;
            score--;
            return selectie;
          }
        }
      }
    }
  }
  return selectie;
}
//Als true, array van kaarten bevat ten minste 1 kaart die eigenschappen bezit en geen kaart(en) die geen eigenschappen bevatten
boolean zijnKaartenValide(final String[] kaarten)
{
  for (int i = 0; i < kaarten.length; i++)
    if (kaarten[i].length() < EIGENSCHAPPEN.length)
      return false;
  return kaarten.length > 0;
}

String[] haalLegeStringsUitArray(final String[] array)
{
  String[] resultaat = new String[0];
  for (int i = 0; i < array.length; i++)
  {
    if (!array[i].equals(""))
      resultaat = append(resultaat, array[i]);
  }
  return resultaat;
}
//Maakt gebruik van het feit dat arrays references zijn, vervangt indien mogelijk een set met nieuwe kaarten, legt anders lege kaarten neer
String[] vervangSetMetNieuweKaarten(String[] tafel)
{
  //Vervang de set met nieuwe kaarten,
  //maar alleen als er genoeg kaarten op de stapel liggen
  final int[] indexesOmTeVervangen = indexesTrue(selectie);
  if (stapel.length >= indexesOmTeVervangen.length)
  {    
    for (int i = 0; i < indexesOmTeVervangen.length; i++)
    {
      //zet de kaart op tafel naar de kaart boven op de stapel
      tafel[indexesOmTeVervangen[i]] = stapel[stapel.length - 1]; 
      //Kort de stapel in, zodat we de correcte .length houden
      stapel = shorten(stapel);
    }
  }
  //Er zijn geen kaarten meer om de tafel aan te vullen
  else
  {
    for (int i = 0; i < indexesOmTeVervangen.length; i++)
    {
      //zet de kaart op tafel naar niets
      tafel[indexesOmTeVervangen[i]] = "";
    }
  }
  return tafel;
}