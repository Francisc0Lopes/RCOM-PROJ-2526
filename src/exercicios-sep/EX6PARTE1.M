% --- PARÂMETROS ---
d = 45;          % Distância [km]
h_tx = 40;       % Altura antena TX [m]
h_rx = 150;      % Altura antena RX [m]
R = 6370;        % Raio Terra [km]

% --- CÁLCULOS ---
% Horizontais no sistema Europeu
horizontal_tx = atand(d/(2*R)) * 180/pi;
horizontal_rx = atand(d/(2*R)) * 180/pi;

% Ângulos de fogo
angulo_fogo_tx = atand((h_rx - h_tx)/d) + horizontal_tx;
angulo_fogo_rx = atand((h_tx - h_rx)/d) + horizontal_rx;

% --- RESULTADOS ---
fprintf('HORIZONTAIS:\n');
fprintf('  Horizontal TX: %.4f°\n', horizontal_tx);
fprintf('  Horizontal RX: %.4f°\n', horizontal_rx);

fprintf('\nÂNGULOS DE FOCO:\n');
fprintf('  Ângulo fogo TX: %.4f°\n', angulo_fogo_tx);
fprintf('  Ângulo fogo RX: %.4f°\n', angulo_fogo_rx);

