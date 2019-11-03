//POSITIES:
// 0, 1, 2
// 3, 4, 5
// 6, 7, 8
float[] positieNaarCoordinaten(final int positie, final int posX, final int posY, final float breedte, final float hoogte)
{
  //Controleer of de positie later geen errors gaat opleveren 
  if (positie < 0 || positie > veldZijdeX * VELDZIJDEY - 1)
  {
    println("De gegeven positie is onmogelijk!");
    return new float[0];
  }
  float[] coordinaten = new float[2]; //x, y
  //veldZijde is 3 in de minimale opdracht
  coordinaten[0] = positie % veldZijdeX;
  coordinaten[1] = positie / veldZijdeX; //maakt gebruikt van integere deling, zou niet werken met floats
/*
   0 % 3 = 0, 1 % 3 = 1, 2 % 3 = 2
   3 % 3 = 0, 4 % 3 = 1, 5 % 3 = 2
   6 % 3 = 0, 7 % 3 = 1, 8 % 3 = 2
   9 % = 0, 10 % 3 = 1, 11 % 3 = 2
   Uitkomst van de modulo is een factor voor de x-coordinaat
   0 / 3 = 0, 1 / 3 = 0, 2 / 3 = 0
   3 / 3 = 1, 4 / 3 = 1, 5 / 3 = 1
   6 / 3 = 2, 7 / 3 = 0. 8 / 3 = 3
   Uitkomst van de integere deling is een factor van de y-coordinaat
   */

  //Nu vullen we de ruimte op door de verkregen coordinaten netjes te verdelen
  //over de ruimte die we in elke richting hebben, en voegen we de offset toe
  final float kaartBreedte = breedte / veldZijdeX;
  final float kaartHoogte = hoogte / VELDZIJDEY;
  coordinaten[0] = coordinaten[0] * kaartBreedte + posX;
  coordinaten[1] = coordinaten[1] * kaartHoogte + posY;

  return coordinaten;
}

int aantalTrue(final boolean[] array)
{
  int aantal = 0;
  for (int i = 0; i < array.length; i++)
    if (array[i])
      aantal++;
  return aantal;
}

int[] indexesTrue(final boolean[] array)
{
  int[] resultaat = new int[0];
  for (int i = 0; i < array.length; i++)
    if (array[i])
      resultaat = append(resultaat, i);
  return resultaat;
}