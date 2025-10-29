
% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
d = 200;                % Distância [km] - típica para dispersão
theta = 0.5;            % Ângulo de elevação [graus]
N0 = 320;               % Índice de refração à superfície [N-units]

% --- PERDA BÁSICA POR DISPERSÃO (ITU-R P.617-1) ---
% Perda mediana anual para 50% do tempo

% Termo de frequência
L_f = 25 * log10(f/1e9) - 2.5 * (log10(f/1e9))^2;

% Termo de distância  
L_d = 0.6 * d;

% Termo angular
L_theta = 0.07 * d * theta;

% Termo climático
L_N = 0.05 * N0;

% Perda básica total
L_bs = 174 + L_f + L_d + L_theta + L_N;

% --- PERDA PARA OUTROS PERCENTIS ---
% Fator para 0.1% do tempo
sigma = 8; % [dB] - variabilidade anual
L_01 = L_bs - 3.1 * sigma;

% Fator para 99.9% do tempo  
L_999 = L_bs + 3.1 * sigma;

% --- RESULTADOS ---
fprintf('PARÂMETROS ITU-R P.617-1:\n');
fprintf('  Frequência: %.1f GHz\n', f/1e9);
fprintf('  Distância: %.0f km\n', d);
fprintf('  Ângulo elevação: %.1f°\n', theta);
fprintf('  Índice refração N0: %.0f N-units\n\n', N0);

fprintf('COMPONENTES DA PERDA (50%% tempo):\n');
fprintf('  Termo frequência: %.2f dB\n', L_f);
fprintf('  Termo distância: %.2f dB\n', L_d);
fprintf('  Termo angular: %.2f dB\n', L_theta);
fprintf('  Termo climático: %.2f dB\n', L_N);
fprintf('  Perda básica: %.2f dB\n\n', L_bs);

fprintf('PERDA PARA DIFERENTES PERCENTIS:\n');
fprintf('  0.1%% do tempo: %.2f dB\n', L_01);
fprintf('  50%% do tempo: %.2f dB\n', L_bs);
fprintf('  99.9%% do tempo: %.2f dB\n', L_999);