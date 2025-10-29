
clear; clc; close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%1.DESENHO DO RAIO DIRETO%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--- Dados da Ligação ---
d = 45e3;        % distância [m]
h_tx = 40;       % altura antena tx [m]
h_rx = 150;      % altura antena rx [m]

% --- Perfil em Terra Plana ---
x = linspace(0,d,1000);   % eixo horizontal (distância)
y_terra = zeros(size(x)); % Terra plana -> linha a 0 m

% --- Raio Direto ---
y_raio = h_tx + (h_rx-h_tx)*(x/d); % equação da reta





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%2. DESENHO DO PRIMEIRO ELIPSOIDE E OBSTRUCAO%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%3.CÁLCULO DO GANHO DAS ANTENAS%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


% --- APRESENTAÇÃO DE RESULTADOS ---º
fprintf('3. PARÂMETROS DA LIGAÇÃO:\n');
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%4. CÁLCULO DA ATENUAÇÃO NAS GUIAS%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%5.CÁLCULO DA ATENUAÇÃO ESPAÇO LIVRE%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- PARÂMETROS DA LIGAÇÃO ---
d = 45;              % Distância [km] - conforme enunciado
f_MHz = 6000;        % Frequência [MHz] - 6 GHz

% --- FÓRMULA ITU-R PN.525-2 ---
A0_dB = 32.4 + 20*log10(d) + 20*log10(f_MHz);

% --- RESULTADO ---
fprintf('PARÂMETROS:\n');
fprintf('  Distância: %.1f km\n', d);
fprintf('  Frequência: %.1f GHz\n', f_MHz/1000);
fprintf('\nRESULTADO:\n');
fprintf('  Atenuação em espaço livre: %.2f dB\n', A0_dB);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%6.CALCULO DAS HORIZONTAIS E ANGULOS DE FOGO %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%7.CALCULO DA LOCALIZAÇÃO DO PONTO DE REFLEXÃO E FATOR DE DIVERGÊNCIA%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- PARÂMETROS ---
d = 45;          % Distância [km]
h_tx = 40;       % Altura TX [m]  
h_rx = 150;      % Altura RX [m]
R = 6370;        % Raio Terra [km]

% --- PONTO DE REFLEXÃO (aproximado) ---
d1 = d * h_tx/(h_tx + h_rx);  % Distância do TX ao ponto de reflexão

% --- FATOR DE DIVERGÊNCIA ---
psi = atand((h_tx + h_rx)/d); % Ângulo de incidência
D = 1/sqrt(1 + (2*d1*(d-d1))/(R*d*sind(psi))); % Fator divergência

% --- RESULTADOS ---
fprintf('PONTO DE REFLEXÃO:\n');
fprintf('  Distância do TX: %.2f km\n', d1);
fprintf('  Distância do RX: %.2f km\n', d-d1);

fprintf('\nFATOR DE DIVERGÊNCIA:\n');
fprintf('  Ângulo incidência: %.4f°\n', psi);
fprintf('  Fator divergência: %.4f\n', D);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%8.Diferença de fase entre o campo associado ao raio direto e o associado ao raio refletido no terreno%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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





