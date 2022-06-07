function NovintTest()
    s = serial('COM3');
    fopen(s);
    set(s,'BaudRate',9600);
    fprintf(s,'*IDN?');
    out = fscanf(s);
end