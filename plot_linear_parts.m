%% Lyapunov Exponent Calculator (Raw Data)

%Hyper-parameters
fs = 250; % sampling freq
% Chaotic Threshold 
% (num of points taken into the phase space for LLE calculation)

N_sub = 56; %Num of participants

count = zeros(N_sub,1);
for s = 1:N_sub
	load("path to subject's data") % chan*time_pnts*trials

    Data = mean(S_prep,3); % chan*time_pnts (avg over trials)

    h = waitbar(0,['Subject ',num2str(s)]);

    LE = [];
    for elec = 1:30 %assuming 30 EEG channels
        figure(s);
        subplot(3,10,elec)
        [~,emb,lag] = phaseSpaceReconstruction(Data(elec,:));
        np = size(Data(elec,:),2) - (emb-1)*lag;
        [~, ~, d] = lyapunovExponent(Data(elec,:), fs, lag, emb, 'ExpansionRange', [1 ceil(np/2)]);
        [Kmin, Kmax, color, lyaexp] = polyfit_linear_section(d);
        if color ~= 'r'
            LE(elec,1) = lyaexp;
        else
            count(s) = count(s) + 1;
            LE(elec,1) = NaN;
        end
        set(subplot(3,10,elec),'Color',color)
        title(['Elec ',num2str(elec)])
        waitbar(elec/30);
    end
    close(h);
    LLE(s,:) = LE';
    disp(['S',num2str(s),': ',num2str(count(s))])
 end

 %LLE array contains the LLE of each subject (rows) at each electrode (columns).