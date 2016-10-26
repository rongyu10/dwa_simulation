function [] = DynamicWindowApproachSample()
clc;
clear;
clf;
sim_d=1;
line_x=0.0:0.005/sim_d:3.0;
line_y=0.0:0.005/sim_d:3.0;

for g_i=1:length(line_x)
	p_gx(g_i)=line_x(g_i);
	p_gy(g_i)=line_y(g_i); 
end
 
disp('Dynamic Window Approach sample program start!!')
x=[p_gx(1) p_gy(1) 1.5*pi/4 0 0]';
%goal=[p_gx(g_i),p_gy(g_i)];    %�S�[���̈ʒu [x(m),y(m)]
f_goal=[p_gx(g_i),p_gy(g_i)];
%��Q�����X�g [x(m) y(m)]
obstacle=[-1 9];

    foot_print_spec = [ 0.18,0.2
                        0.23,0.15 
                        0.23,-0.15
                        0.18,-0.2
                        -0.18,-0.2
                        -0.23,-0.15
			            -0.23,0.15
                        -0.18,0.2
                        0.18,0.2 ];
     
%obstacleR=0.5;%�Փ˔���p�̏�Q���̔��a
obstacleR=0.01;
%global dt; dt=0.1;%���ݎ���[s]
global dt; dt=0.4;   %sim_granularity;
global pgs; pgs=100; %goal������˵ĵ�ĸ���
global cost_traj;
global opt_traj;
global p_gxn; p_gxn=p_gx;
global p_gyn; p_gyn=p_gy;
%���{�b�g�̗͊w���f��
%[�ō����x[m/s],�ō��񓪑��x[rad/s],�ō��������x[m/ss],�ō������񓪑��x[rad/ss],
% ���x�𑜓x[m/s],�񓪑��x�𑜓x[rad/s]]
%Kinematic=[1.0,toRadian(20.0),0.2,toRadian(50.0),0.01,toRadian(1)];
Kinematic=[0.5,0.6,0.5,1.2,0.01,0.04];
%�]���֐��̃p�����[�^ [heading,dist,velocity,predictDT]
%evalParam=[0.1,0.2,0.1,3.0];
evalParam=[0.2,0.2,0.21,3.6];
result.x=x';
tic;
%stopDist=0;
for i=1:2000           
    while length(p_gxn)>1        
        distance_gr=sqrt((p_gxn(1)-x(1))^2+(p_gyn(1)-x(2))^2);
        %if (distance(1)<5)&&(distance(1)>1.5)     %line parameters
        if distance_gr<1.8
            p_gxn(1)=[];
            p_gyn(1)=[];
        else
            break;
        end
    end     
        goal(1)=p_gxn(1);
        goal(2)=p_gyn(1);
        distance_gr=sqrt((p_gxn(1)-x(1))^2+(p_gyn(1)-x(2))^2);
        Kinematic(1)=distance_gr/3.6;
     
    %DWA�ɂ����͒l�̌v�Z
    [u,traj]=DynamicWindowApproach(x,Kinematic,goal,evalParam,obstacle,obstacleR);
    %size(traj)
    x=f(x,u);%�^�����f���ɂ��ړ�
    %�V�~�����[�V�������ʂ̕ۑ�
    result.x=[result.x; x'];
    %�S�[������
    %if norm(x(1:2)-goal')<0.5

    if norm(x(1:2)-f_goal')<0.3
        %stopDist=stopDist+x(4)*dt;%���������̌v�Z
         %x(4)=x(4)-Kinematic(3)*dt;
%         if x(4)<=0
             disp('Arrive Goal!!');
             break;
         end
    %end
   
    %====Animation====
    hold off;
    ArrowLength=0.5;%���̒���
    %���{�b�g
    %quiver(x(1),x(2),ArrowLength*cos(x(3)),ArrowLength*sin(x(3)),'ok');hold on;
    plot(result.x(:,1),result.x(:,2),'-b');hold on;
    plot(goal(1),goal(2),'*r');hold on;

    %�T���O�Օ\��
    plot(p_gx,p_gy,'-b');hold on;
    
    if ~isempty(traj)
        sizepoints=size(traj);
        sizepoints=sizepoints(2);
        
        for it=1:length(traj(:,1))/5 % 1->16
            ind=1+(it-1)*5;
            
            plot(traj(ind,:),traj(ind+1,:),'-g');hold on; 
            end_pointsum=[traj(ind,sizepoints),traj(ind+1,sizepoints)];
            end_pointx(it)=end_pointsum(1);
            end_pointy(it)=end_pointsum(2);

            x_end = 2*end_pointx(it)-traj(ind,sizepoints-1);
            y_end = 2*end_pointy(it)-traj(ind+1,sizepoints-1); 
            total_dist_str = [num2str(cost_traj(it))];
            %text(x_end, y_end, total_dist_str, 'FontSize',8, 'Color','b');
        end
         opt_ind=1+(opt_traj-1)*5;
         plot(traj(opt_ind,:),traj(opt_ind+1,:),'.r');hold on;
    end
    
    foot_print(:,1) = traj(1,1) + (foot_print_spec(:,1)*cos(traj(3,1)) - foot_print_spec(:,2)*sin(traj(3,1)));
    foot_print(:,2) = traj(2,1) + (foot_print_spec(:,1)*sin(traj(3,1)) + foot_print_spec(:,2)*cos(traj(3,1)));
    plot(foot_print(:,1), foot_print(:,2), '-k');
    
    %result.x(:,4)
    hold on;
    grid on;
    axis equal; 
    drawnow;
    %pause;
end
figure(2)
plot(result.x(:,4));
toc
 

function [u,trajDB]=DynamicWindowApproach(x,model,goal,evalParam,ob,R)
%DWA�ɂ����͒l�̌v�Z������֐�
global cost_traj;
global opt_traj;
%Dynamic Window[vmin,vmax,��min,��max]�̍쐬
%model(1)=0.2;
Vr=CalcDynamicWindow(x,model);
%�]���֐��̌v�Z
[evalDB,trajDB]=Evaluation(x,Vr,goal,ob,R,model,evalParam);
%trajDB
if isempty(evalDB)
    disp('no path to goal!!');
    u=[0;0];return;
end
%�e�]���֐��̐��K
%evalDB=NormalizeEval(evalDB);

%�ŏI�]���l�̌v�Z
feval=[];
sizepoints=size(trajDB);
sizepoints=sizepoints(2);
%length(evalDB(:,1))
for id=1:length(evalDB(:,1))
    ind=1+(id-1)*5;
    end_pointsum=[trajDB(ind,sizepoints),trajDB(ind+1,sizepoints)];
    pdistsum=0;

    pdist=(goal(1)-trajDB(ind,sizepoints))^2+(goal(2)-trajDB(ind+1,sizepoints))^2;
    pdistsum=pdistsum+pdist;

    gdist(id)=(goal(1)-x(1))^2+(goal(2)-x(2))^2;
    occdist(id)=0.1;
    pdist_cost(id)=evalParam(2)*pdistsum;
    gdist_cost(id)=evalParam(1)*gdist(id);
    occdist_cost(id)=evalParam(3)*occdist(id);   

end

if sum(gdist_cost)~=0
    gdist_cost=gdist_cost/sum(gdist_cost);
end
if sum(pdist_cost)~=0
    pdist_cost=pdist_cost/sum(pdist_cost);
end
if sum(occdist_cost)~=0
    occdist_cost=occdist_cost/sum(occdist_cost);
end
for id=1:length(evalDB(:,1))
    cost_sum=gdist_cost(id)+pdist_cost(id)+occdist_cost(id);
    feval=[feval;cost_sum];
end

%evalDB=[evalDB feval];
%b1=size(evalDB)
%size(evalDB)
%fprintf('evalDB is % 5.2f',evalDB);
%fprintf('\n,');
[maxv,ind]=min(feval);%�ł��]���l���傫�����͒l�̃C���f�b�N�X���v�Z
cost_traj=feval;
opt_traj=ind;


u=evalDB(ind,1:2)';%�]���l���������͒l��Ԃ�

        
        

function [evalDB,trajDB]=Evaluation(x,Vr,goal,ob,R,model,evalParam)
%�e�p�X�ɑ΂��ĕ]���l���v�Z����֐�
evalDB=[];
trajDB=[];

%for vt=Vr(1):model(5):Vr(2)
%vt=0.5;
vt=Vr(2);
%fprintf('vt is %5.4f,',vt);
    %for ot=Vr(3):model(6):Vr(4)
    for ot=-model(2):model(6):model(2)
        %�O�Ղ̐���
        [xt,traj]=GenerateTrajectory(x,vt,ot,evalParam(4),model);
        %size(traj(1,:))
        %traj(2,:)
        %fprintf('traj(1,:) is %5.2f',traj(1,:));
        %fprintf('\n');
        %plot(traj(1,:),traj(2,:),'og'); hold on;
        %�e�]���֐��̌v�Z
        heading=CalcHeadingEval(xt,goal);
        dist=CalcDistEval(xt,ob,R);
        vel=abs(vt);
        
        evalDB=[evalDB;[vt ot heading dist vel]];
        trajDB=[trajDB;traj]; 
        %pause;
    end
    %size(evalDB)
    %fprintf('Vr(3) is %5.4f\n',Vr(3));
    %fprintf('Vr(4) is %5.4f\n',Vr(4));
%end

function EvalDB=NormalizeEval(EvalDB)
%�]���l�𐳋K������֐�
if sum(EvalDB(:,3))~=0
    EvalDB(:,3)=EvalDB(:,3)/sum(EvalDB(:,3));
end
if sum(EvalDB(:,4))~=0
    EvalDB(:,4)=EvalDB(:,4)/sum(EvalDB(:,4));
end
if sum(EvalDB(:,5))~=0
    EvalDB(:,5)=EvalDB(:,5)/sum(EvalDB(:,5));
end

function [x,traj]=GenerateTrajectory(x,vt,ot,evaldt,model)
%�O�Ճf�[�^���쐬����֐�
global dt;
time=0.4;
u=[vt;ot];%���͒l
traj=x;%�O�Ճf�[�^
while time<=evaldt
    time=time+dt;%�V�~�����[�V�������Ԃ̍X�V
    x=f(x,u);%�^�����f���ɂ�鐄��
    traj=[traj x];
end

function stopDist=CalcBreakingDist(vel,model)
%���݂̑��x����͊w���f���ɏ]���Đ����������v�Z����֐�
global dt;
stopDist=0;
while vel>0
    stopDist=stopDist+vel*dt;%���������̌v�Z
    vel=vel-model(3)*dt;%�ō�����
end

function dist=CalcDistEval(x,ob,R)
%��Q���Ƃ̋����]���l���v�Z����֐�

dist=2;
for io=1:length(ob(:,1))
    disttmp=norm(ob(io,:)-x(1:2)')-R;%�p�X�̈ʒu�Ə�Q���Ƃ̃m�����덷���v�Z
    if dist>disttmp%�ŏ��l��������
        dist=disttmp;
    end
end

function heading=CalcHeadingEval(x,goal)
%heading�̕]���֐����v�Z����֐�

theta=toDegree(x(3));%���{�b�g�̕���
goalTheta=toDegree(atan2(goal(2)-x(2),goal(1)-x(1)));%�S�[���̕���

if goalTheta>theta
    targetTheta=goalTheta-theta;%�S�[���܂ł̕��ʍ���[deg]
else
    targetTheta=theta-goalTheta;%�S�[���܂ł̕��ʍ���[deg]
end

heading=180-targetTheta;

function Vr=CalcDynamicWindow(x,model)
%���f���ƌ��݂̏�Ԃ���DyamicWindow���v�Z
global dt;
%�ԗ����f���ɂ��Window
%Vs=[0 model(1) -model(2) model(2)];
Vs=[0.05 0.05 -model(2) model(2)];

%�^�����f���ɂ��Window
%Vd=[x(4)-model(3)*dt x(4)+model(3)*dt x(5)-model(4)*dt x(5)+model(4)*dt];
Vd=[x(4)-model(3)*dt min(model(1),x(4)+model(3)*dt) x(5)-model(4)*dt min(model(2),x(5)+model(4)*dt)];
     
%�ŏI�I��Dynamic Window�̌v�Z
Vtmp=[Vs;Vd];
Vr=[max(Vtmp(:,1)) max(Vtmp(:,2)) max(Vtmp(:,3)) min(Vtmp(:,4))];
%[vmin,vmax,��min,��max]

function x = f(x, u)
% Motion Model
global dt;
 
F = [1 0 0 0 0
     0 1 0 0 0
     0 0 1 0 0
     0 0 0 0 0
     0 0 0 0 0];
 
B = [dt*cos(x(3)) 0
    dt*sin(x(3)) 0
    0 dt
    1 0
    0 1];

x= F*x+B*u;

function radian = toRadian(degree)
% degree to radian
radian = degree/180*pi;

function degree = toDegree(radian)
% radian to degree
degree = radian/pi*180;