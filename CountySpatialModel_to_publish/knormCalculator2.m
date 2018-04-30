% Calculates knorm to hit final size nicely 
function knorm = knormCalculator2(modelCases,dataCases,startCases,knorm)
for i = 1:63
    if dataCases(i) == 0
        dataCases(i) = 0.5;
    end
end
for j = 1:63
    if startCases(j) == 0
        knorm(j) = knorm(j) * dataCases(j) / modelCases(j);
    end
end

end

