# Exemplo:
#
#  source("muda_escala.m");
#  imagemOriginal = imread("porsche.jpg");
#  imagemFinal = muda_escala(imagemOriginal, 2, 2, "vizinho");
#  imwrite(imagemFinal, "porsche-vizinho.jpg");
#

function imagemSaida = bilinear(imagemEntrada, cx, cy)
  # Cria uma matriz aumentada com largura e alturas modificados (baseado nos
  # parametros cx e cy).
  [linha coluna dimensao] = size(imagemEntrada);
  num_linhas = floor(cx * linha);
  num_colunas = floor(cy * coluna);
  preImagemSaidam = zeros(num_linhas, num_colunas, dimensao);

  # Inicia o loop iterando pelaas linhas da nova matriz.
  for i = 1:num_linhas
    x1 = cast(floor(i / cx), 'uint16');
    x2 = cast(ceil(i / cx), 'uint16');

    if x1 == 0
      x1 = 1;
    endif

    x = rem(i / cx, 1);

    for j = 1:num_colunas
      y1 = cast(floor(j / cy), 'uint16');
      y2 = cast(ceil(j / cy), 'uint16');

      if y1 == 0
        y1 = 1;
      endif

      coluna_topo_esquerda = imagemEntrada(x1, y1, :);
      coluna_inferior_esquerda = imagemEntrada(x2,y1,:);
      coluna_topo_direita = imagemEntrada(x1, y2, :);
      coluna_inferior_direita = imagemEntrada(x2, y2, :);

      y = rem(j / cy, 1);
      topo_direita = (coluna_topo_direita * y) + (coluna_top_esquerda * (1 - y));
      inferior_direita = (coluna_inferior_direita * y) + (coluna_inferior_esquerda * (1 - y));

      preImagemSaida(i, j, :) = (inferior_direita * x) + (topo_direita * (1 - x));
    endfor
  endfor

  imagemSaida = cast(preImagemSaida, 'uint16');
endfunction

function imagemSaida = vizinho_mais_proximo(imagemEntrada, x, y)
  escala = [x y];
  tamanhoAnterior = size(imagemEntrada);
  tamanhoNovo = max(floor(escala.*tamanhoAnterior(1:2)), 1);

  index_linha = min(round(((1:tamanhoNovo(1))-0.5)./escala(1)+0.5), tamanhoAnterior(1));
  index_coluna = min(round(((1:tamanhoNovo(2))-0.5)./escala(2)+0.5), tamanhoAnterior(2));

  imagemSaida = imagemEntrada(index_linha, index_coluna, :);
endfunction

# Essa função aumenta a imagem (escala) de entrada de acordo com os parametros
# passados.
#
# Parametros de entrada:
# @imagemEntrada: A imagem a ser escalada.
# @x: Por quanto a largura da matriz deve ser aumentada.
# @y: Por quanto a altura da matriz deve ser aumentada.
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
