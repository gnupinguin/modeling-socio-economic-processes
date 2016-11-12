clear all;
clc;

maxAge = 110;
l0 = 100000;
startYear = 1960;
lastYear = 2015;

%1      2
%age ratio
ratioFertility = importdata('CoefFertility.txt');%m_x
%correction data: some age duplicated (today, a person can be 13 if he was born 2003 or 2002)
for j = 1 : 1 : size(ratioFertility(1:end-1, 1))
    for k = j : 1 : size(ratioFertility(1:end-1, 1))
        if ratioFertility(k, 1) == ratioFertility(k + 1, 1)
            ratioFertility(k, 2) = (ratioFertility(k, 2) + ratioFertility(k+1, 2))*0.5;%midle value
            ratioFertility(k+1, :) = [];
            break;
        end
    end

end
%correction data: add zeros for small and large ages
ratioFertility = [...
    [0:ratioFertility(1,1)-1]', zeros(ratioFertility(1,1), 1);...
    ratioFertility;...
    [ratioFertility(end, 1)+1:maxAge]', zeros(maxAge - ratioFertility(end,1), 1)...
];
ratioFertility = ratioFertility(:,2);
    

%1      2     3    4
%age female male total
population = importdata('SpainPopulation.txt');%n_x
population = [population(:,2);population(:,3)];%0..n - female, n+1..2n+2 - male


%1      2
%age population
populationCohortFemaleMatrix = importdata('SpainPopulationCohortFemale.txt');%L_x_f
populationCohortMaleMatrix = importdata('SpainPopulationCohortMale.txt');%L_x_m



%delta
shareNewbornFemale = population(1) / (population(1) + population(maxAge+2));%sum(population(1:maxAge+1))/sum(population)
shareNewbornMale = 1 - shareNewbornFemale;


 P_f = populationCohortFemaleMatrix(2:end, 2) ./ populationCohortFemaleMatrix(1:end-1, 2);

 F_f = 0.5 * shareNewbornFemale * (ratioFertility(1:end-1) + P_f .* ratioFertility(2:end)) *...
 populationCohortFemaleMatrix(1, 2) / l0;
 L_f =diag(P_f, -1);
 L_f(1, 1:end-1) = F_f;

    %sprintf('Female: %f\n', sum(L_f * population(1:maxAge+1)));
    %dlmwrite('Leslie_female.txt', L_f, 'delimiter','\t');

    % FOR MALE

  P_m = populationCohortMaleMatrix(2:end, 2) ./ populationCohortMaleMatrix(1:end-1, 2);
  F_m = 0.5 * shareNewbornMale * (ratioFertility(1:end-1) + P_f.* ratioFertility(2:end)) *...
  populationCohortMaleMatrix(1, 2) / l0;

  L = [L_f, zeros(maxAge+1);zeros(maxAge+1), diag(P_f, -1)];
  L(maxAge + 1, 1:maxAge) = F_m;
    
for year = startYear:1:lastYear
    population = L*population;
    population(1) = population(1) + sum(population(1:maxAge+1) .* ratioFertility);
    sprintf('Population %d: %f\n',year, sum(population))
end
%for example:
% 1977 г. — 36,3 млн чел.;
% 2009 г. — 45,9 млн чел.;
% 2011 г. — 46,7 млн чел.;
% 2013 г. — 46,7 млн чел.[10];
% 2014 г. — 46,5 млн чел.;
% 2015 г. — 46,4 млн чел.[10].




