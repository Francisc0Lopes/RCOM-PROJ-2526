
% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
d = 45;                 % Distância [km]
R = 10;                 % Intensidade de chuva [mm/h] - pior mês
percentagem_tempo = 0.1; % % do tempo não excedida (0.1% = pior caso)

% --- COEFICIENTES ITU-R P.838 PARA 6 GHz ---
k_H = 0.00102;  % Coeficiente k para polarização horizontal
alpha_H = 0.912; % Expoente alpha para polarização horizontal
k_V = 0.00085;  % Coeficiente k para polarização vertical  
alpha_V = 0.931; % Expoente alpha para polarização vertical

% --- ATENUAÇÃO ESPECÍFICA ---
gamma_H = k_H * R^alpha_H; % [dB/km] - polarização horizontal
gamma_V = k_V * R^alpha_V; % [dB/km] - polarização vertical

% --- FATOR DE REDUÇÃO DE DISTÂNCIA ---
% Para distâncias > 5 km, aplicar fator de redução
d_eff = d / (1 + d/35); % [km] - distância efetiva

% --- ATENUAÇÃO TOTAL ---
A_chuva_H = gamma_H * d_eff; % [dB] - polarização horizontal
A_chuva_V = gamma_V * d_eff; % [dB] - polarização vertical

% --- RESULTADOS ---
fprintf('PARÂMETROS DE CHUVA:\n');
fprintf('  Frequência: %.1f GHz\n', f/1e9);
fprintf('  Distância: %.1f km\n', d);
fprintf('  Intensidade chuva: %.0f mm/h\n', R);
fprintf('  Percentagem tempo: %.1f%%\n', percentagem_tempo);
fprintf('  Distância efetiva: %.1f km\n\n', d_eff);

fprintf('COEFICIENTES ITU-R P.838:\n');
fprintf('  Polarização Horizontal: k = %.6f, α = %.3f\n', k_H, alpha_H);
fprintf('  Polarização Vertical:   k = %.6f, α = %.3f\n\n', k_V, alpha_V);

fprintf('ATENUAÇÃO ESPECÍFICA:\n');
fprintf('  Polarização Horizontal: γ = %.4f dB/km\n', gamma_H);
fprintf('  Polarização Vertical:   γ = %.4f dB/km\n\n', gamma_V);

fprintf('ATENUAÇÃO TOTAL:\n');
fprintf('  Polarização Horizontal: %.2f dB\n', A_chuva_H);
fprintf('  Polarização Vertical:   %.2f dB\n', A_chuva_V);