function snratio = snnr2snr(snnratio)

snratio = 10*log10(10.^(snnratio/10) - 1);

