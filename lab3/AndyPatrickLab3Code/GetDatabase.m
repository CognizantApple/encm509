
function [AuthSigs,ForgSigs,MeanAuth,MeanForg] = GetDatabase()
    %Load Signatures
    AuthSigs            = load("AndyAuthSig.mat");
    AuthSigs            = struct2array(AuthSigs);

    ForgSigs        = load("AndyForgSig.mat");
    ForgSigs        = struct2array(ForgSigs);

    %Replace time with velocity.
    AuthSigs = GetVelocity(AuthSigs);
    ForgSigs = GetVelocity(ForgSigs);

    %Calculate Mean values from data
    MeanAuth    = GetMeanValues(AuthSigs);
    MeanForg    = GetMeanValues(ForgSigs);
end

function [VelocitySignatures] = GetVelocity(TimeSignatures)
    % Prepare a velocity return value.
    VelocitySignatures = TimeSignatures;

    SingatureCount = length(TimeSignatures);

    % Iterate over signatures and calculate velocity
    for i = 1 : SingatureCount
        SignatureIn = TimeSignatures(i);
        SignatureIn = SignatureIn{1};
        DataCount = length(SignatureIn(1, :));

        XVel        = zeros(1, DataCount - 1);
        YVel        = zeros(1, DataCount - 1);
        Velocity    = zeros(1, DataCount - 1);

        X = SignatureIn(1, :);
        Y = SignatureIn(2, :);
        Time = SignatureIn(4, :);
        for j = 2 : DataCount
            dX = X(j) - X(j - 1);
            dY = Y(j) - Y(j - 1);
            dT = Time(j) - Time(j - 1);

            XVel(j - 1, 1) = dX / dT;
            YVel(j - 1, 2) = dY / dT;
            Velocity(j - 1) = sqrt(dX * dX + dY * dY);
        end
        %Trim last element of velocity since we can only calculate
        %DataCount - 1 velocities.
        VelocitySignatures{i} = VelocitySignatures{i}(:,1:end-1);
        VelocitySignatures{i}(4,:) = Velocity;
    end
end

function [MeanValues] = GetMeanValues(Signatures)
    %Prepare a return value, col 1 is pressure, col 2 is velocity
    SignatureCount = length(Signatures);
    MeanValues = zeros(SignatureCount,2);

    for i = 1 : SignatureCount
        MeanValues(i,1) = mean(Signatures{i}(3,:));
        MeanValues(i,2) = mean(Signatures{i}(4,:));
    end
end

