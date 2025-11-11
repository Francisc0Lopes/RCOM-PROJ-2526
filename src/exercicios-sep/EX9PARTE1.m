
% --- PARÂMETROS ---
d = 0.07;          % Distância [km]
h_tx = 150;       % Altura TX [m]  
h_rx = 150;      % Altura RX [m]
R = 6370;        % Raio Terra [km]
f = 6e9;         % Frequência [Hz]
c = 3e8;         % Velocidade luz [m/s]

% --- TERRA PLANA (Slide 12) ---
delta_r_plana = (2 * h_tx * h_rx) / (d * 1000); % [m]

% --- TERRA ESFÉRICA (Slide 26) ---
% Alturas equivalentes (Slide 24)
d1 = (h_tx/(h_tx + h_rx)) * d * 1000;   % [m]
d2 = (h_rx/(h_tx + h_rx)) * d * 1000;   % [m]
h_tx_eq = h_tx - (d1.^2) / (2 * R * 1000); % [m]
h_rx_eq = h_rx - (d2.^2) / (2 * R * 1000); % [m]
delta_r_esferica = (2 * h_tx_eq * h_rx_eq) / (d * 1000); % [m]

% --- DIFERENÇA DE FASE ---
lambda = c/f; % [m]
delta_phi_plana = (2 * pi * delta_r_plana) / lambda; % [rad]
delta_phi_esferica = (2 * pi * delta_r_esferica) / lambda; % [rad]
dif_rad = delta_phi_plana - delta_phi_esferica; % [rad]


% --- RESULTADOS ---
fprintf('PARA UMA DISTÂNCIA ENTRE ANTENAS DE %.2f km:\n\n', d);

fprintf('DIFERENÇA DE PERCURSOS (Slide 26):\n');
fprintf('  Terra Plana:   delta_r = %.4f m\n', delta_r_plana);
fprintf('  Terra Esférica: delta_r = %.4f m\n', delta_r_esferica);
fprintf('  Diferença:     %.4f m\n', delta_r_plana - delta_r_esferica);

fprintf('\nDIFERENÇA DE FASE (Slide 27):\n');
fprintf('  Terra Plana:   delta_phi = %.2f rad\n', delta_phi_plana);
fprintf('  Terra Esférica: delta_phi = %.2f rad\n', delta_phi_esferica);
fprintf('  Diferença:                %.2f rad\n', delta_phi_plana - delta_phi_esferica);
fprintf('  Diferença (lambda):       %.2f lambda\n', (delta_phi_plana - delta_phi_esferica)/(2*pi));