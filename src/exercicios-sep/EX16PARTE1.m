% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
d = 45;                 % Distância total [km]
h_tx = 40;              % Altura TX [m]
h_rx = 150;             % Altura RX [m]

% --- OBSTÁCULO EM LÂMINA ---
d1 = 20;                % Distância TX-obstáculo [km]  
d2 = 25;                % Distância obstáculo-RX [km]
h_obs = 200;            % Altura do obstáculo [m]

% --- COMPRIMENTO DE ONDA ---
c = 3e8;
lambda = c/f;

% --- PARÂMETROS DO OBSTÁCULO ---
% Altura efetiva do obstáculo
h_eff = h_obs - (h_tx + (h_rx - h_tx) * d1/d);

% Parâmetro de difração v
v = h_eff * sqrt(2/(lambda * (1/d1 + 1/d2) * 1000));

% --- PERDA POR DIFRAÇÃO (MÉTODO DEGOUT) ---
if v <= -0.78
    % Região de sombra
    L_dif = 0;
elseif v > -0.78 && v <= 1
    % Região de transição
    L_dif = 6.4 + 20*log10(sqrt((v+0.1)^2+1) + v + 0.1);
else
    % Região de iluminação
    L_dif = 12.6 + 20*log10(v);
end

% --- RESULTADOS ---
fprintf('PARÂMETROS DO OBSTÁCULO:\n');
fprintf('  Frequência: %.1f GHz\n', f/1e9);
fprintf('  Distância total: %.1f km\n', d);
fprintf('  Altura TX: %.1f m\n', h_tx);
fprintf('  Altura RX: %.1f m\n', h_rx);
fprintf('  Altura obstáculo: %.1f m\n\n', h_obs);

fprintf('GEOMETRIA DO OBSTÁCULO:\n');
fprintf('  Distância TX-obstáculo: %.1f km\n', d1);
fprintf('  Distância obstáculo-RX: %.1f km\n', d2);
fprintf('  Altura efetiva: %.2f m\n', h_eff);
fprintf('  Parâmetro v: %.3f\n\n', v);

fprintf('RESULTADO (MÉTODO DEGOUT):\n');
fprintf('  Perda por difração: %.2f dB\n', L_dif);

if v <= -0.78
    fprintf('  Região: Sombra (sem obstrução)\n');
elseif v > -0.78 && v <= 1
    fprintf('  Região: Transição\n');
else
    fprintf('  Região: Iluminação\n');
end
