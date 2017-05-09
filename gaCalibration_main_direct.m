% GA param calibration main
% clear;clc;
%% ============= 1. Connect to COM ===================
% var declaration
global Vissim
global db
global dcm
global wdb
global zhongqun
zhongqun = 1;
global lk
global isConnector
    global TRAVELTIME
    global DELAY
    global QUEUEMAX 
    global QUEUEMEAN
    global CAPACITY
    global capacityreal
    global traveltimereal
    global delayreal
    global maxQreal 
    global MEANQreal    
global pathname
global filename
global paracalibtag
global TARGET
global db_def_index
global tag
global indectorweighte
paracalibtag=importdata('paracalibtag.mat')
TARGET=importdata('TARGET.mat')

    path = [pathname  filename];   
    Vissim = actxserver('VISSIM.Vissim-64.900'); % Start Vissim
    Vissim.LoadNet(path);

% Read Link Name   �ж�·�����ԣ����е�·���Ǹ��ٹ�·�����г��������е��ȡ� 
% Connector route
lk = Vissim.net.Links.GetAll;
isConnector = []; link_attribute=[];
for iLk = 1:size(lk,1)%�жϸ�·���Ƿ�Ϊ������������������п��ܻ�ı��䡰�������롱��һ����
    if lk{iLk}.AttValue('IsConn')
        isConnector = [isConnector,iLk];
    else
    link_attribute = [link_attribute, Vissim.net.Links.ItemByKey(lk{iLk}.AttValue('No')).AttValue('LinkBehavType'),iLk];
    end
end

% DRIVING BEHAVIOR
db = Vissim.net.DrivingBehaviors.GetAll;
db_def_index = str2num(get(Vissim.Net.Links.ItemByKey(1), 'AttValue', 'LinkBehavType'));
sprintf('db_def_index=%d\n',db_def_index)
%db_def_indexΪ1-6�����֣�
% 1��Urban(motorized)��Ҫ����Wiedman74ģ�ͣ�4������({'W74AX'},{'W74BXADD'},{'W74BXMULT'},{'LOOKBACKDISTMAX'})+lane change 5������
% 2: right-side rule(motorized)��Ҫ����Wiedman99ģ�ͣ�5������cc0 cc1 cc2 cc4 cc5��cc4=-cc5��+ lane change 5������
% 3: freeway(free lane selection)��Ҫ����Wiedman99ģ�ͣ�5������cc0 cc1 cc2 cc4 cc5��cc4=-cc5��+ lane change 5������
% 4: footpath(no interaction)   ��һ�汾�ĳ����ݲ��漰�����·��ʻ��Ϊģ�Ͳ����ı궨   
% 5: cycle-track(free overtaking)   ��һ�汾�ĳ����ݲ��漰�����·��ʻ��Ϊģ�Ͳ����ı궨                                                     
% Get  driving behavior object
wdb = db{db_def_index};%��·����Wiedeman99/74,�ͻ���������
%Wiedeman 99
cc0 = wdb.AttValue('W99cc0');
cc1 = wdb.AttValue('W99cc1Distr');
cc2 = wdb.AttValue('W99cc2');
cc4 = wdb.AttValue('W99cc4');
cc5 = wdb.AttValue('W99cc5');
minD = wdb.AttValue('AccDecelTrail');
safe = wdb.AttValue('SafDistFactLnChg');
maxCD = wdb.AttValue('CoopDecel');
maxSD = wdb.AttValue('CoopLnChgSpeedDiff');
lcDist = lk{isConnector(1)}.AttValue('LnChgDist');
%Wiedeman 74
W74ax = wdb.AttValue('W74ax');
W74bxAdd = wdb.AttValue('W74bxAdd');
W74bxMult = wdb.AttValue('W74bxMult');
LookBackDistMax = wdb.AttValue('LookBackDistMax');
LookAheadDistMax = wdb.AttValue('LookAheadDistMax');
StandDist = wdb.AttValue('StandDist');
ObsrvdVehs = wdb.AttValue('ObsrvdVehs');
maxCD = wdb.AttValue('CoopDecel');
maxSD = wdb.AttValue('CoopLnChgSpeedDiff');
lcDist = lk{isConnector(1)}.AttValue('LnChgDist');
%lane change
DecelRedDistOwn = wdb.AttValue('W74bxAdd');
AccDecelOwn = wdb.AttValue('AccDecelOwn');
DiffusTm = wdb.AttValue('DiffusTm');
MinHdwy = wdb.AttValue('MinHdwy');
SafDistFactLnChg = wdb.AttValue('SafDistFactLnChg');
CoopDecel = wdb.AttValue('CoopDecel');
VehRoutDecLookAhead = wdb.AttValue('VehRoutDecLookAhead');
CoopLnChgSpeedDiff = wdb.AttValue('CoopLnChgSpeedDiff');

% End_of_simulation = 600; % simulation second [s]
% set(Vissim.Simulation, 'AttValue', 'SimPeriod', End_of_simulation);

% Set maximum speed:
set(Vissim.Simulation, 'AttValue', 'UseMaxSimSpeed', true);
% Vissim.Simulation.RunContinuous;

% travel time
if TRAVELTIME==1
Veh_TT_attributes = Vissim.net.VehicleTravelTimeMeasurement.GetAll;%�����г�ʱ������
T_travel_number = size(Veh_TT_attributes,1);
traveltimereal = zeros(length(T_travel_number),3);
for  Veh_TT_measurement_number=1:T_travel_number
% Veh_TT_measurement = Vissim.net.VehicleTravelTimeMeasurements.ItemByKey(Veh_TT_measurement_number);
% TT(Veh_TT_measurement_number) = get(Veh_TT_measurement, 'AttValue', 'TravTm(Avg,Avg,All)');
% disp(['Average T_travel of all simulations and time intervals \n #',num2str(Veh_TT_measurement_number),':',32,num2str(TT(Veh_TT_measurement_number))]) % char(32) is whitespace
disp(['Average T_travel of all simulations and time intervals \n #',num2str(Veh_TT_measurement_number),':']);
traveltimereal(Veh_TT_measurement_number,1) = Veh_TT_measurement_number;
traveltimereal(Veh_TT_measurement_number,2) = input('�����뵱ǰ���������·���г�ʱ�����ʵֵs:');
traveltimereal(Veh_TT_measurement_number,3) = input('�����뵱ǰ���������·���г�ʱ���Ȩ�أ�1-10������:');
end
 traveltimereal
disp(['��Ȩ����г�ʱ�� \n:']) 
traveltimerealWeightedaverage  =  sum(traveltimereal(:,2).*traveltimereal(:,3))/sum(traveltimereal(:,3))
TARGET(1) = traveltimerealWeightedaverage;
end
% Delay
if DELAY==1
Veh_Delay = Vissim.Net.DelayMeasurements.GetAll;
delay_number = size(Veh_Delay,1);
delayreal = zeros(length(delay_number),3);
for  Veh_Delay_number=1:delay_number
% Veh_Delay_measurement = Vissim.net.DelayMeasurements.ItemByKey(Veh_Delay_number);
% Delay(Veh_Delay_number) = get(Veh_Delay_measurement, 'AttValue', 'VehDelay(Avg,Avg,All)');
% disp(['Average Delay of all simulations and time intervals \n #',num2str(Veh_Delay_number),':',32,num2str(Delay(Veh_Delay_number))]) % char(32) is whitespace
disp(['Average Delay of all simulations and time intervals \n #',num2str(Veh_Delay_number),':']); 
delayreal(Veh_Delay_number,1) = Veh_Delay_number;
delayreal(Veh_Delay_number,2) = input('�����뵱ǰ���������·���������ʵֵs:');
delayreal(Veh_Delay_number,3) = input('�����뵱ǰ���������·�������Ȩ�أ�1-10������:');
end
delayreal
disp(['��Ȩ������� \n:']) 
delayrealWeightedaverage  = sum(delayreal(:,2).*delayreal(:,3))/sum(delayreal(:,3)) 
 TARGET(2) = delayrealWeightedaverage;
end
 % Queue length
if QUEUEMAX==1
QC = Vissim.net.QueueCounters.GetAll;
m=1;
for QC_number = 1:size(QC,1)
%  maxQ(m) = get(Vissim.Net.QueueCounters.ItemByKey(QC_number),'AttValue', 'QLenMax(Avg, Avg)');
%  disp(['Average maximum Queue length of all simulations and time intervals of Queue Counter\n #',num2str(QC_number),':',32,num2str(maxQ(m))]) % char(32) is whitespace
 disp(['Average maximum Queue length of all simulations and time intervals of Queue Counter\n #',num2str(QC_number),':']);
 maxQreal(m,1) = QC_number;
 maxQreal(m,2) = input('�����뵱ǰ���������������Ŷӳ��ȵ���ʵֵm:');
 maxQreal(m,3) = input('�����뵱ǰ�������������Ȩ�أ�1-10������:');
 m=m+1;
end
maxQreal
disp(['��Ȩ�������Ŷӳ���m \n:']) 
maxQrealWeightedaverage = sum(maxQreal(:,2).*maxQreal(:,3))/sum(maxQreal(:,3))
 TARGET(3) = maxQrealWeightedaverage;    
end
if QUEUEMEAN==1
QC = Vissim.net.QueueCounters.GetAll;
m=1;
for QC_number = 1:size(QC,1)
% MEANQ(m) = get(Vissim.Net.QueueCounters.ItemByKey(QC_number),'AttValue', 'QLen(Max, Avg)');
% disp(['Average MEAN Queue length of all simulations and time intervals of Queue Counter #',num2str(QC_number),':',32,num2str(MEANQ(m))]) % char(32) is whitespace
disp(['Average MEAN Queue length of all simulations and time intervals of Queue Counter #',num2str(QC_number),':'])
 MEANQreal(m,1) = QC_number;
 MEANQreal(m,2) = input('�����뵱ǰ�����������ƽ���Ŷӳ��ȵ���ʵֵm:');
 MEANQreal(m,3) = input('�����뵱ǰ�������������Ȩ�أ�1-10������:');
m=m+1;
end
MEANQreal
disp(['��Ȩ���ƽ���Ŷӳ���m \n:']) 
MEANQrealWeightedaverage = sum(MEANQreal(:,2).*MEANQreal(:,3))/sum(MEANQreal(:,3))
TARGET(4) = MEANQrealWeightedaverage;  
end
% traffic capacity
% Data collection
if CAPACITY==1
dcm = Vissim.net.DataCollectionMeasurements.GetAll;%����datacollection����
dcm_number = size(dcm,1);
capacityreal = zeros(length(dcm_number),3);
for  dcm_measurement_number=1:dcm_number
disp(['traffic flow of all simulations and time intervals \n #',num2str(dcm_measurement_number),':']);
capacityreal(dcm_measurement_number,1) = dcm_measurement_number;
capacityreal(dcm_measurement_number,2) = input('�����뵱ǰ���������·����������ʵֵs:');
capacityreal(dcm_measurement_number,3) = input('�����뵱ǰ���������·��������Ȩ�أ�1-10������:');
end
 capacityreal
disp(['��Ȩ���traffic flow \n:']) 
capacityrealWeightedaverage  =  sum(capacityreal(:,2).*capacityreal(:,3))/sum(capacityreal(:,3))
TARGET(5) = capacityrealWeightedaverage;
end
%% ָ��Ȩ��ָ��
     if  sum(TARGET>0)>=2;
    indectorweighte = zeros(length(TARGET>0),1);   
 disp('�Ƿ�Ҫ��Ϊָ����������ָ���Ȩ�أ�')   
 tagg = input('��Ϊָ��Ȩ��������1������ϵͳĬ��Ȩ��������0��\n');
 if tagg ==1
  if TRAVELTIME
      disp('�������г�ʱ��ָ����ռ���أ�1-10��\n');
      indectorweighte(1) = input('�������г�ʱ��ָ��ı��أ�1-10����');
  end
    if DELAY
    disp('����������ָ����ռ���أ�1-10��\n');
    indectorweighte(2) = input('����������ָ��ı��أ�1-10����');    
    end
    if QUEUEMAX
    disp('����������Ŷӳ���ָ����ռ���أ�1-10��\n');
    indectorweighte(3) = input('����������Ŷӳ���ָ��ı��أ�1-10����');      
    end
    if  QUEUEMEAN
    disp('������ƽ���Ŷӳ���ָ����ռ���أ�1-10��\n');
    indectorweighte(4) = input('������ƽ���Ŷӳ���ָ��ı��أ�1-10����');        
    end
  if CAPACITY
      disp('������ͨ������ָ����ռ���أ�1-10��\n');
      indectorweighte(5) = input('������ͨ������ָ��ı��أ�1-10����');
  end    
    indectorweighte = indectorweighte(indectorweighte(:,1)~=0,1);
 else
       indectorweighte =ones(length(TARGET>0),1);  
  end 
     else
       indectorweighte =1;  
     end
    
     if  sum(TARGET>0)>=2;
  disp('�Ƿ�Ѷ�Ŀ���Ż�תΪ��Ŀ���Ż����⣬����ǣ�������1���������������0') ;
    tag = input('������1����0: \n'); 
     else 
         tag  = 1;
     end

 
%% =============  GA Calibration ===================
    if paracalibtag(1)~=0&paracalibtag(3)~=0
    numberOfVariables = 9;
    ub = [2.5, 4.7, 8, 200, -1, 0.6, -3, 20, 150];
    lb = [0.5, 0.7, 1, 0.05, -3, 0.1, -9, 5,   50];
    end
    if paracalibtag(1)~=0&paracalibtag(3)==0
    numberOfVariables = 4;
    ub = [2.5, 4.7, 8, 200];
    lb = [0.5, 0.7, 1, 0.05];
    end
    if paracalibtag(2)~=0&paracalibtag(3)~=0%wiedeman99&lane change
    numberOfVariables = 9;
    ub = [3.5, 4, 8, 1.05, -1, 0.6, -3, 20, 150];
    lb = [0.5, 1, 2, 0.05, -3, 0.1, -9, 5,   50];
    end   
    if paracalibtag(2)~=0&paracalibtag(3)==0%wiedeman99
    numberOfVariables = 4;%vissim 9 �汾��W99cc1��ΪW99cc1Distr������ȡֵ�����1-4��������������С������ֻȡ���������֣�
    ub = [3.5, 4, 8, 1.05];
    lb = [0.5, 1, 2, 0.05];
    end
        numberOfVariables
    FitnessFunction =@GaCalib_direct;
    if tag==0 
    options = gaoptimset('PlotFcn',{@gaplotpareto,@gaplotscorediversity},'PopulationSize',20,'Generations',30,'FitnessLimit',0.05);%ǰ��ͼ��
   [X,FVAL,EXITFLAG] = gamultiobj(FitnessFunction,numberOfVariables,[],[],[],[],lb,ub,options);
    else
     options = gaoptimset('PlotFcn',{@gaplotscorediversity , @gaplotbestf},'PopulationSize',20,'Generations',30,'FitnessLimit',0.05);%ÿһ���÷ֵ�ֱ��ͼ�÷ֺ�plots the best function value versus generation.
    [X,FVAL,EXITFLAG] = ga(FitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options);%ga����Ĭ��һ����20�����壬һ���Ŵ�100����
    end
% end
%% ========================================================================
% End Vissim
Vissim.release
    
    