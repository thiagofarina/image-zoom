# Exemplo:
#
#  source("muda_escala.m");
#  imagemOriginal = imread("porsche.jpg");
#  imagemFinal = muda_escala(imagemOriginal, 2, 2, "vizinho");
#  imwrite(imagemFinal, "porsche-zoom.jpg");
#

function imagemSaida = bilinear(imagemEntrada, cx, cy)
  [linha coluna dimensao] = size(imagemEntrada);
  num_linhas = floor(cx * linha);
  num_colunas = floor(cy * coluna);
  im_zoom = zeros(num_linhas, num_colunas, dimensao);

  for i = 1:num_linhas;
    x1 = cast(floor(i / cx), 'uint16');
    x2 = cast(ceil(i / cx), 'uint16');

    if x1 == 0
      x1 = 1;
    endif

    x = rem(i / cx, 1);

    for j = 1:num_colunas;
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
  imagemSaida = cast(im_zoom, 'uint16');
endfunction

function imagemSaida = vizinho_mais_proximo(imagemEntrada, cx, cy)
  escala = [cx cy];
  tamanhoAntigo = size(imagemEntrada);
  tamanhoNovo = max(floor(escala.*tamanhoAntigo(1:2)), 1);

  index_linha = min(round(((1:tamanhoNovo(1))-0.5)./escala(1)+0.5), tamanhoAntigo(1));
  index_coluna = min(round(((1:tamanhoNovo(2))-0.5)./escala(2)+0.5), tamanhoAntigo(2));

  imagemSaida = imagemEntrada(index_linha, index_coluna, :);
endfunction

# Parametros de entrada:
# @imagemEntrada: A imagem a ser escalada.
# @x:
# @y:
# @algoritmo: Tipo do algoritmo a ser usado: 'vizinho' ou 'bilinear'.
#
function imagemSaida = muda_escala(imagemEntrada, x, y, algoritmo)
  if (x < 0)
    error("O valor de x é inválido, os valores aceitos são 0 até infinito.");
  endif

  if (y < 0)
    error("O valor de y é inválido, os valores aceitos são 0 até infinito.");
  endif

  if (strcmp(algoritmo, "vizinho"))
    imagemSaida = vizinho_mais_proximo(imagemEntrada, x, y);
  elseif (strcmp(algoritmo, "bilinear"))
    imagemSaida = bilinear(imagemEntrada, x, y);
  else
    error("Algoritmo inválido, somente vizinho ou bilinear são aceitos.");
  endif
endfunction
