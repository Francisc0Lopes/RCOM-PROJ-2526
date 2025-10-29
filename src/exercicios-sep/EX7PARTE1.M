% --- PARÂMETROS ---
d = 45;          % Distância [km]
h_tx = 40;       % Altura TX [m]  
h_rx = 150;      % Altura RX [m]
R = 6370;        % Raio Terra [km]

% --- PONTO DE REFLEXÃO (aproximado) ---
d1 = d * h_tx/(h_tx + h_rx);  % Distância do TX ao ponto de reflexão

% --- FATOR DE DIVERGÊNCIA ---
psi = atand((h_tx + h_rx)/d); % Ângulo de incidência
D = 1/sqrt(1 + (2*d1*(d-d1))/(R*d*sind(psi))); % Fator divergência

% --- RESULTADOS ---
fprintf('PONTO DE REFLEXÃO:\n');
fprintf('  Distância do TX: %.2f km\n', d1);
fprintf('  Distância do RX: %.2f km\n', d-d1);

fprintf('\nFATOR DE DIVERGÊNCIA:\n');
fprintf('  Ângulo incidência: %.4f°\n', psi);
fprintf('  Fator divergência: %.4f\n', D);