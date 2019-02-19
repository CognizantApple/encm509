%Grab the prepared data
[AndyThumbs,PatrickThumbs] = GetDatabaseLab45();

PatrickThumbs{22} = medfilt2(PatrickThumbs{22});
PatrickThumbs{27} = medfilt2(PatrickThumbs{27});

Lab4Fingerprint1Auto(PatrickThumbs{22}, "img/22_Medfilt2");
Lab4Fingerprint1Auto(PatrickThumbs{27}, "img/27_Medfilt2");


