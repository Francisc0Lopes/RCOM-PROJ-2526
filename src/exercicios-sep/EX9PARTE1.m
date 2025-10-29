
% --- PARÂMETROS ---
d = 45;          % Distância [km]
h_tx = 40;       % Altura TX [m]  
h_rx = 150;      % Altura RX [m]
R = 6370;        % Raio Terra [km]
f = 6e9;         % Frequência [Hz]
c = 3e8;         % Velocidade luz [m/s]

% --- TERRA PLANA (Slide 12) ---
delta_r_plana = (2 * h_tx * h_rx) / (d * 1000); % [m]

% --- TERRA ESFÉRICA (Slide 26) ---
% Alturas equivalentes (Slide 24)
h_tx_eq = h_tx - (d^2)/(2*R*1000);
h_rx_eq = h_rx - (d^2)/(2*R*1000);
delta_r_esferica = (2 * h_tx_eq * h_rx_eq) / (d * 1000); % [m]

% --- DIFERENÇA DE FASE ---
lambda = c/f;
delta_phi_plana = (2 * pi * delta_r_plana / lambda);
delta_phi_esferica = (2 * pi * delta_r_esferica / lambda);

% --- RESULTADOS ---
fprintf('DIFERENÇA DE PERCURSOS (Slide 26):\n');
fprintf('  Terra Plana:   Δr = %.4f m\n', delta_r_plana);
fprintf('  Terra Esférica: Δr = %.4f m\n', delta_r_esferica);
fprintf('  Diferença:     %.4f m\n', delta_r_plana - delta_r_esferica);

fprintf('\nDIFERENÇA DE FASE (Slide 27):\n');
fprintf('  Terra Plana:   Δφ = %.2f rad\n', delta_phi_plana);
fprintf('  Terra Esférica: Δφ = %.2f rad\n', delta_phi_esferica);
fprintf('  Diferença:     %.2f rad\n', delta_phi_plana - delta_phi_esferica);
