//Nodig om kaarten te kunnen vergelijken en te tekenen
final String[] EIGENSCHAPPEN = {"123", "rgb", "red"};
//Wordt gebruikt om de locatie van de footer uit te rekenen en de hoogte van het speel veld
final float FACTOR_HOOGTE_SPEELVELD = 0.85;
int veldZijdeX = 3; //aantal kaarten dat in de x richting op het scherm kan liggen
final int VELDZIJDEY = 3; //aantal kaarten dat in de y richting op het scherm kan liggen
//Houdt bij welke kaarten er zijn geselecteerd
boolean[] selectie = new boolean[veldZijdeX * VELDZIJDEY];
//Welke kaarten liggen erop de stapel
String[] stapel;
//Welke kaarten er op de tafel liggen
String[] tafel;
//De score
int aantalGevondenSets = 0;
int score = 0;
void setup()
{
  size(1280, 720);
  reset();
}
void mousePressed()
{
  if (aantalSetsOpTafel() > 0) //speel conditie is dat er nog set(s) op tafel liggen
  {
    //Selecteer of deselcteer kaart als erop geklikt is
    selectie = verwerkKlikVoorKaarten(0, 0, width, round(height * FACTOR_HOOGTE_SPEELVELD));
    if (aantalTrue(selectie) >= EIGENSCHAPPEN.length)
    {
      //Extraheer de geselecteerde kaarten van de tafel
      String[] geselecteerdeKaarten = bepaalGeselecteerdeKaarten();

      //Er is een set gevonden
      if (isSet(geselecteerdeKaarten))
      {
        //Verhoog de score
        aantalGevondenSets++;
        score++;
        //zorgt ervoor dat de kaarten die een set waren worden geupdate indien mogelijk
        tafel = vervangSetMetNieuweKaarten(tafel);
      }
      //Set is gevonden dus er is geen selectie meer
      selectie = deselecteerAlles();
    }
    //Hint knop
    if (muisInVierhoek(width / 2, round(height * FACTOR_HOOGTE_SPEELVELD), width / 4, height))
    {
      selectie = selecteerTweeKaartenVanEenSet(selectie);
    }
    //Extra kaarten knop
    if (muisInVierhoek(width / 4 * 3, round(height * FACTOR_HOOGTE_SPEELVELD), width / 4, height))
    {
      voegDrieKaartenToe();
    }
    //Haal lege strings uit tafel en maak het mooi passend in het veld.
    tafel = haalLegeStringsUitArray(tafel);
    veldZijdeX = tafel.length / VELDZIJDEY;
    //Update het bord en scores/game over
    tekenAlles();
  } 
  else
  {
    //Reset knop
    if (muisInVierhoek(width / 2, height * FACTOR_HOOGTE_SPEELVELD, width / 2, height))
      reset();
  }
}

void draw() {
} //Nodig om mousePressed te kunnen gebruiken

//Start nieuw spel
void reset()
{
  veldZijdeX = 3;
  aantalGevondenSets = 0;
  score = 0;
  //maak een stapel met alle kaarten
  stapel = genereerKaarten();
  //zet de stapel in een random volgorde
  stapel = schudKaarten(stapel);
  final int maxKaartenOpTafel = (veldZijdeX * VELDZIJDEY);
  //De laatste kaarten op de stapel liggen op de tafel
  tafel = subset(stapel, stapel.length - maxKaartenOpTafel, maxKaartenOpTafel); //kopiëerd de laatste 9 kaarten van de stapel naar de tafel
  //En kort de stapen in, zodat we later nog de correcte .length krijgen
  for (int i = 0; i < maxKaartenOpTafel; i++)
    stapel = shorten(stapel);

  //Begin zonder selectie (en initialiseer selectie)
  selectie = deselecteerAlles();

  //teken het begin veld
  tekenAlles();
}