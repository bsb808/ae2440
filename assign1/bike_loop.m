
m = 100;
pg = 100;
day = 1;
mm = [];
ppg = [];
for ii = 1:60
    mm(ii) = m;
    ppg(ii) = pg;
    bike_share
end

figure(1)
clf()
plot(mm, 'bo-', 'DisplayName', 'Monterey')
hold on
plot(ppg, 'rs:', 'DisplayName', 'Pacific Grove')
grid('on')
legend('Location','northwest')
xlabel('Time steps [days]')
ylabel('Inventory in town [bikes]')

