%% 2D Plotting Demonstration: Stress-Strain Curves
% Stress-strain data for carbon steel
% Strain [mm/mm]
strain_exp = [0, 500/210000, 0.003749347, 0.005234888, ...
    0.007631515, 0.011446096, 0.017384888, ...
    0.026405375, 0.039775799];
% Stress [MPa]
stress_exp = [0, 500, 550, 600, 660, 720, 780, 840, 900];

% Ramberg-Osgood fit of the experimental data.

E = 210000;   % MPa
K = 1480;    % MPa
n = 6.71;
stress_fit = linspace(0, stress_exp(end), 100);
strain_fit = stress_fit/E + (stress_fit/K).^n;

%% Plot: Line and markers with legend.
figure(1);
clf();
plot(strain_fit, stress_fit, 'r-');
hold on
plot(strain_exp, stress_exp, 'bo')

xlabel('strain [mm/mm]');
ylabel('stress [MPa]')
axis([-0.002, 0.041, -50, 950])
legend('Ramberg-Osgood fit', 'Measured data')
grid('on')

%% Plot: Using 'Property', 'Value' syntax
% Use DisplayName for legend and locate the legend
% Set linewidth and line type and markerface color
figure(2);
clf();
plot(strain_fit, stress_fit, 'r-', 'LineWidth', 2, ...
    'DisplayName', "Ramberg-Osgood fit");
hold on
plot(strain_exp, stress_exp, 'bo--', 'MarkerFaceColor', [0 0 1], ...
    'DisplayName', "Measured data");

xlabel('strain [mm/mm]');
ylabel('stress [MPa]')
axis([-0.002, 0.041, -50, 950])
legend('Location','northwest')
grid('on')

%% Plot: Use properties of the line object
figure(3);
clf();
p_fit = plot(strain_fit, stress_fit);
p_fit.Color = 'r';
p_fit.LineWidth = 2;
p_fit.DisplayName = 'Ramberg-Osgood fit';

hold on
p_data = plot(strain_exp, stress_exp, 'bo--', 'MarkerFaceColor', [0 0 1], ...
    'DisplayName', "Measured data");
set(p_data, 'MarkerSize', 10, 'MarkerEdgeColor', 'k');

xlabel('strain [mm/mm]');
ylabel('stress [MPa]')
axis([-0.002, 0.041, -50, 950])
legend('Location','northwest')
grid('on')


%% 
% Reference: 
% https://www.quadco.engineering/en/know-how/fea-ramberg-osgood-equation.htm>
