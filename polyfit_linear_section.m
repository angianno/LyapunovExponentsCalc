function [lin_start, lin_end, color, LE] = polyfit_linear_section(d)
    color = 'w';
    LEN = length(d);
    start = floor((1/5)*LEN);
    finish = floor((9/10)*LEN);
    l_start = floor((1/5)*LEN);
    l_finish = floor((3/5)*LEN);
    g_threshold = 0.7;
    fs = 250;
    
    gf = zeros(finish-start, l_finish-l_start);

    row = 1;
    for i = start:finish % loop over points
        column = 1;
        for len = l_start:l_finish % loop over window lengths
            j = i + len;
            if j > LEN
                break;
            end
            tlinear = i:j;
            L = polyfit(tlinear',d(tlinear),1);
            lle = L(1)*fs;
            y = L(1)*tlinear + L(2);
            if L(1) > 0 
                gf(row,column) = goodnessOfFit(d(tlinear),y','nrmse');
            end

            column = column + 1;
        end
        row = row + 1;
    end

    gf(gf<g_threshold) = 0;
    maximum = max(max(gf));
    
    LE = nan;
    if maximum == 0
        color = 'r';
        plot(1:length(d), d);
        lin_start = 0;
        lin_end = 0;
    else
        [x,y] = find(gf==maximum);

        all_start = start:finish;
        all_end = l_start:l_finish;

        lin_start = all_start(x);
        lin_end = lin_start + all_end(y);

        tlinear = lin_start:lin_end;
        L = polyfit(tlinear',d(tlinear),1);
        lle = L(1)*fs;
        y = L(1)*tlinear + L(2);
        
        LE = L(1);
        plot(1:length(d), d);
        hold on; plot(lin_start:lin_end,y,'linewidth',2,'color','k')
    end
end