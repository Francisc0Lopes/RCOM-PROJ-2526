% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
h_tx = 40;              % Altura TX [m]
h_rx = 150;             % Altura RX [m]
R_terra = 6370;         % Raio da Terra [km]

theta = 0.5;            % Ângulo de elevação [graus]
N0 = 320;               % Índice de refração à superfície [N-units]
M = 34.115;              % Parametro meteorologico dado para clima tipo 5 - Mediterranico (fiz a média entre o 4 e o 6)
ypslon = 0.27;          % Parametro que traduz a estrutura da atmosfera para clima tipo 5
r = 6370;               %Raio efetivo da terra [km]
Ge = 8;                 %Ganho de emissão [dB]
Gr= 8;                  % Ganho de receção [dB]



% --- COMPRIMENTO DE ONDA ---
c = 3e8;
lambda = c/f;

% --- PARÂMETROS NORMALIZADOS (ITU-R P.526-5) ---
% Raio efetivo da Terra
a_ef = R_terra * 1000; % [m]


% Comprimento do percuso entre radiohorizontes (dde)

dde = d - sqrt(2*a_ef*h_tx)-sqrt(2*a_ef*h_rx);


% Atenuacao por Difracao 

beta1 = 0.99; % Beta para Terreno Médio
beta2 = 0.97; % Beta para agua do Mar

distancia = 100000;  % [m] 

atenua_esferica = [];
dist_array = [];
while distancia<1000000

    X = beta1*distancia*((pi/(lambda*a_ef^2))^(1/3));
    Y1 = 2*beta1*h_tx*(((pi^2)/((lambda^2) *a_ef))^(1/3));
    Y2 = 2*beta1*h_rx*(((pi^2)/((lambda^2) *a_ef))^(1/3));
    
    F= 11+10*log10(X)-17.6*X;
    G1 = 17.6*(sqrt(Y1-1.1))-5*log10(Y1-1.1)-8;
    G2 = 17.6*(sqrt(Y2-1.1))-5*log10(Y2-1.1)-8;
    
    Aed = -(F+G1+G2);

    dist_array(end+1)=distancia;
    atenua_esferica(end+1)=Aed;

    distancia=distancia+50000;
end


% --- PERDA BÁSICA POR DISPERSÃO (ITU-R P.617-1) ---



% Perda mediana anual para 50% do tempo
distancia_km = 100;
atenua_tropo = [];
dist_km_array = [];
while distancia_km<1000
    % Termo de frequência
    L_f = 25 * log10(f/1e9) - 2.5 * (log10(f/1e9))^2;
    
    % Termo de distância  
    L_d = 0.6 * distancia_km;
    
    % Termo angular
    L_theta = 0.07 * distancia_km * theta;
    
    % Termo climático
    L_N = 0.05 * N0;
    
    % Perda básica total
    L_bs = 174 + L_f + L_d + L_theta + L_N;
    
    
    H = (theta*distancia_km)/(4*10^3);
    
    h = ((theta^2)*r)/(8*10^6);
    
    N = 20*log10(5+ypslon*H)+4.34*ypslon*h;
    
    Lc= 0.07*exp(0.055*(Ge+Gr));
    
    Gp= Ge+Gr-Lc;
    
    %Perda para 50%
    
    A= 30*log10(f)+10*log10(distancia_km)+30*log10(theta)+M+N+Gp;

    

    atenua_tropo(end+1)=A;
    dist_km_array(end+1) =distancia_km ;
    distancia_km=distancia_km+50;

end


    % --- PERDA PARA OUTROS PERCENTIS ---
    % Fator para 0.1% do tempo
    sigma = 8; % [dB] - variabilidade anual
    L_01 = L_bs - 3.1 * sigma;
    
    % Fator para 99.9% do tempo  
    L_999 = L_bs + 3.1 * sigma;

% --- RESULTADOS ---

figure(1);
plot(atenua_esferica,dist_array);
xlabel("Atenuação [dB]")
ylabel("Distancia [m]")
title("Perda por difração de terra esférica em relação à distância")

figure(2);
plot(atenua_tropo,dist_km_array)
xlabel("Atenuação [dB]")
ylabel("Distancia [m]")
title("Perda por dispersão de terra tropoesférica em relação à distância")
