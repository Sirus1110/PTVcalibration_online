
%% ============= 1. Connect to COM ===================
global Vissim
global db
global wdb
global zhongqun
zhongqun = 1;
global lk
global isConnector
global parameterlist
global paraselectag %����ѡ���ļ������
global parameters 
parameters = importdata('parameters.mat')
global db_def_index
global TARGET
paraselectag=importdata('paraselectag.mat')
parameterlist = importdata('parameterlist.mat')
TARGET=importdata('TARGET.mat')
global pathname
global filename
global tag
global indectorweighte
    global TRAVELTIME
    global DELAY
    global QUEUEMAX 
    global QUEUEMEAN
    global CAPACITY
    global traveltimereal
    global delayreal
    global maxQreal 
    global MEANQreal   
    global edition_number
           edition_number = 0;  

    try
    Vissim = actxserver('VISSIM.Vissim-64.900'); % Start Vissim
    catch
        try
        Vissim = actxserver('VISSIM.Vissim-32.900'); % Start Vissim
        catch
            try
            Vissim = actxserver('VISSIM.Vissim-64.800'); % Start Vissim
            catch
                try
                Vissim = actxserver('VISSIM.Vissim-32.800'); % Start Vissim  
                catch
                  try
                  Vissim = actxserver('VISSIM.Vissim-64.700'); % Start Vissim      
                  catch
                      try
                      Vissim = actxserver('VISSIM.Vissim-32.700'); % Start Vissim      
                      catch
                          try
                          Vissim = actxserver('VISSIM.Vissim-64.600'); % Start Vissim        
                          catch
                              try
                              Vissim = actxserver('VISSIM.Vissim-32.600'); % Start Vissim          
                              catch
                                  try
                                   Vissim = actxserver('VISSIM.Vissim.540'); % Start Vissim 
                                   edition_number = 540;
                                  end
                              end
                          end
                      end
                  end
                end    
            end
        end
    end

 path = [pathname  filename]; 
  Vissim.LoadNet(path);
  try
 path1 = [pathname  'vissim.ini'];
  Vissim.LoadLayout(path1);
  end
    
isConnector = []; link_attribute=[];
if  edition_number==0
lk = Vissim.net.Links.GetAll;
for iLk = 1:size(lk,1)%�жϸ�·���Ƿ�Ϊ������������������п��ܻ�ı��䡰�������롱��һ����
    if lk{iLk}.AttValue('IsConn')
        isConnector = [isConnector,iLk];
    else
    link_attribute = [link_attribute, Vissim.net.Links.ItemByKey(lk{iLk}.AttValue('No')).AttValue('LinkBehavType'),iLk];
    end
end
else if edition_number==540
        lk = Vissim.net.Links;
        for iLk = 1:lk.count%�жϸ�·���Ƿ�Ϊ������������������п��ܻ�ı��䡰�������롱��һ����
            link = lk.Item(iLk);
            if link.AttValue('CONNECTOR')
                link_attribute = [link_attribute, lk.GetLinkByNumber(link.AttValue('ID')).AttValue('BEHAVIORTYPE'),iLk];
            else
                isConnector = [isConnector,iLk];
            end
        end
    end
end

if  edition_number==0
% DRIVING BEHAVIOR
db = Vissim.net.DrivingBehaviors.GetAll;
db_def_index = str2num(get(Vissim.Net.Links.ItemByKey(1), 'AttValue', 'LinkBehavType'));
sprintf('db_def_index=%d\n',db_def_index)
wdb = db{db_def_index};%��·����Wiedeman99/74,�ͻ���������
else if edition_number==540
        db = Vissim.net.DrivingBehaviorParSets;
        db_def_index = get(Vissim.Net.Links.GetLinkByNumber(1), 'AttValue', 'BEHAVIORTYPE');
        sprintf('db_def_index=%d\n',db_def_index)
        %db_def_indexΪ1-6�����֣�
        wdb = db.GetDrivingBehaviorParSetByNumber(db_def_index);%��·����Wiedeman99/74,�ͻ���������        
     end  
end

if  edition_number==0
%Wiedeman 99
cc0 = wdb.AttValue('W99cc0');
try
cc1 = wdb.AttValue('W99cc1Distr');
catch
cc1 = wdb.AttValue('W99cc1');   
end
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
DecelRedDistOwn = wdb.AttValue('DecelRedDistOwn');
AccDecelOwn = wdb.AttValue('AccDecelOwn');
DiffusTm = wdb.AttValue('DiffusTm');
MinHdwy = wdb.AttValue('MinHdwy');
SafDistFactLnChg = wdb.AttValue('SafDistFactLnChg');
CoopDecel = wdb.AttValue('CoopDecel');
VehRoutDecLookAhead = wdb.AttValue('VehRoutDecLookAhead');
CoopLnChgSpeedDiff = wdb.AttValue('CoopLnChgSpeedDiff');
else 
    if edition_number==540
        %Wiedeman 99
        cc0 = wdb.AttValue('cc0');
        cc1 = wdb.AttValue('cc1');
        cc2 = wdb.AttValue('cc2');
%         cc3 = wdb.AttValue('cc3');
        cc4 = wdb.AttValue('cc4');
        cc5 = wdb.AttValue('cc5');
        cc6 = wdb.AttValue('cc6');
        cc7 = wdb.AttValue('cc7');
        cc8 = wdb.AttValue('cc8');
        cc9 = wdb.AttValue('cc9');
        lcDist = lk.Item(isConnector(1)).AttValue('LANECHANGEDISTANCE');
        %Wiedeman 74
        W74ax = wdb.AttValue('AXADD');
        W74bxAdd = wdb.AttValue('BXADD');
        W74bxMult = wdb.AttValue('BXMULT');   
    end
end

if edition_number==0
% Set maximum speed:
set(Vissim.Simulation, 'AttValue', 'UseMaxSimSpeed', true);
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
else
    if edition_number==540
        % travel time
        if TRAVELTIME==1
        Veh_TT_attributes = Vissim.net.TravelTimes;%�����г�ʱ������
        T_travel_number = Veh_TT_attributes.count;
        traveltimereal = zeros(T_travel_number,3);
        for  Veh_TT_measurement_number=1:T_travel_number
        disp(['Average T_travel of all simulations and time intervals \n #',num2str(Veh_TT_measurement_number),':']);
        traveltimereal(Veh_TT_measurement_number,1) = Veh_TT_measurement_number;
        traveltimereal(Veh_TT_measurement_number,2) = input('�����뵱ǰ���������·���г�ʱ�����ʵֵs:');
        traveltimereal(Veh_TT_measurement_number,3) = input('�����뵱ǰ���������·���г�ʱ���Ȩ�أ�1-10������:');
        end
        disp(['��Ȩ����г�ʱ�� \n:']) 
        traveltimerealWeightedaverage  =  sum(traveltimereal(:,2).*traveltimereal(:,3))/sum(traveltimereal(:,3));
        TARGET(1) = traveltimerealWeightedaverage
        end
        % Delay
        if DELAY==1
        Veh_Delay = Vissim.Net.Delays;
        delay_number = Veh_Delay.Count;
        delayreal = zeros(delay_number,3);
        for  Veh_Delay_number=1:delay_number
        disp(['Average Delay of all simulations and time intervals \n #',num2str(Veh_Delay_number),':']); 
        delayreal(Veh_Delay_number,1) = Veh_Delay_number;
        delayreal(Veh_Delay_number,2) = input('�����뵱ǰ���������·���������ʵֵs:');
        delayreal(Veh_Delay_number,3) = input('�����뵱ǰ���������·�������Ȩ�أ�1-10������:');
        end
        disp(['��Ȩ������� \n:']) 
        delayrealWeightedaverage  = sum(delayreal(:,2).*delayreal(:,3))/sum(delayreal(:,3)); 
         TARGET(2) = delayrealWeightedaverage
        end
         % Queue length
        if QUEUEMAX==1
        QC = Vissim.net.QueueCounters;
        m=1;
        for QC_number = 1:QC.Count
         disp(['Average maximum Queue length of all simulations and time intervals of Queue Counter\n #',num2str(QC_number),':']);
         maxQreal(m,1) = QC_number;
         maxQreal(m,2) = input('�����뵱ǰ���������������Ŷӳ��ȵ���ʵֵm:');
         maxQreal(m,3) = input('�����뵱ǰ�������������Ȩ�أ�1-10������:');
         m=m+1;
        end
        disp(['��Ȩ�������Ŷӳ���m \n:']) 
        maxQrealWeightedaverage = sum(maxQreal(:,2).*maxQreal(:,3))/sum(maxQreal(:,3));
         TARGET(3) = maxQrealWeightedaverage 
        end
        if QUEUEMEAN==1
        QC = Vissim.net.QueueCounters;
        m=1;
        for QC_number = 1:QC.Count
        disp(['Average MEAN Queue length of all simulations and time intervals of Queue Counter #',num2str(QC_number),':'])
         MEANQreal(m,1) = QC_number;
         MEANQreal(m,2) = input('�����뵱ǰ�����������ƽ���Ŷӳ��ȵ���ʵֵm:');
         MEANQreal(m,3) = input('�����뵱ǰ�������������Ȩ�أ�1-10������:');
        m=m+1;
        end
        disp(['��Ȩ���ƽ���Ŷӳ���m \n:']) 
        MEANQrealWeightedaverage = sum(MEANQreal(:,2).*MEANQreal(:,3))/sum(MEANQreal(:,3));
        TARGET(4) = MEANQrealWeightedaverage 
        end
        % traffic capacity
        % Data collection
        if CAPACITY==1
        dcm = Vissim.net.DataCollections;%����datacollection����
        dcm_number = dcm.Count;
        capacityreal = zeros(dcm_number,3);
        for  dcm_measurement_number=1:dcm_number
        disp(['traffic flow of all simulations and time intervals \n #',num2str(dcm_measurement_number),':']);
        capacityreal(dcm_measurement_number,1) = dcm_measurement_number;
        capacityreal(dcm_measurement_number,2) = input('�����뵱ǰ���������·����������ʵֵVEH/H:');
        capacityreal(dcm_measurement_number,3) = input('�����뵱ǰ���������·��������Ȩ�أ�1-10������:');
        end
        disp(['��Ȩ���traffic flow \n:']) 
        capacityrealWeightedaverage  =  sum(capacityreal(:,2).*capacityreal(:,3))/sum(capacityreal(:,3));
        TARGET(5) = capacityrealWeightedaverage
        end        
    end
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
       indectorweighte =ones(sum(TARGET>0),1);  
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
if edition_number==0
    if paraselectag(1)~=0&paraselectag(3)~=0
       parameters(parameterlist,1) 
    numberOfVariables = length(parameterlist);
    ub = [2.5, 4.7, 8, 200,300,3, 5,   200, -0.5, 3.5, 0.6, -3, 20];
    lb = [0.5, 0.7, 1, 50, 100,0, 1,   100, -3,   0.5, 0.1, -6, 5];
    ub = ub(1,parameterlist)
    lb = lb(1,parameterlist)
    end
    if paraselectag(1)~=0&paraselectag(3)==0
       parameters(parameterlist,1) 
    numberOfVariables = length(parameterlist);
    ub = [2.5, 4.7, 8, 200,300,3, 5];
    lb = [0.5, 0.7, 1, 50, 100,0, 1];
    ub = ub(1,parameterlist)
    lb = lb(1,parameterlist)
    end
    if paraselectag(2)~=0&paraselectag(3)~=0%wiedeman99&lane change
       parameters(parameterlist,1) 
    numberOfVariables = length(parameterlist);
    ub = [3.5, 4,   8, -5, -0.15,   7, 15.4, 0.95,5, 2.5, 5,  200, 350,  5,  200, -0.5, 3.5, 0.6, -3, 20];
    lb = [0.5, 1, 1, -10, -0.7, 0.7, 8.44, 0.15,0, 0.5, 1,  100, 150,0.5,  100,   -3, 0.5, 0.1, -6,  5];
    ub = ub(1,parameterlist)
    lb = lb(1,parameterlist)    
    end   
    if paraselectag(2)~=0&paraselectag(3)==0%wiedeman99
       parameters(parameterlist,1) 
    numberOfVariables = length(parameterlist);
    ub = [3.5, 4,   8, -5, -0.15,   7, 15.4, 0.95,5, 2.5, 5,  200, 350,  5];
    lb = [0.5, 1, 1, -10, -0.7, 0.7, 8.44, 0.15,0, 0.5, 1,  100, 150,0.5];
    ub = ub(1,parameterlist)
    lb = lb(1,parameterlist)    
    end
else
    if edition_number==540

        if paraselectag(1)~=0
        parameters(parameterlist,1) 
        numberOfVariables = length(parameterlist);
            ub = [2.5, 4.7, 8];
            lb = [0.5, 0.7, 1];
        ub = ub(1,parameterlist)
        lb = lb(1,parameterlist)           
        end 
        if paraselectag(2)~=0%wiedeman99
        parameters(parameterlist,1) 
        numberOfVariables = length(parameterlist);
            ub = [3.5, 4, 8, -5, -0.15,   7, 15.4, 0.95,5, 2.5];
            lb = [0.5, 1, 1, -10, -0.7, 0.7, 8.44, 0.15,0, 0.5];
        ub = ub(1,parameterlist)
        lb = lb(1,parameterlist)            
        end        
    end
end    
    
    
        numberOfVariables
FitnessFunction =@GaCalib_afterselection;
    if tag==0 
    options = gaoptimset('PlotFcn',{@gaplotpareto,@gaplotscorediversity},'PopulationSize',20,'Generations',30,'FitnessLimit',0.05);%ǰ��ͼ��
   [X,FVAL,EXITFLAG] = gamultiobj(FitnessFunction,numberOfVariables,[],[],[],[],lb,ub,options);
    else
     options = gaoptimset('PlotFcn',{@gaplotscorediversity , @gaplotbestf},'PopulationSize',20,'Generations',30,'FitnessLimit',0.05);%ÿһ���÷ֵ�ֱ��ͼ�÷ֺ�plots the best function value versus generation.
     [X,FVAL,EXITFLAG] = ga(FitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options);%ga����Ĭ��һ����20�����壬һ���Ŵ�100����
    end
save('drivingparameters_final.mat','X');
save('ga_evaluation_fval.mat','FVAL');
save('ga_stopped_reason.mat','EXITFLAG');    
%% ========================================================================
% End Vissim

if edition_number == 0;  
Vissim.release;
else
  Vissim.simulation.Stop;  
end
    
    