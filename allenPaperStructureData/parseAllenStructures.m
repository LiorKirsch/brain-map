[regionIndex , acronym, hemisphere, samplesBrain1,samplesBrain2,moreThenNeq2, a,b,c,d,e,f,g,h,i,j] = textread('allenBrainGeneTable.csv', '%s %s %s %s %s %s %s %s %s %q %q %q %q %q %q %q', 'delimiter', ',',  'headerlines', 3);
[~, ~, grossBrainRegion,grossSamplesBrain1, grossSamplesBrain2,sampledStructures, isolationMethod] = textread('allenBrainGeneTable2.csv', '%s %s %s %s %s %q %s', 'delimiter', ',',  'headerlines', 3);


regionNames = strcat(a,b,c,d,e,f,g,h,i,j);


allenPaper.regionDetails = cat(2,regionIndex, acronym,regionNames, hemisphere);
allenPaper.region146 = strcmp(moreThenNeq2, 'x');
allenPaper.region170 = ~strcmp(moreThenNeq2, '');


allenPaper.region146Details = allenPaper.regionDetails(allenPaper.region146,:);
allenPaper.region170Details = allenPaper.regionDetails(allenPaper.region170,:);
allenPaper.grossRegions = grossBrainRegion;

save('allenPaper.mat', '-struct', 'allenPaper');
