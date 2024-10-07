% Update the state of the bike system.
% Preconditon: m and pg contains the number of bikes.
% Postconditon: values of m and pg are updated.

m_to_pg = round(0.05*m) - round(0.03*pg);
%m_to_pg = 0.05*m - 0.03*pg;

m = m - m_to_pg;
pg = pg + m_to_pg;


