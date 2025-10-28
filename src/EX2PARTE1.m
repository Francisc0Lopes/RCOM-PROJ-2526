clear; clc; close all;

%--- Dados da Ligação ---
d = 45e3;        % distância entre antenas [m]
h_tx = 40;       % altura da antena transmissora [m]
h_rx = 150;      % altura da antena recetora [m]

% --- Perfil em Terra Plana ---
x = linspace(0,d,1000);   % eixo horizontal (distância)
y_terra = zeros(size(x)); % Terra plana -> linha a 0 m

% --- Raio Direto ---

y_raio = h_tx + (h_rx-h_tx)*(x/d); % equação da reta


% --- Dados para Fresnel ---
f = 6e9;         % frequência [Hz] - exemplo 6 GHz
c = 3e8;         % velocidade da luz [m/s]
lambda = c/f;    % comprimento de onda

% --- Primeiro Elipsóide de Fresnel ---
r_fresnel = sqrt(lambda * x .* (d - x) / d);        % raio em cada ponto
y_fresnel_sup = y_raio + r_fresnel;                 % contorno superior
y_fresnel_inf = y_raio - r_fresnel;                 % contorno inferior

% --- Verificação de obstrução ---
obstruido = any(y_fresnel_inf < y_terra);           % TRUE se tocar no solo







%%PLOT%%
figure;
plot(x/1000, y_terra, 'k', 'LineWidth',1.5); hold on;   % solo
plot(x/1000, y_raio, 'r', 'LineWidth',2);               % raio direto
plot(x/1000, y_fresnel_sup, 'b--', 'LineWidth', 1);     % contorno superior
plot(x/1000, y_fresnel_inf, 'b--', 'LineWidth', 1);     % contorno inferior
plot(0,h_tx,'bo','MarkerFaceColor','b');                % transmissor
plot(d/1000,h_rx,'go','MarkerFaceColor','g');           % recetor

% Preenchimento da zona de Fresnel
fill([x/1000, fliplr(x/1000)], [y_fresnel_sup, fliplr(y_fresnel_inf)], ...
     'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

xlabel('Distância [km]');
ylabel('Altura [m]');
title(sprintf('Item 2 - 1º Elipsóide de Fresnel (Obstruído: %s)', string(obstruido)));
legend('Solo', 'Raio Direto', 'Contorno Fresnel', '', 'Tx', 'Rx', ...
       'Zona Fresnel', 'Location', 'Best');
grid on;


