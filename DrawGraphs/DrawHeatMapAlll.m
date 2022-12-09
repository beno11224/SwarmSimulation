if(~exist("aaa01"))
    aaa01 = ReadAllResults()
    aaa015 = ReadAllResults()
    aaa02 = ReadAllResults()
    aaa025 = ReadAllResults()
    aaa03 = ReadAllResults()
end

if(0)
%if(1)
    DrawHeatMapFromParticlePath(aaa01,1,1,0,0)
    DrawHeatMapFromParticlePath(aaa015,1,1,0,0)
    DrawHeatMapFromParticlePath(aaa02,1,1,0,0)
    DrawHeatMapFromParticlePath(aaa025,1,1,0,0)
    DrawHeatMapFromParticlePath(aaa03,1,1,0,0)
end

if(0)
%if(1)
    DrawInputAngle(aaa01,1,1,0,0)
    DrawInputAngle(aaa015,1,1,0,0)
    DrawInputAngle(aaa02,1,1,0,0)
    DrawInputAngle(aaa025,1,1,0,0)
    DrawInputAngle(aaa03,1,1,0,0)
end

if(1)
    DrawMeanParticlePath(aaa01,0,1,0,0);
    DrawMeanParticlePath(aaa015,0,1,0,0);
    DrawMeanParticlePath(aaa02,0,1,0,0);
    DrawMeanParticlePath(aaa025,0,1,0,0);
    DrawMeanParticlePath(aaa03,0,1,0,0);
end

