
% --- PARÂMETROS ---
d = 45;                 % Distância [km]
h_tx = 40;              % Altura TX [m]
h_rx = 150;             % Altura RX [m]
R_terra = 6370;         % Raio real da Terra [km]

% --- VALORES TÍPICOS DE dn/dh ---
dn_dh = [-400, -157, -43, 50] * 1e-6; % [km⁻¹]

% --- RAIO EQUIVALENTE DA TERRA ---
% Fórmula: R_eq = R_terra / (1 + R_terra * dn/dh)
fprintf('RAIO EQUIVALENTE DA TERRA:\n');
fprintf('  Raio real: %.0f km\n\n', R_terra);

for i = 1:length(dn_dh)
    R_eq = R_terra / (1 + R_terra * dn_dh(i));
    k = R_eq / R_terra; % Fator k
    
    fprintf('dn/dh = %6.0f×10⁻⁶ km⁻¹:\n', dn_dh(i)*1e6);
    fprintf('  Raio equivalente: %.0f km\n', R_eq);
    fprintf('  Fator k: %.2f\n\n', k);
end

% --- PERFIL DA LIGAÇÃO (Sistema Europeu) ---
x = linspace(0, d, 100); % [km]

% Para dn/dh = -157×10⁻⁶ km⁻¹ (atmosfera padrão)
R_eq_padrao = R_terra / (1 + R_terra * (-157e-6));
y_terra_real = -((x - d/2).^2) / (2 * R_terra);
y_terra_equiv = -((x - d/2).^2) / (2 * R_eq_padrao);

% Raio direto considerando refração
y_raio_refratado = h_tx/1000 + (h_rx/1000 - h_tx/1000) * x/d + y_terra_equiv;

fprintf('EFEITO NA LIGAÇÃO (dn/dh = -157×10⁻⁶ km⁻¹):\n');
fprintf('  Altura mínima do raio: %.2f m\n', min(y_raio_refratado)*1000);
fprintf('  Folga mínima: %.2f m\n\n', (min(y_raio_refratado) - min(y_terra_real))*1000);

% --- CURVATURA DO RAIO ---
fprintf('CURVATURA DO RAIO ÓTICO:\n');
fprintf('  Para dn/dh negativo: raio curva-se para baixo\n');
fprintf('  Para dn/dh positivo: raio curva-se para cima\n');
fprintf('  Atmosfera padrão: dn/dh = -157×10⁻⁶ km⁻¹\n')