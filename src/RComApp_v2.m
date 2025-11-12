function RComApp_v2()
% RComApp_v2  - Interface separada do main (salvar como RComApp_v2.m)
% Corre: RComApp_v2

    % --- Criar janela (uifigure) ---
    app.UIFigure = uifigure('Name','RCom - Interface','Position',[100 100 1100 720]);

    % --- Painéis ---
    app.DadosPanel = uipanel(app.UIFigure,'Title','DADOS','FontWeight','bold', ...
        'Position',[20 20 300 680]);
    app.GraficoPanel = uipanel(app.UIFigure,'Title','GRÁFICO','FontWeight','bold', ...
        'Position',[340 220 740 480]);
    app.InfoPanel = uipanel(app.UIFigure,'Title','INFORMAÇÕES','FontWeight','bold', ...
        'Position',[340 20 480 180]);
    app.ButtonsPanel = uipanel(app.UIFigure,'Title','OUTROS GRÁFICOS','FontWeight','bold', ...
        'Position',[840 20 240 180]);

    % --- UIAxes ---
    app.UIAxes = uiaxes(app.GraficoPanel,'Position',[20 20 700 420]);
    title(app.UIAxes,'Perfil da Ligação');
    xlabel(app.UIAxes,'Distância (km)');
    ylabel(app.UIAxes,'Altura (m)');
    grid(app.UIAxes,'on');

    % --- Info text area ---
    app.InfoText = uitextarea(app.InfoPanel,'Position',[10 10 460 140], ...
        'Editable','off','FontName','Courier New');

    % --- Campos no painel DADOS ---
    left = 15; top = 620; wlabel = 130; wedit = 120; h = 22; spacing = 8;
    % Distância (km)
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Distância (km):','HorizontalAlignment','right');
    app.DistanciaEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',45);
    top = top - (h + spacing);
    % Altura TX (m)
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Altura TX (m):','HorizontalAlignment','right');
    app.HTxEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',40);
    top = top - (h + spacing);
    % Altura RX (m)
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Altura RX (m):','HorizontalAlignment','right');
    app.HRxEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',150);
    top = top - (h + spacing);
    % Frequência (GHz)
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Frequência (GHz):','HorizontalAlignment','right');
    app.FreqEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',6);
    top = top - (h + spacing);
    % Potência TX (W)
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Potência TX (W):','HorizontalAlignment','right');
    app.PtxEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',10);
    top = top - (h + spacing);
    % Diâmetros
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Diâmetro TX (m):','HorizontalAlignment','right');
    app.DtxEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',2.4);
    top = top - (h + spacing);
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Diâmetro RX (m):','HorizontalAlignment','right');
    app.DrxEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',1.8);
    top = top - (h + spacing);
    % Rendimento (%)
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Rendimento (%):','HorizontalAlignment','right');
    app.EtaEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',65);
    top = top - (h + spacing);
    % Comp. guia TX
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Comp. Guia TX (m):','HorizontalAlignment','right');
    app.CompGuiaTxEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',15);
    top = top - (h + spacing);
    % Comp. guia RX
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Comp. Guia RX (m):','HorizontalAlignment','right');
    app.CompGuiaRxEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',12);
    top = top - (h + spacing);
    % Atenuação guia (dB/m)
    uilabel(app.DadosPanel,'Position',[left top wlabel h],'Text','Aten. Guia (dB/m):','HorizontalAlignment','right');
    app.AtenGuiaEdit = uieditfield(app.DadosPanel,'numeric','Position',[left+wlabel+10 top wedit h],'Value',0.1);
    top = top - (h + spacing + 10);

    % --- Botão CALCULAR (faz Fresnel por defeito) ---
    app.CalcButton = uibutton(app.DadosPanel,'push','Text','CALCULAR (Raio/Fresnel)', ...
        'Position',[20 20 260 36],'ButtonPushedFcn',@(btn,event) onButton(app,'fresnel'));

    % --- Botões no painel ButtonsPanel (outros cálculos) ---
    yb = 120; bw = 200; bh = 32; bx = 20;
    app.BtnAntenas = uibutton(app.ButtonsPanel,'push','Text','Antenas', ...
        'Position',[bx yb bw bh],'ButtonPushedFcn',@(btn,event) onButton(app,'antenas'));
    app.BtnGuias = uibutton(app.ButtonsPanel,'push','Text','Guias', ...
        'Position',[bx yb-44 bw bh],'ButtonPushedFcn',@(btn,event) onButton(app,'guias'));
    app.BtnEspaco = uibutton(app.ButtonsPanel,'push','Text','Atenuação Espaço Livre', ...
        'Position',[bx yb-88 bw bh],'ButtonPushedFcn',@(btn,event) onButton(app,'espaco'));
    app.BtnDif = uibutton(app.ButtonsPanel,'push','Text','Difração/Troposfera', ...
        'Position',[bx yb-132 bw bh],'ButtonPushedFcn',@(btn,event) onButton(app,'difracao'));

    % --- Store app in guidata-like (for callbacks) ---
    guidata(app.UIFigure, app);

    % --- Nested callback reads guidata ---
    function onButton(appHandle, modo)
        % Recupera handle
        appLocal = guidata(appHandle.UIFigure);

        % Lê inputs do painel DADOS
        inputs.dist_km = appLocal.DistanciaEdit.Value;
        inputs.h_tx = appLocal.HTxEdit.Value;
        inputs.h_rx = appLocal.HRxEdit.Value;
        inputs.f_GHz = appLocal.FreqEdit.Value;
        inputs.P_tx = appLocal.PtxEdit.Value;
        inputs.diametro_tx = appLocal.DtxEdit.Value;
        inputs.diametro_rx = appLocal.DrxEdit.Value;
        inputs.eta_percent = appLocal.EtaEdit.Value;
        inputs.comprimento_guia_tx = appLocal.CompGuiaTxEdit.Value;
        inputs.comprimento_guia_rx = appLocal.CompGuiaRxEdit.Value;
        inputs.atenuacao_guia = appLocal.AtenGuiaEdit.Value;

        % Chama o main (calcular_RCom) - que deve existir na mesma pasta
        if exist('calcular_RCom','file') ~= 2
            appLocal.InfoText.Value = {'Erro: calcular_RCom.m não encontrado na pasta.'};
            return;
        end

        try
            [texto, dados_graf] = calcular_RCom(inputs, modo);
        catch ME
            appLocal.InfoText.Value = {['Erro ao executar calcular_RCom: ' ME.message]};
            return;
        end

        % --- Atualiza o gráfico ---
        cla(appLocal.UIAxes);
        if isfield(dados_graf,'x_km') && isfield(dados_graf,'y_terra')
            plot(appLocal.UIAxes, dados_graf.x_km, dados_graf.y_terra, 'k', 'LineWidth', 1.5); hold(appLocal.UIAxes,'on');
        end
        if isfield(dados_graf,'y_raio')
            plot(appLocal.UIAxes, dados_graf.x_km, dados_graf.y_raio, 'r', 'LineWidth', 2);
        end
        if isfield(dados_graf,'y_fresnel_sup') && isfield(dados_graf,'y_fresnel_inf')
            plot(appLocal.UIAxes, dados_graf.x_km, dados_graf.y_fresnel_sup, 'b--');
            plot(appLocal.UIAxes, dados_graf.x_km, dados_graf.y_fresnel_inf, 'b--');
            fill(appLocal.UIAxes, [dados_graf.x_km, fliplr(dados_graf.x_km)], ...
                [dados_graf.y_fresnel_sup, fliplr(dados_graf.y_fresnel_inf)], ...
                'b', 'FaceAlpha', 0.08,'EdgeColor','none');
        end
        if isfield(dados_graf,'x_plot') && isfield(dados_graf,'y_plot')
            plot(appLocal.UIAxes, dados_graf.x_plot, dados_graf.y_plot, 'LineWidth', 1.8);
        end
        hold(appLocal.UIAxes,'off');
        grid(appLocal.UIAxes,'on');
        xlabel(appLocal.UIAxes,'Distância (km)');
        ylabel(appLocal.UIAxes,'Altura (m)');

        % --- Atualiza o painel INFORMAÇÕES ---
        if iscell(texto)
            appLocal.InfoText.Value = texto;
        else
            appLocal.InfoText.Value = {texto};
        end

        % Guarda app
        guidata(appLocal.UIFigure, appLocal);
    end

end
