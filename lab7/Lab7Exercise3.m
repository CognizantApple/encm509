% Just hardcode the numbers of frames:
FrameEndJRA1   = 70;
FrameStartJRA1 = 33;
FrameEndJRA2   = 51;
FrameStartJRA2 = 11;
FrameEndJRD1   = 65;
FrameStartJRD1 = 28;

CadenceJRA1 = CalculateCadence(FrameEndJRA1, FrameStartJRA1);
CadenceJRA2 = CalculateCadence(FrameEndJRA2, FrameStartJRA2);
CadenceJRD1 = CalculateCadence(FrameEndJRD1, FrameStartJRD1);

Cadences = [CadenceJRA1 CadenceJRA2 CadenceJRD1];

MeanCadence = mean(Cadences);
StdCadence  = std(Cadences);

function [Cadence] = CalculateCadence(EndFrame, StartFrame)
    Frames = EndFrame - StartFrame;
    % Calculate the cadence, assuming 30 frames per second:
    Cadence = ( 2 / Frames ) * 30 * 60;
end