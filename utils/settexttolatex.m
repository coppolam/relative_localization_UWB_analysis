ha = get(handle,'children');

ha_legend = findobj('Tag','legend');
set(ha_legend,'Interpreter','Latex');

ha_text = findobj(handle,'Type','text');
set(ha_text,'Interpreter','Latex');

ha_axes = get(handle,'CurrentAxes');
set(ha, 'defaulttextinterpreter', 'latex');
set(ha_axes, 'TickLabelInterpreter', 'latex');