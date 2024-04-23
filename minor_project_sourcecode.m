function PlantStatus= minor_project_sourcecode
DrySoil=3.3000;
WetSoil=2.7000;
a=arduino('COM3','Uno');

figure(1)
g=animatedline;
ax=gca;
ax.YGrid= 'on';
ax.YLim=[0 5];
title('Plants Moisture Level vs Time (live)');
xlabel('Time [HH:MM:SS]');
ylabel('Plants Moisture Level [Volts]');
startTime=datetime('now');


cancel= false;
while ~cancel
    cancel=readDigitalPin(a,'D6');
    Volts=readVoltage(a,'A1');
    time=datetime('now') - startTime;
    addpoints(g,datenum(time), Volts);
    ax.XLim=datenum([time-seconds(15) time]);
    datetick('x','keeplimits')
    drawnow

if readVoltage(a,'A1')>DrySoil
    writeDigitalPin(a,"D2",1);pause(0.5);writeDigitalPin(a,'D2',0)
    PlantStatus= 'Soil is Dry, Time to Water';
    disp(PlantStatus)
 
elseif readVoltage(a,'A1')<DrySoil && readVoltage(a,'A1')>WetSoil
     writeDigitalPin(a,"D2",1);pause(0.5);writeDigitalPin(a,'D2',0)
     PlantStatus= 'Soil is Wet, but I am still Thirsty';
    disp(PlantStatus)
     
elseif readVoltage(a,'A1')<WetSoil 
    writeDigitalPin(a,'D2',0)
    PlantStatus= 'Soil is Wet, I am Full';
    disp(PlantStatus)
    
else 
    writeDigitalPin(a,'D2',0)
    PlantStatus= 'ERROR';
    disp(PlantStatus)
  
end
end
