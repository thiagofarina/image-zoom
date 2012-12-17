function image_zoom = bilinear_interp(image, cx, cy)
  disp("bilinear called");
  [r c d] = size(image);
  rn = floor(cx*r);
  cn = floor(cy*c);
  im_zoom = zeros(rn,cn,d);

  for i = 1:rn;
    x1 = cast(floor(i/cx),'uint16');
    x2 = cast(ceil(i/cx),'uint16');

    if x1 == 0
      x1 = 1;
    endif

    x = rem(i/cx,1);

    for j = 1:cn;
      y1 = cast(floor(j/cy),'uint16');
      y2 = cast(ceil(j/cy),'uint16');

      if y1 == 0
        y1 = 1;
      endif

      ctl = image(x1,y1,:);
      cbl = image(x2,y1,:);
      ctr = image(x1,y2,:);
      cbr = image(x2,y2,:);

      y = rem(j/cy,1);
      tr = (ctr*y)+(ctl*(1-y));
      br = (cbr*y)+(cbl*(1-y));

      im_zoom(i,j,:) = (br*x)+(tr*(1-x));
    endfor
  endfor
  image_zoom = cast(im_zoom,'uint16');
endfunction

function outputImage = neighbor(inputImage, cx, cy)
  disp("neighbor called");
  scale = [cx cy];
  oldSize = size(inputImage);
  newSize = max(floor(scale.*oldSize(1:2)),1);

  rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
  colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));

  outputImage = inputImage(rowIndex,colIndex,:);
endfunction

function outputImage = change_scale2(inputImage, x, y, algorithm)
  if (x < 0)
    error("O valor de x é inválido, os valores aceitos são 0 até infinito.");
  endif

  if (y < 0)
    error("O valor de y é inválido, os valores aceitos são 0 até infinito.");
  endif

  if (algorithm == "neighbor")
    outputImage = neighbor(inputImage, x, y);
  elseif (algorithm == "bilinear")
    outputImage = bilinear_interp(inputImage, x, y);
  else
    error("Algoritmo inválido, somente neighbor ou bilinear são aceitos.");
  endif
endfunction
