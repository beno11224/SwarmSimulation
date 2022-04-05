clear;
close all;

timeStep = 0.000001;
maxTime = 3;
recordEvery = maxTime / 30000;
individualParticleDiameter = 800 * 10^-9;
DEQParticleDiameter = 5.6 *10^-6;
ParticleLocation = 0;

%req = 125; %radius equivalent (like Deq, but for radius not diameter)
%req = ((3 .* req).^(1/3) .* individualParticleDiameter ) / 2;
req = (5.6*10^-6)/2;  %req';

%Magnetic Force Values
ParticleVolume = 4/3 .* pi .* (req).^3;
muOne = 4 * pi * 10^-7;
%Msat = 58 * 12.566 * 10^4 %4pi*10^4
%Msat = 58 * 795774.71545947673925;%58 * 2.25 * 10^3 %* 1/(12.566 * 10^-7) / 2.250
Msat = 58  * 2250 * 4* pi * 10^-3
DeltaHf = [0.45, 0.5, 0.75, 1, 1.5, 2, 2.25] .* 10^6;

ExperimentalData = [2, 1.5, 0.8, 0.65, 0.5, 0.35, 0.25];
distanceToTravel = 0.001;

%Drag Force Values
EtaViscocity = 0.004;
ParticleDiameter = req .* 2;
VelocityParticle = 0; %Can try seeding this here.
VelocityFlow = 0;

ParticleMass = 2250 * ParticleVolume;

plotLocations = 0;
plotVelocities = 0;
plotTimes = 0;
plotEndTimes = DeltaHf .* 0;
plotEndVelocities = DeltaHf .* 0;

for timeIncrementer = 0:timeStep:maxTime
    %F = Fmf - Fdrag
    Fmf = ParticleVolume .* muOne .* Msat .* DeltaHf .* 1750; %I'm settling on something like 1750 is the correct number
    Fdrag = -3 .* pi .* EtaViscocity .* ParticleDiameter .* (VelocityParticle - VelocityFlow);
    
    %A = F/M
    ParticleAcceleration = (Fmf + Fdrag) ./ ParticleMass;
    %v = u + at
    VelocityParticle = VelocityParticle + ParticleAcceleration .* timeStep;
    
         %   Fdrag(1)
         %   VelocityParticle(1)
    
    %s = ut + 1/2 at^2
    ParticleLocation = ParticleLocation + VelocityParticle .* timeStep + 0.5 .* ParticleAcceleration .* timeStep .^ 2;
    if(mod(timeIncrementer,recordEvery) == 0)
        plotLocations(length(plotLocations) + 1) = ParticleLocation(1,1);
        plotVelocities(length(plotVelocities) + 1) = VelocityParticle(1,1);
        plotTimes(length(plotTimes) + 1) = timeIncrementer;
    end
    plotEndTimes = timeIncrementer .* (ParticleLocation >= distanceToTravel) .* (plotEndTimes <= 0) + plotEndTimes;
    plotEndVelocities = VelocityParticle .* (ParticleLocation >= distanceToTravel) .* (plotEndVelocities <= 0) + plotEndVelocities;
end
hold;
figure
plot(plotTimes,plotLocations);
title('Location over time (1st Particle)')
hold;
figure
plot(plotTimes,plotVelocities);
title('Velocity over time (1st particle)')
hold;
figure
plot(DeltaHf./ 10^6,plotEndVelocities, '.-', 'markersize', 10);
hold;
%Comment this out to only see the simulation data on the graph.
plot(DeltaHf./ 10^6, distanceToTravel ./ ExperimentalData, '.-red', 'markersize', 10);
title('velocity at 1mm')
hold;
figure
plot(DeltaHf./ 10^6,plotEndTimes, '.-', 'markersize', 10);
hold;
%Comment this out to only see the simulation data on the graph.
plot(DeltaHf./ 10^6, ExperimentalData, '.-red', 'markersize', 10);
title('time at 1mm')