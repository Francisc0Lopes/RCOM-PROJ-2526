% ITEM 3 - CÁLCULO DO GANHO DAS ANTENAS
% Trabalho Prático RCom - Parte I

clear; clc; close all;

fprintf('=== EX 3 - CÁLCULO DO GANHO DAS ANTENAS ===\n\n');

% --- PARÂMETROS DAS ANTENAS ---
diametro_tx = 2.4;      % Diâmetro do prato transmissor [m]
diametro_rx = 1.8;      % Diâmetro do prato recetor [m] 
eta = 0.65;             % Rendimento da antena (65% - valor típico)
f = 6e9;                % Frequência [Hz] - 6 GHz
c = 3e8;                % Velocidade da luz [m/s]

% --- CÁLCULOS ---
lambda = c/f;

% Ganho para antena parabólica: G = η * (π * D / λ)²
G_tx = eta * (pi * diametro_tx / lambda)^2;
G_rx = eta * (pi * diametro_rx / lambda)^2;

% Converter para dB
G_tx_dB = 10 * log10(G_tx);
G_rx_dB = 10 * log10(G_rx);






% --- APRESENTAÇÃO DE RESULTADOS ---
fprintf('PARÂMETROS DA LIGAÇÃO:\n');
fprintf('  Frequência: %.1f GHz\n', f/1e9);
fprintf('  Comprimento de onda: %.3f m\n', lambda);
fprintf('  Rendimento das antenas: %.0f%%\n\n', eta*100);

fprintf('ANTENA TRANSMISSORA:\n');
fprintf('  Diâmetro do prato: %.1f m\n', diametro_tx);
fprintf('  Ganho: %.2f\n', G_tx);
fprintf('  Ganho: %+.2f dBi\n\n', G_tx_dB);

fprintf('ANTENA RECETORA:\n');
fprintf('  Diâmetro do prato: %.1f m\n', diametro_rx);
fprintf('  Ganho: %.2f\n', G_rx);
fprintf('  Ganho: %+.2f dBi\n\n', G_rx_dB);

fprintf('RESUMO:\n');
fprintf('  Ganho total do sistema: %+.2f dB\n', G_tx_dB + G_rx_dB);

% --- GRÁFICO OPCIONAL - VARIAÇÃO COM DIÂMETRO ---
figure;
diametros = 0.5:0.1:3.0;  % Diâmetros de 0.5 a 3.0 metros
ganhos = eta * (pi * diametros / lambda).^2;
ganhos_dB = 10 * log10(ganhos);

plot(diametros, ganhos_dB, 'b-', 'LineWidth', 2);
hold on;
plot(diametro_tx, G_tx_dB, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(diametro_rx, G_rx_dB, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');

xlabel('Diâmetro da Antena [m]');
ylabel('Ganho [dBi]');
title('Variação do Ganho com o Diâmetro da Antena');
legend('Ganho vs Diâmetro', 'Antena Tx', 'Antena Rx', 'Location', 'southeast');
grid on;

fprintf('\n--- Script Item 3 concluído ---\n');