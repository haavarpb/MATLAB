%% Classify
clc
clear all
close all

load dataSetWithFeatures

%% Format data and labels for SVM

fieldCell = fields(dataSet);
labelCell = fieldCell(1:2, 1);

b = dataSet.bricks;
c = dataSet.concrete;

X = [b(1).Sd;
     b(2).Sd;
     b(3).Sd;
     b(4).Sd;
     b(5).Sd;
     c(1).Sd;
     c(2).Sd;
     c(3).Sd;
     c(4).Sd];
 
Y = {labelCell{1};
    labelCell{1};
    labelCell{1};
    labelCell{1};
    labelCell{1};
    labelCell{2};
    labelCell{2};
    labelCell{2};
    labelCell{2}};

%% Train SVM 

SVMModel = fitcsvm(X, Y);

sv = SVMModel.SupportVectors;
figure
gscatter(X(:,1),X(:,2),Y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('bricks','concrete','Support Vector')
hold off

%% Predict 

bv = dataSet.bricksValidation;
cv = dataSet.concreteValidation;

Xtest = [bv(1).Sd;
    bv(2).Sd;
    cv(1).Sd;
    cv(2).Sd;
    cv(3).Sd];

Ytest = {labelCell{1};
    labelCell{1};
    labelCell{2};
    labelCell{2};
    labelCell{2}};

[label, score] = predict(SVMModel, Xtest);

table(Ytest(:),label(:),score(:,2),'VariableNames',...
    {'TrueLabel','PredictedLabel','Score'})
