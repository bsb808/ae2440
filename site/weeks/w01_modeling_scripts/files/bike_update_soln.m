%[text] # Bike Update
%[text] PMM Exercise 2.2: update the number of bikes at the Monterey (`m`) and Pacific Grove (`pg`) locations from one day to the next. Each day 5% of the bikes in Monterey are dropped off in Pacific Grove, and 3% of the bikes in Pacific Grove are dropped off in Monterey.
%[text] Precondition: `m` and `pg` contain the number of bikes at each location.
%[text] Postcondition: the values of `m` and `pg` are updated.
%[text] To test, initialize the bikes at the prompt (`m = 100; pg = 100;`) and run the script repeatedly. The first run gives `m = 98`, `pg = 102`.
% Net number of bikes moving from Monterey to Pacific Grove; round so bikes stay whole
m_to_pg = round(0.05*m) - round(0.03*pg);

% Omit the semicolon so that the updated values are displayed
m = m - m_to_pg
pg = pg + m_to_pg

%[text] 
%[text] Add plotting for Week 02:
figure(1);
hold on;
plot(ii,m, 'rs')
plot(ii,pg,'bo')
ii = ii +1;

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
