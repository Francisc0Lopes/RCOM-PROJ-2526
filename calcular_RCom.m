function [texto, dados_graf] = calcular_RCom(inputs, modo)
% calcular_RCom - Função principal de cálculo usada pela interface.
% inputs: struct com campos (dist_km, h_tx, h_rx, f_GHz, P_tx, diametro_tx, diametro_rx, eta_percent, comprimento_guia_tx, comprimento_guia_rx, atenuacao_guia)
% modo: 'fresnel' | 'antenas' | 'guias' | 'espaco' | 'difracao'
% Retorna:
% texto - cell array de linhas para mostrar em INFORMAÇÕES
% dados_graf - struct com campos para plot (x_km, y_terra, y_raio, y_fresnel_sup, y_fresnel_inf, x_plot, y_plot, ...)

    % inicializa saídas
    texto = {};
    dados_graf = struct();

    % converte e prepara
    d_km = inputs.dist_km;
    d_m = d_km * 1000;
    h_tx = inputs.h_tx;
    h_rx = inputs.h_rx;
    f_Hz = inputs.f_GHz * 1e9;
    P_tx = inputs.P_tx;
    D_tx = inputs.diametro_tx;
    D_rx = inputs.diametro_rx;
    eta = inputs.eta_percent / 100;
    c = 3e8;
    lambda = c / f_Hz;

    switch lower(modo)
        case 'fresnel'
            % Raio direto e primeiro elipsóide
            x = linspace(0, d_m, 1000);
            x_km = x/1000;
            y_terra = zeros(size(x));
            y_raio = h_tx + (h_rx - h_tx) * (x / d_m);
            r_fresnel = sqrt(lambda .* x .* (d_m - x) ./ d_m);
            y_fresnel_sup = y_raio + r_fresnel;
            y_fresnel_inf = y_raio - r_fresnel;
            obstruido = any(y_fresnel_inf < y_terra);

            % preenche dados_graf
            dados_graf.x_km = x_km;
            dados_graf.y_terra = y_terra;
            datos = []; %#ok<NASGU>
            dados_graf.y_raio = y_raio;
            dados_graf.y_fresnel_sup = y_fresnel_sup;
            dados_graf.y_fresnel_inf = y_fresnel_inf;

            % texto
            texto = {
                sprintf('MODO: Raio Direto e 1º Elipsoide de Fresnel')
                sprintf('Distância: %.1f km', d_km)
                sprintf('Frequência: %.2f GHz', inputs.f_GHz)
                sprintf('Comprimento de onda: %.4f m', lambda)
                sprintf('Obstruído pelo solo: %s', string(obstruido))
                sprintf('Raio Fresnel máximo (m): %.3f', max(r_fresnel))
                sprintf('Altura Tx: %.1f m, Altura Rx: %.1f m', h_tx, h_rx)
                };
        case 'antenas'
            % Ganhos de antena parabólica
            G_tx = eta * (pi * D_tx / lambda)^2;
            G_rx = eta * (pi * D_rx / lambda)^2;
            G_tx_dB = 10*log10(G_tx);
            G_rx_dB = 10*log10(G_rx);
            texto = {
                'MODO: Antenas'
                sprintf('Diâmetro TX: %.2f m   Diâmetro RX: %.2f m', D_tx, D_rx)
                sprintf('Eficiência (%%): %.1f', inputs.eta_percent)
                sprintf('Ganho TX: %.2f (linear)  |  %+.2f dBi', G_tx, G_tx_dB)
                sprintf('Ganho RX: %.2f (linear)  |  %+.2f dBi', G_rx, G_rx_dB)
                sprintf('Ganho total (dB): %+.2f dB', G_tx_dB + G_rx_dB)
                };
            % para o gráfico mostra uma curva simbólica (ex: diagrama de radiação simplificado)
            theta = linspace(0,2*pi,200);
            r = abs(cos(theta)).^4 * max([D_tx D_rx])*2;
            dados_graf.x_plot = cos(theta);
            dados_graf.y_plot = sin(theta) .* r;
        case 'guias'
            % Atenuação em guias
            A_guia_tx = inputs.comprimento_guia_tx * inputs.atenuacao_guia;
            A_guia_rx = inputs.comprimento_guia_rx * inputs.atenuacao_guia;
            A_total = A_guia_tx + A_guia_rx;
            texto = {
                'MODO: Guias de Onda'
                sprintf('Comprimento Guia TX: %.1f m', inputs.comprimento_guia_tx)
                sprintf('Comprimento Guia RX: %.1f m', inputs.comprimento_guia_rx)
                sprintf('Atenuação por metro: %.3f dB/m', inputs.atenuacao_guia)
                sprintf('Atenuação Tx: %.3f dB', A_guia_tx)
                sprintf('Atenuação Rx: %.3f dB', A_guia_rx)
                sprintf('Atenuação total: %.3f dB', A_total)
                };
            % plot atenuacao vs comprimento (simples)
            comprimentos = 0:1:30;
            atenuacoes = comprimentos * inputs.atenuacao_guia;
            dados_graf.x_plot = comprimentos;
            dados_graf.y_plot = atenuacoes;
        case 'espaco'
            % Free-space path loss (ITU-like)
            d_km = inputs.dist_km;
            f_MHz = inputs.f_GHz * 1000;
            A0 = 32.4 + 20*log10(d_km) + 20*log10(f_MHz);
            texto = {
                'MODO: Atenuação Espaço Livre (ITU)'
                sprintf('Distância: %.1f km', d_km)
                sprintf('Frequência: %.2f GHz', inputs.f_GHz)
                sprintf('Atenuação A0: %.2f dB', A0)
                };
            % gráfico: A0 vs distância para demonstração
            d_plot = linspace(0.1,100,200);
            A_plot = 32.4 + 20*log10(d_plot) + 20*log10(f_MHz);
            dados_graf.x_plot = d_plot;
            dados_graf.y_plot = A_plot;
        case 'difracao'
            % Implementa versão simples de difração (ITU-like crude)
            % Usa fórmulas simplificadas para demonstração
            % Parametros
            R_earth = 6370; % km
            d = inputs.dist_km;
            h_tx = inputs.h_tx;
            h_rx = inputs.h_rx;
            f = inputs.f_GHz * 1e9;
            a_ef = R_earth*1000;
            X_tx = 2.2 * (f/1e9)^(1/3) * (a_ef)^(-2/3) * d*1000;
            X_rx = X_tx;
            Y_tx = 9.6e-3 * (f/1e9)^(2/3) * (a_ef)^(-1/3) * h_tx;
            Y_rx = 9.6e-3 * (f/1e9)^(2/3) * (a_ef)^(-1/3) * h_rx;
            C = X_tx + X_rx + Y_tx + Y_rx;
            if C < 1.6
                L_dif = 6.9 + 20*log10(sqrt((C-0.1)^2+1) + C - 0.1);
                region = 'Interferência';
            else
                L_dif = 20*log10(C) + 9.5;
                region = 'Difração';
            end
            texto = {
                'MODO: Difração / Troposfera (simplificado)'
                sprintf('C (parâmetro): %.3f', C)
                sprintf('Perda por difração L_dif: %.2f dB', L_dif)
                sprintf('Região estimada: %s', region)
                };
            % gráfico: plot simbólico de L_dif vs C
            dados_graf.x_plot = [C];
            dados_graf.y_plot = [L_dif];
        otherwise
            texto = {'Modo desconhecido'};
    end

end
