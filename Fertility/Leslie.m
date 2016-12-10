clear all;
clc;

maxAge = 110;
l0 = 100000;
startYear = 1961;
lastYear = 1974;

%1      2
%age ratio
ratioFertility = importdata('CoefFertility.txt');%m_x
%correction data: some age duplicated (today, a person can be 13 if he was born 2003 or 2002)

j = 1;
while j <= length(ratioFertility(1:end-1, 1))
    k = j;
    while k < length(ratioFertility(1:end-1, 1))
        if ratioFertility(k, 1) == ratioFertility(k + 1, 1)
            ratioFertility(k, 2) = (ratioFertility(k, 2) + ratioFertility(k+1, 2))*0.5;%midle value
            ratioFertility(k+1, :) = [];
            break;
        end
        k = k + 1;
    end
    j = j+1;
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
populationCohortFemale = populationCohortFemaleMatrix(:,2);
populationCohortMaleMatrix = importdata('SpainPopulationCohortMale.txt');%L_x_m
populationCohortMale = populationCohortMaleMatrix(:,2);



%delta
shareNewbornFemale = population(1) / (population(1) + population(maxAge+2));%sum(population(1:maxAge+1))/sum(population)
shareNewbornMale = 1 - shareNewbornFemale;


 P_f = populationCohortFemale(2:end) ./ populationCohortFemale(1:end-1);

 F_f = 0.5 * shareNewbornFemale * (ratioFertility(1:end-1) + P_f .* ratioFertility(2:end)) *...
 populationCohortFemale(1) / l0;
 L_f =diag(P_f, -1);
 L_f(1, 1:end-1) = F_f;

    %sprintf('Female: %f\n', sum(L_f * population(1:maxAge+1)));
    %dlmwrite('Leslie_female.txt', L_f, 'delimiter','\t');

    % FOR MALE

  P_m = populationCohortMale(2:end) ./ populationCohortMale(1:end-1);
  F_m = 0.5 * shareNewbornMale * (ratioFertility(1:end-1) + P_m.* ratioFertility(2:end)) *...
  populationCohortMale(1) / l0;

  L = [L_f, zeros(maxAge+1);zeros(maxAge+1), diag(P_f, -1)];
  L(maxAge + 2, 1:maxAge) = F_m;
  
myTotalPop = [];
myFemalePop = [];
myMalePop = [];
for year = startYear:1:lastYear
    population = L*population;
    myTotalPop = vertcat(myTotalPop, [year, sum(population)]);
    myFemalePop = vertcat(myFemalePop, [year, sum(population(1 : maxAge+1))]);
    myMalePop = vertcat(myMalePop, [year, sum(population(maxAge+2 : end))]);
    sprintf('Population %d: %f\n',year, sum(population))
end

etalonTotalPopulation = importdata('totalPopulation.txt');
myTotalPop = vertcat(etalonTotalPopulation(1,:),myTotalPop);

%draw total population size
figure
plot(etalonTotalPopulation(:,1), etalonTotalPopulation(:,2), 'r*-', myTotalPop(:,1), myTotalPop(:,2), 'g*-')
title('Population comparisons')
xlabel('year')
ylabel('population')
grid on


etalonFemalePopulation = importdata('totalFemalePopulation.txt');
myFemalePop = vertcat(etalonFemalePopulation(1,:),myFemalePop);
%draw female population
figure
plot(etalonFemalePopulation(:,1), etalonFemalePopulation(:,2), 'r*-', myFemalePop(:,1), myFemalePop(:,2), 'g*-')
title('Female population comparisons')
xlabel('year')
ylabel('population')

etalonMalePopulation = importdata('totalMalePopulation.txt');
myMalePop = vertcat(etalonMalePopulation(1,:),myMalePop);
%draw male population
figure
plot(etalonMalePopulation(:,1), etalonMalePopulation(:,2), 'r*-', myMalePop(:,1), myMalePop(:,2), 'g*-')
title('Male population comparisons')
xlabel('year')
ylabel('population')








