//  Código Creativo Buenos Aires #1
//  4 técnicas para Processing

void  setup()
{
  size(600, 600, P2D);
  colorMode(HSB);
  generate();
}

void generate()
{

  //  lo bueno de esta función "generate" es una vez compilado
  //  el sketch, nos permite generar distintas piezas tocando una tecla

  background(color(random(255), 255, 255));

  pushMatrix();
  translate(width*.5, height*.5);

  //  Random del total de segmentos que van a componer el poligono
  float segmentos = random(5, 32);  
  //  Total de polygonos, en este caso concentricos, que vamos a dibujar
  float total_poly = random(5, 30);
  for (float i=0; i<total_poly; i++) {
    float delta = i/total_poly;  //  normalizamos (0..1) la variable i 
    float size = map(delta, 0, 1, width*.4, width*.05);  // tamaño del poligono
    rotate(PI*.1);  //  rotamos un poco en cada iteracion del poligono
    poly(segmentos, size);
  }


  popMatrix();

  // "pelos" : dibujamos lineas con heading random

  float step = 10;
  for (float x=0; x<width; x+=step)
  {
    for (float y=0; y<height; y+=step)
    {
      float lo = step*.5;
      float angulo = random(PI*2);
      float xx = x+cos(angulo)*lo;
      float yy = y+sin(angulo)*lo;

      stroke(0, random(5, 25));
      line(x, y, xx, yy);
    }
  }

  //   un poco de noise para que pierda la estética "vectorial"
  el_noise(2.0, 2.0);
}


void  el_noise(float _mx, float _my)
{

  for (float x=0; x<width; x++)
  {
    for (float y=0; y<height; y++)
    {

      float nois = noise(x*_mx, y*_my);
      color c = color(0, nois*20);
      stroke(c);
      point(x, y);
    }
  }
}

void poly(float _seg, float _w)
{

  color co = color(random(255), 255, 255);
  //   total de iteraciones para dibujar la sombra.
  //   para hacer sombra, vamos a dibujar la misma figura 20 veces detrás, 
  //   cada vez mas grande y con menos alpha
  float st = 20; 

  for (float s=0; s<st; s++) {

    float deltas = s/st;  //  normalizamos
    float alpha = map(deltas, 0, 1, 10, 0);  //  alpha para las sombras
    float size = map(deltas, 0, 1, 1.2, 1);  //  mod de tamaño para las sombras (modificar el 1.1 por otros valores mas grande o mas chicos, pero siempre mayores a 1)
    boolean sombra = ((int)s != (int)st-1);  //  para saber si estamos dibujando sombras o la figura final
                                              //  
    pushMatrix();

    scale(size, size);  //  variamos la escala de la figura para hacer la sombra

    beginShape();
    noStroke();
    //  dibujamos el polygono desde el centro
    for (float i=0; i<_seg; i++)
    {
      float delta = i/_seg;
      float angle = delta*PI;  // si queremos dibujar un poligono entero seria "delta*PI*2"
      float x = cos(angle)*_w;
      float y = sin(angle)*_w;

      color cc = lerpColor(color(0), co, delta);
      if (sombra)
      {
        //  si es sombra pintamos negro y con alpha, probar cambiar el 0 por la variable "co" 
        //  y se logra una especie de BLUR, si ponemos blendMode(ADD) sería mas un glow, ponele.
        fill(0, alpha);
      } else {
        fill(co);
      }
      vertex(x, y);
    }


    endShape(CLOSE);

    popMatrix();
  }
}

void  draw()
{
  //  nada pasa por aqui , pero es necesario para que lea los eventos de teclado y llame a generate
}

void keyPressed()
{
  generate();
}