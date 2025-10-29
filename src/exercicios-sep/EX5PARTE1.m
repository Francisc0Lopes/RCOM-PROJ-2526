% ITEM 5 - CÁLCULO DA ATENUAÇÃO DE ESPAÇO LIVRE
% Trabalho Prático RCom - Parte I
% Segundo slides: "Propagação em Espaço Livre"

clear; clc; close all;

fprintf('=== ITEM 5 - CÁLCULO DA ATENUAÇÃO DE ESPAÇO LIVRE ===\n\n');

% --- PARÂMETROS DA LIGAÇÃO ---
d = 45;              % Distância [km] - conforme enunciado
f_MHz = 6000;        % Frequência [MHz] - 6 GHz
f_GHz = f_MHz / 1000; % Frequência [GHz]

% --- FÓRMULA DA RECOMENDAÇÃO ITU-R PN.525-2 ---
% A0 = 32.4 + 20*log10(d_km) + 20*log10(f_MHz)
A0_dB = 32.4 + 20*log10(d) + 20*log10(f_MHz);

% --- FÓRMULA ALTERNATIVA DO SLIDE ---
% A0 = -20*log10(λ/(4πd)) = 20*log10(4πd/λ)
lambda = 0.3 / f_GHz;  % Comprimento de onda [m]
A0_alt = 20*log10(4*pi*d*1000/lambda);

% --- APRESENTAÇÃO DE RESULTADOS ---
fprintf('PARÂMETROS DA LIGAÇÃO:\n');
fprintf('  Distância: %.1f km\n', d);
fprintf('  Frequência: %.1f GHz (%.0f MHz)\n', f_GHz, f_MHz);
fprintf('  Comprimento de onda: %.3f m\n\n', lambda);

fprintf('CÁLCULO DA ATENUAÇÃO:\n');
fprintf('  Fórmula ITU-R PN.525-2:\n');
fprintf('    A0 = 32.4 + 20*log10(%.1f) + 20*log10(%.0f)\n', d, f_MHz);
fprintf('    A0 = 32.4 + %.2f + %.2f\n', 20*log10(d), 20*log10(f_MHz));
fprintf('    A0 = %.2f dB\n\n', A0_dB);

fprintf('  Fórmula alternativa:\n');
fprintf('    A0 = 20*log10(4πd/λ)\n');
fprintf('    A0 = 20*log10(4π×%.1f×1000/%.3f)\n', d, lambda);
fprintf('    A0 = 20*log10(%.0f)\n', 4*pi*d*1000/lambda);
fprintf('    A0 = %.2f dB\n\n', A0_alt);

fprintf('RESULTADO FINAL:\n');
fprintf('  Atenuação em espaço livre: %.2f dB\n\n', A0_dB);

% --- GRÁFICO 1: ATENUAÇÃO vs DISTÂNCIA ---
figure('Position', [100, 100, 1200, 500]);

subplot(1,2,1);
distancias = 1:1:100;  % Distâncias de 1 a 100 km

% Calcular atenuação para diferentes distâncias
A0_vs_distancia = 32.4 + 20*log10(distancias) + 20*log10(f_MHz);

plot(distancias, A0_vs_distancia, 'b-', 'LineWidth', 2);
hold on;
plot(d, A0_dB, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

xlabel('Distância [km]');
ylabel('Atenuação A₀ [dB]');
title(sprintf('Atenuação vs Distância (f = %.1f GHz)', f_GHz));
legend('Atenuação', 'Ponto de trabalho', 'Location', 'northwest');
grid on;

% --- GRÁFICO 2: ATENUAÇÃO vs FREQUÊNCIA ---
subplot(1,2,2);
frequencias_GHz = [1, 2.4, 5, 6, 10, 18, 24, 60];  % Frequências típicas
frequencias_MHz = frequencias_GHz * 1000;

% Calcular atenuação para diferentes frequências
A0_vs_frequencia = 32.4 + 20*log10(d) + 20*log10(frequencias_MHz);

plot(frequencias_GHz, A0_vs_frequencia, 'g-', 'LineWidth', 2);
hold on;
plot(f_GHz, A0_dB, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

xlabel('Frequência [GHz]');
ylabel('Atenuação A₀ [dB]');
title(sprintf('Atenuação vs Frequência (d = %.1f km)', d));
legend('Atenuação', 'Ponto de trabalho', 'Location', 'northwest');
grid on;

% --- TABELA DE VALORES TÍPICOS ---
fprintf('\n--- VALORES TÍPICOS DE ATENUAÇÃO ---\n');
fprintf('Distância\tFrequência\tAtenuação\n');
fprintf('[km]\t\t[GHz]\t\t[dB]\n');
fprintf('-------------------------------------\n');

distancias_tipicas = [10, 25, 45, 60, 80];
frequencias_tipicas = [2.4, 6, 10, 18, 24];

for i = 1:length(distancias_tipicas)
    for j = 1:length(frequencias_tipicas)
        A_tipico = 32.4 + 20*log10(distancias_tipicas(i)) + ...
                   20*log10(frequencias_tipicas(j)*1000);
        fprintf('%.0f\t\t%.1f\t\t%.1f\n', ...
                distancias_tipicas(i), frequencias_tipicas(j), A_tipico);
    end
end

fprintf('\n--- Script Item 5 concluído ---\n');