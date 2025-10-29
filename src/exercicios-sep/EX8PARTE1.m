% --- PARÂMETROS ---
d = 45;          % Distância [km] 
h_tx = 40;       % Altura TX [m]  
h_rx = 150;      % Altura RX [m]
f = 6e9;         % Frequência [Hz]
c = 3e8;         % Velocidade luz [m/s]

% --- DIFERENÇA DE PERCURSO ---
% Slide 12: Δr = (2 * h_tx * h_rx) / d
lambda = c/f;
delta_r = (2 * h_tx * h_rx) / (d * 1000); % [m]

% --- DIFERENÇA DE FASE ---
% Slide 13: Δφ = -k₀Δr + arg(Γ)
delta_phi = (2 * pi * delta_r / lambda) * (180/pi); % [graus]

% --- COEFICIENTE DE FRESNEL ---
% Slide 13: Γ = |Γ|e^(j arg(Γ))
% Slide 14: Para terra plana, incidência razante → Γ ≈ -1
Gamma = -1;

% --- RESULTADOS ---
fprintf('DIFERENÇA DE FASE (Slide 12-13):\n');
fprintf('  Diferença percurso: %.4f m\n', delta_r);
fprintf('  Comprimento onda: %.4f m\n', lambda);
fprintf('  Diferença fase: %.2f°\n', delta_phi);

fprintf('\nCOEFICIENTE DE FRESNEL (Slide 13-14):\n');
fprintf('  Γ = %.1f\n', Gamma);

