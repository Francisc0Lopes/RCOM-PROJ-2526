% --- PARÂMETROS ---
f = 6e9;                % Frequência [Hz] - 6 GHz
h_tx = 40;              % Altura TX [m]
h_rx = 150;             % Altura RX [m]
R_terra = 6370;         % Raio da Terra [km]

N0 = 320;               % Índice de refração à superfície [N-units]
M = 33.20;              % Parametro meteorologico dado para clima tipo 7a 
ypslon = 0.27;          % Parametro que traduz a estrutura da atmosfera para clima tipo 7a
r = 8500;               %Raio efetivo da terra [km]
Ge = 8;                 %Ganho de emissão [dB]
Gr= 8;                  % Ganho de receção [dB]



% --- COMPRIMENTO DE ONDA ---
c = 3e8;
lambda = c/f;

% --- PARÂMETROS NORMALIZADOS (ITU-R P.526-5) ---
% Raio efetivo da Terra em metros
a_ef = R_terra * 1000; % [m]


% Comprimento do percuso entre radiohorizontes (dde)

dde = 100000 - sqrt(2*a_ef*h_tx)-sqrt(2*a_ef*h_rx);


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

    if(Aed>200)
        Aed=400;
    end
    atenua_esferica(end+1)=Aed;

    distancia=distancia+50000;

end


% --- PERDA BÁSICA POR DISPERSÃO (ITU-R P.617-1) ---



% Perda mediana anual para 50% do tempo
distancia_km = 100;
atenua_tropo = [];
dist_km_array = [];


while distancia_km<1000
    

    %Perguntar prof se tá certo a formula
    drhe=sqrt(2*a_ef*h_tx);

    drhr=sqrt(2*a_ef*h_rx);

    theta_tx=deg2rad(asin(h_tx/drhe));

    theta_rx=deg2rad(asin(h_rx/drhr));


    theta=(theta_rx+theta_tx)*1000;
    
    
    H = (theta*distancia_km)/(4*10^3);
    
    h = ((theta^2)*r)/(8*10^6);
    
    N = 20*log10(5+ypslon*H)+4.34*ypslon*h;
    
    Lc= 0.07*exp(0.055*(Ge+Gr));
    
    Gp= Ge+Gr-Lc;
    
    %Perda para 50%
    
    A= 30*log10(f/1e6)+10*log10(distancia_km)+30*log10(theta)+M+N+Gp;

    

    atenua_tropo(end+1)=A;
    dist_km_array(end+1) =distancia_km ;

    distancia_km=distancia_km+50;

end

% --- RESULTADOS ---

%fprintf("Comprimento do percurso entre radio horizontes: %.2f",dde);

figure(1);
plot(dist_array/1000,atenua_esferica);
ylabel("Atenuação [dB]")
xlabel("Distancia [km]")
title("Perda por difração de terra esférica em relação à distância")
hold on
plot(dist_km_array,atenua_tropo)
ylabel("Atenuação [dB]")
xlabel("Distancia [km]")
title("Perda por dispersão de terra tropoesférica em relação à distância")