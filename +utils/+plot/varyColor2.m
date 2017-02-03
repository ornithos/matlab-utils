function col = varyColor2(n)

cols           = [77, 77, 77;
                  93, 165, 218;
                  250, 164, 58;
                  96, 189, 104;
                  241,124,176;
                  178,145, 47;
                  178,118,178;
                  222,207, 63;
                  241, 88, 84];

assert(utils.is.scalarint(n), 'n must be a scalar integer');
assert(n > 0 && n <= 9, 'varyColor2 currently supports only a 9 colour palette.');

col = cols(n,:)./255;

end