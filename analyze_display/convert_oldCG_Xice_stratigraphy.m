waterIce = 0.65;
mineral = 0.30;
organic = 0.05;
natPor = 0.55;

waterIce = 0.75;
mineral = 0.20;
organic = 0.05;
natPor = 0.55;

waterIce = 0.9;
mineral = 0.05;
organic = 0.05;
natPor = 0.55;

waterIce = 0.75;
mineral = 0.2;
organic = 0.05;
natPor = 0.55;

waterIce = 0.65;
mineral = 0.2;
organic = 0.15;
natPor = 0.55;

waterIce = 0.75;
mineral = 0.15;
organic = 0.1;
natPor = 0.55;

waterIce = 0.65;
mineral = 0.2;
organic = 0.15;
natPor = 0.55;

waterIce = 0.95;
mineral = 0.05;
organic = 0.0;
natPor = 0.55;


Xice_abs = (1-mineral-organic-natPor)./(1-natPor);

new_D = 1-Xice_abs;

waterIce_new = (waterIce - Xice_abs) ./ (1-Xice_abs);
mineral_new = mineral ./ (1-Xice_abs);
organic_new = organic ./ (1-Xice_abs);

Xice_new = Xice_abs ./ (1-Xice_abs);