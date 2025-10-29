
% --- PARÂMETROS ---
P_tx = 10;              % Potência TX [W] - Slide 2
d = 45;                 % Distância [km]
f = 6e9;                % Frequência [Hz]
c = 3e8;                % Velocidade luz [m/s]
G_tx = 1000;            % Ganho TX 
G_rx = 1000;            % Ganho RX

% --- ESPAÇO LIVRE (Slide 3) ---
lambda = c/f;
A0 = (lambda/(4*pi*d*1000))^2;
P_r_livre = P_tx * G_tx * G_rx * A0;

% --- TERRA PLANA (Slide 14) ---
% Fator de interferência para terra plana
h_tx = 40;
h_rx = 150;
delta_r = (2 * h_tx * h_rx) / (d * 1000);
F_interf = 4 * (sin(pi * delta_r / lambda))^2;
P_r_plana = P_r_livre * F_interf;

% --- TERRA ESFÉRICA (Slide 29) ---
% Com factor de divergência
R = 6370;
h_tx_eq = h_tx - (d^2)/(2*R*1000);
h_rx_eq = h_rx - (d^2)/(2*R*1000);
delta_r_esf = (2 * h_tx_eq * h_rx_eq) / (d * 1000);
D = 0.85; % Factor divergência aproximado
F_interf_esf = abs(1 + D * exp(-1j*2*pi*delta_r_esf/lambda))^2;
P_r_esferica = P_r_livre * F_interf_esf;

% --- RESULTADOS ---
fprintf('POTÊNCIA RECEBIDA:\n');
fprintf('  Espaço Livre:  %.2e W\n', P_r_livre);
fprintf('  Terra Plana:   %.2e W\n', P_r_plana);
fprintf('  Terra Esférica: %.2e W\n', P_r_esferica);

fprintf('\nEM dBm:\n');
fprintf('  Espaço Livre:  %.1f dBm\n', 10*log10(P_r_livre*1000));
fprintf('  Terra Plana:   %.1f dBm\n', 10*log10(P_r_plana*1000));
fprintf('  Terra Esférica: %.1f dBm\n', 10*log10(P_r_esferica*1000));

