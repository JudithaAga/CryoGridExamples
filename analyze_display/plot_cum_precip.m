year = 2011;

start_date= find(FORCING.data.t_span == datenum(year,1,1));



measurements= readmatrix(['H:\projects\coup\Nunataryuk\field_data_Julia\SaMet_Iv1\SaMet2002_' num2str(year) '_lv1_noflag.dat']);
measurements = measurements(:,13);
measurements(isnan(measurements)) = 0;
date=[datenum(year,1,1):1/48:datenum(year+1,1,1)-1/48]';



plot(date,cumsum(measurements))
datetick
hold on
first_non_zero = find(cumsum(measurements)>0, 1);
first_non_zero = find(FORCING.data.t_span>=date(first_non_zero),1);

normal = cumsum(FORCING.data.rainfall(start_date:start_date+1460.*2-10)./8) - sum(FORCING.data.rainfall(start_date:first_non_zero)./8) ;
plot(FORCING.data.t_span(start_date:start_date+1460.*2-10), normal)
 hold on
 plot(FORCING.data.t_span(start_date:start_date+1460.*2-10), cumsum(FORCING.data.rainfall(start_date:start_date+1460.*2-10)./8) )