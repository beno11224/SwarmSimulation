function JoystickTest()
    joy = vrjoystick(1);
    i = 0;
    while i < 1000
        i = i + 1
        lefth = axis(joy,1)
        leftv = axis(joy,2)
        trigg = axis(joy,3)
        righth = axis(joy,4)
        rightv = axis(joy,5)
        pause(0.5);
    end
end