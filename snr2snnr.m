function snnratio = snr2snnr(snratio)

snnratio = 10*log10(1 + 10.^(snratio/10));