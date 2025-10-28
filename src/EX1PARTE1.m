
%--- Dados da Ligação ---
d = 45e3;        % distância entre antenas [m]
h_tx = 40;       % altura da antena transmissora [m]
h_rx = 150;      % altura da antena recetora [m]

% --- Perfil em Terra Plana ---
x = linspace(0,d,1000);   % eixo horizontal (distância)
y_terra = zeros(size(x)); % Terra plana -> linha a 0 m

% --- Raio Direto ---
y_raio = h_tx + (h_rx-h_tx)*(x/d); % equação da reta





%PLOT1%

figure;
plot(x/1000, y_terra, 'k', 'LineWidth',1.5); hold on;   % solo
plot(x/1000, y_raio, 'r', 'LineWidth',2);               % raio direto
plot(0,h_tx,'bo','MarkerFaceColor','b');                % transmissor
plot(d/1000,h_rx,'go','MarkerFaceColor','g');           % recetor

xlabel('Distância [km]');
ylabel('Altura [m]');
title('Raio Direto - Ligação Hertziana (Terra Plana)');
legend('Solo','Raio Direto','Tx','Rx','Location','Best');
grid on;
