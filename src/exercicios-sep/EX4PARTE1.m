% ITEM 4 - CÁLCULO DA ATENUAÇÃO NOS GUIAS
% Trabalho Prático RCom - Parte I

clear; clc; close all;

fprintf('=== ITEM 4 - CÁLCULO DA ATENUAÇÃO NOS GUIAS ===\n\n');

% --- PARÂMETROS DOS GUIAS DE ONDA ---
comprimento_guia_tx = 15;      % Comprimento do guia transmissor [m]
comprimento_guia_rx = 12;      % Comprimento do guio recetor [m] 
atenuacao_guia = 0.1;          % Atenuação do guia [dB/m] - valor típico

% --- CÁLCULOS ---
% Atenuação total = comprimento × atenuação por metro
A_guia_tx = comprimento_guia_tx * atenuacao_guia;
A_guia_rx = comprimento_guia_rx * atenuacao_guia;
A_guia_total = A_guia_tx + A_guia_rx;

% --- APRESENTAÇÃO DE RESULTADOS ---
fprintf('PARÂMETROS DOS GUIAS:\n');
fprintf('  Atenuação do guia: %.2f dB/m\n\n', atenuacao_guia);

fprintf('GUIA TRANSMISSOR:\n');
fprintf('  Comprimento: %.1f m\n', comprimento_guia_tx);
fprintf('  Atenuação: %.2f dB\n\n', A_guia_tx);

fprintf('GUIA RECETOR:\n');
fprintf('  Comprimento: %.1f m\n', comprimento_guia_rx);
fprintf('  Atenuação: %.2f dB\n\n', A_guia_rx);

fprintf('RESUMO:\n');
fprintf('  Atenuação total nos guias: %.2f dB\n', A_guia_total);

% --- GRÁFICO - VARIAÇÃO COM COMPRIMENTO DO GUIA ---
figure;
comprimentos = 0:1:30;  % Comprimentos de 0 a 30 metros
atenuacoes = comprimentos * atenuacao_guia;

plot(comprimentos, atenuacoes, 'b-', 'LineWidth', 2);
hold on;
plot(comprimento_guia_tx, A_guia_tx, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(comprimento_guia_rx, A_guia_rx, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');

xlabel('Comprimento do Guia [m]');
ylabel('Atenuação [dB]');
title('Variação da Atenuação com o Comprimento do Guia');
legend('Atenuação vs Comprimento', 'Guia Tx', 'Guia Rx', 'Location', 'northwest');
grid on;

% --- TABELA COMPARATIVA PARA DIFERENTES VALORES DE ATENUAÇÃO ---
fprintf('\n--- COMPARAÇÃO PARA DIFERENTES VALORES DE ATENUAÇÃO ---\n');
atenuacoes_guia = [0.05, 0.1, 0.15, 0.2];  % dB/m

fprintf('Atenuação\tTx (dB)\t\tRx (dB)\t\tTotal (dB)\n');
fprintf('(dB/m)\t\t%.1fm\t\t%.1fm\t\t\n', comprimento_guia_tx, comprimento_guia_rx);
fprintf('----------------------------------------------------\n');

for i = 1:length(atenuacoes_guia)
    A_tx = comprimento_guia_tx * atenuacoes_guia(i);
    A_rx = comprimento_guia_rx * atenuacoes_guia(i);
    A_total = A_tx + A_rx;
    
    fprintf('%.2f\t\t%.2f\t\t%.2f\t\t%.2f\n', ...
            atenuacoes_guia(i), A_tx, A_rx, A_total);
end

fprintf('\n--- Script Item 4 concluído ---\n');