
% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
d = 45;                 % Distância [km]
T = 15;                 % Temperatura [°C]
RH = 60;                % Humidade relativa [%]

% --- ATENUAÇÃO OXIGÉNIO (simplificado) ---
% Para frequências < 10 GHz, ~0.01 dB/km
A_oxigenio = 0.01 * d;

% --- ATENUAÇÃO VAPOR ÁGUA (simplificado) ---
% Para 6 GHz, depende da humidade
A_vapor_agua = 0.02 * (RH/100) * d;

% --- TOTAL ---
A_total = A_oxigenio + A_vapor_agua;

% --- RESULTADOS ---
fprintf('ATENUAÇÃO ATMOSFÉRICA:\n');
fprintf('  Frequência: %.1f GHz\n', f/1e9);
fprintf('  Distância: %.1f km\n', d);
fprintf('  Temperatura: %.0f°C\n', T);
fprintf('  Humidade: %.0f%%\n\n', RH);

fprintf('  Oxigénio: %.3f dB\n', A_oxigenio);
fprintf('  Vapor água: %.3f dB\n', A_vapor_agua);
fprintf('  Total: %.3f dB\n', A_total);
