function CNew = GetBasisColor()

CVect = GetColorGradient('Purple');
for i = 1:length(CVect)
CNew(i,1:3) = hex2rgb(CVect{i});
end

save('../PreSave/BasisColor.mat','CNew');