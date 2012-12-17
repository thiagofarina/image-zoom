# Exemplo:
#
#  imagemOriginal = imread("porsche.jpg");
#  imagemFinal = muda_escala(imagemOriginal, 2, 2, "vizinho");
#  imwrite(imagemFinal, "porsche-zoom.jpg");
#

function image_zoom = bilinear(imagemEntrada, cx, cy)
  [r c d] = size(imagemEntrada);
  rn = floor(cx*r);
  cn = floor(cy*c);
  im_zoom = zeros(rn, cn, d);

  for i = 1:rn;
    x1 = cast(floor(i / cx), 'uint16');
    x2 = cast(ceil(i / cx), 'uint16');

    if x1 == 0
      x1 = 1;
    endif

    x = rem(i / cx, 1);

    for j = 1:cn;
      y1 = cast(floor(j / cy), 'uint16');
      y2 = cast(ceil(j / cy), 'uint16');

      if y1 == 0
        y1 = 1;
      endif

      ctl = imagemEntrada(x1,y1,:);
      cbl = imagemEntrada(x2,y1,:);
      ctr = imagemEntrada(x1,y2,:);
      cbr = imagemEntrada(x2,y2,:);

      y = rem(j / cy, 1);
      tr = (ctr * y) + (ctl * (1 - y));
      br = (cbr * y) + (cbl * (1 - y));

      im_zoom(i, j, :) = (br * x) + (tr * (1 - x));
    endfor
  endfor
  image_zoom = cast(im_zoom, 'uint16');
endfunction

function image_zoom = vizinho_mais_proximo(imagemEntrada, cx, cy)
  scale = [cx cy];
  oldSize = size(imagemEntrada);
  newSize = max(floor(scale.*oldSize(1:2)),1);

  rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
  colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));

  image_zoom = imagemEntrada(rowIndex,colIndex,:);
endfunction

# Parametros de entrada:
# @imagemEntrada: A imagem a ser escalada.
# @x:
# @y:
# @algoritmo: Tipo do algoritmo a ser usado: 'vizinho' ou 'bilinear'.
#
function image_zoom = muda_escala(imagemEntrada, x, y, algoritmo)
  if (x < 0)
    error("O valor de x é inválido, os valores aceitos são 0 até infinito.");
  endif

  if (y < 0)
    error("O valor de y é inválido, os valores aceitos são 0 até infinito.");
  endif

  if (algoritmo == "vizinho")
    image_zoom = vizinho_mais_proximo(imagemEntrada, x, y);
  elseif (algoritmo == "bilinear")
    image_zoom = bilinear(imagemEntrada, x, y);
  else
    error("Algoritmo inválido, somente vizinho ou bilinear são aceitos.");
  endif
endfunction
