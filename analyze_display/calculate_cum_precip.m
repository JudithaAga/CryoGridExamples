years=1999:2011;

cum_precip=[];
for i=years
    cum_precip=[cum_precip; mean(FORCING.data.rainfall(find(FORCING.data.t_span>datenum(i,1,1) & FORCING.data.t_span<=datenum(i+1,1,1)))).*365];
end