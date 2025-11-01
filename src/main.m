
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
fprintf('DIFERENÇA DE FASE:\n');
fprintf('  Diferença percurso: %.4f m\n', delta_r);
fprintf('  Comprimento onda: %.4f m\n', lambda);
fprintf('  Diferença fase: %.2f°\n', delta_phi);

fprintf('\nCOEFICIENTE DE FRESNEL:\n');
fprintf('  Γ = %.1f\n', Gamma);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%9. Comparação Terra Plana-Terra Esférica. Análise da Diferença de fase. %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- PARÂMETROS ---
d = 45;          % Distância [km]
h_tx = 150;      % Altura TX [m]  
h_rx = 150;      % Altura RX [m]
R = 6370;        % Raio Terra [km]
f = 1e9;         % Frequência [Hz]
c = 3e8;         % Velocidade luz [m/s]

% --- TERRA PLANA (Slide 12) ---
delta_r_plana = (2 * h_tx * h_rx) / (d * 1000); % [m]

% --- TERRA ESFÉRICA (Slide 26) ---
% Alturas equivalentes (Slide 24)
h_tx_eq = h_tx - ((d/2)^2*1000)/(2*R*1000);
h_rx_eq = h_rx - ((d/2)^2*1000)/(2*R*1000);
delta_r_esferica = (2 * h_tx_eq * h_rx_eq) / (d * 1000); % [m]

% --- DIFERENÇA DE FASE ---
lambda = c/f;
delta_phi_plana = (2 * pi * delta_r_plana / lambda);
delta_phi_esferica = (2 * pi * delta_r_esferica / lambda);

% --- RESULTADOS ---
fprintf('DIFERENÇA DE PERCURSOS (Slide 26):\n');
fprintf('  Terra Plana:   Δr = %.4f m\n', delta_r_plana);
fprintf('  Terra Esférica: Δr = %.4f m\n', delta_r_esferica);
fprintf('  Diferença:     %.4f m\n', delta_r_plana - delta_r_esferica);

fprintf('\nDIFERENÇA DE FASE (Slide 27):\n');
fprintf('  Terra Plana:   Δφ = %.2f rad\n', delta_phi_plana);
fprintf('  Terra Esférica: Δφ = %.2f rad\n', delta_phi_esferica);
fprintf('  Diferença:     %.2f rad\n', delta_phi_plana - delta_phi_esferica);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%10. Cálculo da potência total recebida em Terra Plana e Terra Esférica.  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- PARÂMETROS ---
P_tx = 10;              % Potência TX [W] - Slide 2
d = 45;                 % Distância [km]
f = 6e9;                % Frequência [Hz]
c = 3e8;                % Velocidade luz [m/s]
G_tx = 1000;            % Ganho TX 
G_rx = 1000;            % Ganho RX

% --- ESPAÇO LIVRE (Slide 3) ---
lambda = c/f;
A0 = (lambda/(4*pi*d*1000))^2;
P_r_livre = P_tx * G_tx * G_rx * A0;

% --- TERRA PLANA (Slide 14) ---
% Fator de interferência para terra plana
h_tx = 40;
h_rx = 150;
delta_r = (2 * h_tx * h_rx) / (d * 1000);
F_interf = 4 * (sin(pi * delta_r / lambda))^2;
P_r_plana = P_r_livre * F_interf;

% --- TERRA ESFÉRICA (Slide 29) ---
% Com factor de divergência
R = 6370;
h_tx_eq = h_tx - (d^2)/(2*R*1000);
h_rx_eq = h_rx - (d^2)/(2*R*1000);
delta_r_esf = (2 * h_tx_eq * h_rx_eq) / (d * 1000);
D = 0.85; % Factor divergência aproximado
F_interf_esf = abs(1 + D * exp(-1j*2*pi*delta_r_esf/lambda))^2;
P_r_esferica = P_r_livre * F_interf_esf;

% --- RESULTADOS ---
fprintf('POTÊNCIA RECEBIDA:\n');
fprintf('  Espaço Livre:  %.2e W\n', P_r_livre);
fprintf('  Terra Plana:   %.2e W\n', P_r_plana);
fprintf('  Terra Esférica: %.2e W\n', P_r_esferica);

fprintf('\nEM dBm:\n');
fprintf('  Espaço Livre:  %.1f dBm\n', 10*log10(P_r_livre*1000));
fprintf('  Terra Plana:   %.1f dBm\n', 10*log10(P_r_plana*1000));
fprintf('  Terra Esférica: %.1f dBm\n', 10*log10(P_r_esferica*1000));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%11.Cálculo da atenuação provocada pelo vapor de água e pelo oxigénio presente na atmosfera, em função da temperatura e humidade relativa.%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%12. Cálculo da atenuação provocada pela chuva, não excedida numa determinada percentagem do tempo, relativamente à média anual ou ao pior mês, numa determinada zona%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
d = 45;                 % Distância [km]
R = 10;                 % Intensidade de chuva [mm/h] - pior mês
percentagem_tempo = 0.1; % % do tempo não excedida (0.1% = pior caso)

% --- COEFICIENTES ITU-R P.838 PARA 6 GHz ---
k_H = 0.00102;  % Coeficiente k para polarização horizontal
alpha_H = 0.912; % Expoente alpha para polarização horizontal
k_V = 0.00085;  % Coeficiente k para polarização vertical  
alpha_V = 0.931; % Expoente alpha para polarização vertical

% --- ATENUAÇÃO ESPECÍFICA ---
gamma_H = k_H * R^alpha_H; % [dB/km] - polarização horizontal
gamma_V = k_V * R^alpha_V; % [dB/km] - polarização vertical

% --- FATOR DE REDUÇÃO DE DISTÂNCIA ---
% Para distâncias > 5 km, aplicar fator de redução
d_eff = d / (1 + d/35); % [km] - distância efetiva

% --- ATENUAÇÃO TOTAL ---
A_chuva_H = gamma_H * d_eff; % [dB] - polarização horizontal
A_chuva_V = gamma_V * d_eff; % [dB] - polarização vertical

% --- RESULTADOS ---
fprintf('PARÂMETROS DE CHUVA:\n');
fprintf('  Frequência: %.1f GHz\n', f/1e9);
fprintf('  Distância: %.1f km\n', d);
fprintf('  Intensidade chuva: %.0f mm/h\n', R);
fprintf('  Percentagem tempo: %.1f%%\n', percentagem_tempo);
fprintf('  Distância efetiva: %.1f km\n\n', d_eff);

fprintf('COEFICIENTES ITU-R P.838:\n');
fprintf('  Polarização Horizontal: k = %.6f, α = %.3f\n', k_H, alpha_H);
fprintf('  Polarização Vertical:   k = %.6f, α = %.3f\n\n', k_V, alpha_V);

fprintf('ATENUAÇÃO ESPECÍFICA:\n');
fprintf('  Polarização Horizontal: γ = %.4f dB/km\n', gamma_H);
fprintf('  Polarização Vertical:   γ = %.4f dB/km\n\n', gamma_V);

fprintf('ATENUAÇÃO TOTAL:\n');
fprintf('  Polarização Horizontal: %.2f dB\n', A_chuva_H);
fprintf('  Polarização Vertical:   %.2f dB\n', A_chuva_V);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%13. Modelação dos Efeitos Refrativos na Atmosfera %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%14.  Implementação do método de cálculo de Difração em Terra Esférica existente na recomendação P.526-5 da ITU-R.%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
d = 45;                 % Distância [km]
h_tx = 40;              % Altura TX [m]
h_rx = 150;             % Altura RX [m]
R_terra = 6370;         % Raio da Terra [km]

% --- COMPRIMENTO DE ONDA ---
c = 3e8;
lambda = c/f;

% --- PARÂMETROS NORMALIZADOS (ITU-R P.526-5) ---
% Raio efetivo da Terra
a_ef = R_terra * 1000; % [m]

% Parâmetros de altura normalizada
X_tx = 2.2 * f^(1/3) * a_ef^(-2/3) * d * 1000;
X_rx = 2.2 * f^(1/3) * a_ef^(-2/3) * d * 1000;
Y_tx = 9.6e-3 * f^(2/3) * a_ef^(-1/3) * h_tx;
Y_rx = 9.6e-3 * f^(2/3) * a_ef^(-1/3) * h_rx;

% Parâmetro de difração
C = X_tx + X_rx + Y_tx + Y_rx;

% --- PERDA POR DIFRAÇÃO (Método ITU-R P.526-5) ---
if C < 1.6
    % Região de interferência
    L_dif = 6.9 + 20*log10(sqrt((C-0.1)^2+1) + C - 0.1);
else
    % Região de difração
    L_dif = 20*log10(C) + 9.5;
end

% --- RESULTADOS ---
fprintf('PARÂMETROS ITU-R P.526-5:\n');
fprintf('  Frequência: %.1f GHz\n', f/1e9);
fprintf('  Distância: %.1f km\n', d);
fprintf('  Altura TX: %.1f m\n', h_tx);
fprintf('  Altura RX: %.1f m\n', h_rx);
fprintf('  Comprimento onda: %.3f m\n\n', lambda);

fprintf('PARÂMETROS NORMALIZADOS:\n');
fprintf('  X_tx: %.3f\n', X_tx);
fprintf('  X_rx: %.3f\n', X_rx);
fprintf('  Y_tx: %.3f\n', Y_tx);
fprintf('  Y_rx: %.3f\n', Y_rx);
fprintf('  C: %.3f\n\n', C);

fprintf('RESULTADO:\n');
fprintf('  Perda por difração: %.2f dB\n', L_dif);

if C < 1.6
    fprintf('  Região: Interferência\n');
else
    fprintf('  Região: Difração\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%15.  Implementação do método de cálculo associado ao fenómeno Dispersão Troposférica, existente na recomendação P.617-1 da ITU-R. %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
d = 200;                % Distância [km] - típica para dispersão
theta = 0.5;            % Ângulo de elevação [graus]
N0 = 320;               % Índice de refração à superfície [N-units]

% --- PERDA BÁSICA POR DISPERSÃO (ITU-R P.617-1) ---
% Perda mediana anual para 50% do tempo

% Termo de frequência
L_f = 25 * log10(f/1e9) - 2.5 * (log10(f/1e9))^2;

% Termo de distância  
L_d = 0.6 * d;

% Termo angular
L_theta = 0.07 * d * theta;

% Termo climático
L_N = 0.05 * N0;

% Perda básica total
L_bs = 174 + L_f + L_d + L_theta + L_N;

% --- PERDA PARA OUTROS PERCENTIS ---
% Fator para 0.1% do tempo
sigma = 8; % [dB] - variabilidade anual
L_01 = L_bs - 3.1 * sigma;

% Fator para 99.9% do tempo  
L_999 = L_bs + 3.1 * sigma;

% --- RESULTADOS ---
fprintf('PARÂMETROS ITU-R P.617-1:\n');
fprintf('  Frequência: %.1f GHz\n', f/1e9);
fprintf('  Distância: %.0f km\n', d);
fprintf('  Ângulo elevação: %.1f°\n', theta);
fprintf('  Índice refração N0: %.0f N-units\n\n', N0);

fprintf('COMPONENTES DA PERDA (50%% tempo):\n');
fprintf('  Termo frequência: %.2f dB\n', L_f);
fprintf('  Termo distância: %.2f dB\n', L_d);
fprintf('  Termo angular: %.2f dB\n', L_theta);
fprintf('  Termo climático: %.2f dB\n', L_N);
fprintf('  Perda básica: %.2f dB\n\n', L_bs);

fprintf('PERDA PARA DIFERENTES PERCENTIS:\n');
fprintf('  0.1%% do tempo: %.2f dB\n', L_01);
fprintf('  50%% do tempo: %.2f dB\n', L_bs);
fprintf('  99.9%% do tempo: %.2f dB\n', L_999);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%16. Perdas por Difração devido ao Terreno usando o método de Deygout.%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


