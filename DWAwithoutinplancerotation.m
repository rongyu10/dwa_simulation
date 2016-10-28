function [] = DynamicWindowApproachSample()
clc;
clear;
clf;
% sim_d=1;
% line_x=0.0:0.005/sim_d:3.0;
% line_y=0.0:0.005/sim_d:3.0;
% 
% for g_i=1:length(line_x)
% 	p_gx(g_i)=line_x(g_i);
% 	p_gy(g_i)=line_y(g_i); 
% end
R=0.5;
sim_d1=10.0;
theta_circle=pi:-pi/sim_d1:0.0;
line_x=R*cos(theta_circle);
line_y=R*sin(theta_circle);

theta_circle2=-pi+pi/sim_d1:pi/sim_d1:0.0;
line_x2=R*cos(theta_circle2)+2*R;
line_y2=R*sin(theta_circle2);

theta_circle=pi-pi/sim_d1:-pi/sim_d1:0.0;
line_x3=R*cos(theta_circle)+4*R;
line_y3=R*sin(theta_circle);

sim_d=0.1;

% line_x4=2.5-0.001/sim_d:-0.001/sim_d:1.5;
% line_y4=(0-0.001/sim_d:-0.001/sim_d:-1.0)*1.0;
% 
% line_x5=1.5-0.001/sim_d:-0.001/sim_d:0.5;
% line_y5=(1.0-0.001/sim_d:-0.001/sim_d:0.0)*-1.0;
% 
% line_x6=0.5-0.001/sim_d:-0.001/sim_d:-0.5;
% line_y6=(0.0-0.001/sim_d:-0.001/sim_d:-1.0)*1.0;

line_x4=2.5-0.001/sim_d:-0.001/sim_d:1.5;
line_y4=(0-0.001/sim_d:-0.001/sim_d:-1.0)*1.0;

line_x5=1.5-0.001/sim_d:-0.001/sim_d:1.2;
line_y5=(1.0-0.001/sim_d:-0.001/sim_d:0.7)*-1.0;

line_x6=1.2-0.001/sim_d:-0.001/sim_d:-0.5;
line_y6=(-0.7-0.001/sim_d:-0.001/sim_d:-2.4)*1.0;

for g_i=1:length(line_x)+length(line_x2)+length(line_x3)+length(line_x4)+length(line_x5)+length(line_x6)
%for g_i=1:length(line_x)+length(line_x2)+length(line_x3)+length(line_x4)+length(line_x5)
    if g_i<=length(line_x)
        p_gx(g_i)=line_x(g_i);
        p_gy(g_i)=line_y(g_i); 
    elseif g_i<=length(line_x)+length(line_x2)
        p_gx(g_i)=line_x2(g_i-length(line_x));
        p_gy(g_i)=line_y2(g_i-length(line_x));
    elseif g_i<=length(line_x)+length(line_x2)+length(line_x3)
        p_gx(g_i)=line_x3(g_i-length(line_x)-length(line_x2));
        p_gy(g_i)=line_y3(g_i-length(line_x)-length(line_x2));
    elseif g_i<=length(line_x)+length(line_x2)+length(line_x3)+length(line_x4);
        p_gx(g_i)=line_x4(g_i-length(line_x)-length(line_x2)-length(line_x3));
        p_gy(g_i)=line_y4(g_i-length(line_x)-length(line_x2)-length(line_x3));
    elseif g_i<=length(line_x)+length(line_x2)+length(line_x3)+length(line_x4)+length(line_x5);
        p_gx(g_i)=line_x5(g_i-length(line_x)-length(line_x2)-length(line_x3)-length(line_x4));
        p_gy(g_i)=line_y5(g_i-length(line_x)-length(line_x2)-length(line_x3)-length(line_x4));
    else
        p_gx(g_i)=line_x6(g_i-length(line_x)-length(line_x2)-length(line_x3)-length(line_x4)-length(line_x5));
        p_gy(g_i)=line_y6(g_i-length(line_x)-length(line_x2)-length(line_x3)-length(line_x4)-length(line_x5));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 for i=2:length(p_gx)-1  
        thetay(i)=(p_gy(i+1)-p_gy(i));
        thetax(i)=(p_gx(i+1)-p_gx(i));
        thetay1(i)=(p_gy(i)-p_gy(i-1));
        thetax1(i)=(p_gx(i)-p_gx(i-1));
        y1=thetay(i)/thetax(i);
        y2_1=thetay1(i)/thetax1(i);
        y2=(y1-y2_1)/thetax(i);     % ���Կ���
        k=abs(y2)/(1+y1^2)^(3/2);
        curve(i)=1/k;
 end
curve(1)=1000000.0;

    brokenline=1;
    for i=1:length(p_gx)-1
        if curve(i)<1000     %%%%%%%%%%%%%%%%%%%����threshold
            p_curvex(brokenline)=p_gx(i);
            p_curvey(brokenline)=p_gy(i);
%             j_bl(brokenline)=i;
            brokenline=brokenline+1;            
        end  
    end
    
    p_curvex(brokenline)=p_gx(g_i);
    p_curvey(brokenline)=p_gy(g_i);
%     j_bl(brokenline)=g_i;
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
disp('Dynamic Window Approach sample program start!!')
%x=[p_gx(1) p_gy(1) 1.5*pi/4 0 0]';
x=[p_gx(1) p_gy(1) pi/4 0 0]';
%goal=[p_gx(g_i),p_gy(g_i)];    %�S�[���̈ʒu [x(m),y(m)]
f_goal=[p_gx(g_i),p_gy(g_i)];

%��Q�����X�g [x(m) y(m)]
obstacle=[-1 9];

%     foot_print_spec = [ 0.18,0.2
%                         0.23,0.15 
%                         0.23,-0.15
%                         0.18,-0.2
%                         -0.18,-0.2
%                         -0.23,-0.15
% 			            -0.23,0.15
%                         -0.18,0.2
%                         0.18,0.2 ];

% foot_print_spec = [ 0.146,0.243
%                     0.232,0.187
%                     0.282,0.110
%                     0.282,-0.110
%                     0.232,-0.187
%                     0.146,-0.243
%                     -0.116,-0.243
%                     -0.234,-0.176 
%                     -0.282,-0.091
%                     -0.282,0.091
%                     -0.234,0.176
%                     -0.116,0.243
%                     0.146,0.243];

foot_print_spec = [ 0.146,0.243
                    0.50,0.0
                    0.146,-0.243
                    -0.116,-0.243
                    -0.234,-0.176 
                    -0.282,-0.091
                    -0.282,0.091
                    -0.234,0.176
                    -0.116,0.243
                    0.146,0.243];
                
     
%obstacleR=0.5;%�Փ˔���p�̏�Q���̔��a
obstacleR=0.01;
%global dt; dt=0.1;%���ݎ���[s]
global dt; dt=0.4;   %sim_granularity;
global pgs; pgs=100; %goal������˵ĵ�ĸ���
global cost_traj;
global opt_traj;
global p_gxn; p_gxn=p_gx;
global p_gyn; p_gyn=p_gy;
global min_vel; min_vel=0.05;

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
    hold off;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%prune point on global plan
    while length(p_gxn)>1        
        distance_gr1=sqrt((p_gxn(1)-x(1))^2+(p_gyn(1)-x(2))^2);
        if distance_gr1<0.2
            p_gxn(1)=[];
            p_gyn(1)=[];
        else
             break;
        end
    end
      
    for q_d=1:length(p_gx)
    	if (p_gxn(1)==p_gx(q_d))&&(p_gyn(1)==p_gy(q_d))
        	break;
        end
    end
           
    sum_pp=0.0;
    if q_d<length(p_gx)
        for q_18=q_d:length(p_gx)-1
            distance_pp=sqrt((p_gx(q_18+1)-p_gx(q_18))^2+(p_gy(q_18+1)-p_gy(q_18))^2);
            sum_pp=sum_pp+distance_pp;
            if sum_pp>=1.8
                break;
            else
                q_18=length(p_gx);
            end
            
        end
    end
    

        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1.8m goal on global plan
%     while length(p_gxn)>1        
%         distance_gr=sqrt((p_gxn(1)-x(1))^2+(p_gyn(1)-x(2))^2);
%         %if (distance(1)<5)&&(distance(1)>1.5)     %line parameters
% %         if distance_gr<1.8
% %             p_gxn(1)=[];
% %             p_gyn(1)=[];
% %         else
% %             break;
% %         end
%         if distance_gr<1.8
%             p_gxn(1)=[];
%             p_gyn(1)=[];
%         else
%             break;
%         end
%     end  
%     
%     for q_d=1:length(p_gx)
%     	if (p_gxn(1)==p_gx(q_d))&&(p_gyn(1)==p_gy(q_d))
%         	break;
%         end
%     end  
  
    if length(p_curvex)>1
        distance_gr2=sqrt((p_curvex(1)-x(1))^2+(p_curvey(1)-x(2))^2); 
        if (distance_gr2<=0.1)
        	p_curvex(1)=[];
        	p_curvey(1)=[]; 
                       
        end
    end
                         
	for q_cv=1:length(p_gx)
    	if (p_curvex(1)==p_gx(q_cv))&&(p_curvey(1)==p_gy(q_cv))
            break;
        end
    end

    if (q_18>=q_cv)
        goal(1)=p_curvex(1);
        goal(2)=p_curvey(1); 
    else
        goal(1)=p_gxn(1);
        goal(2)=p_gyn(1); 
    end    
        Angle_rg=atan2(goal(2)-x(2),goal(1)-x(1));
        dif_angle=abs(Angle_rg-x(3));
        if dif_angle>=4*pi
            dif_angle=dif_angle-4*pi;  
        elseif dif_angle>=3*pi
            dif_angle=dif_angle-3*pi;
        elseif dif_angle>=2*pi
            dif_angle=dif_angle-2*pi;
        elseif dif_angle>=pi
            dif_angle=dif_angle-pi;
        else
            dif_angle=dif_angle;
        end
%         fprintf('Angle_rg is % 5.4f,',Angle_rg);
%         fprintf('x(3) is % 5.4f\n,',x(3));
        if (dif_angle<=0.1)||((pi-dif_angle)<=0.1)
            distance_gr=sqrt((goal(1)-x(1))^2+(goal(2)-x(2))^2);          
            Kinematic(1)=distance_gr/3.6;
                if Kinematic(1)>0.5
                    Kinematic(1)=0.5;
                end
        else 
            min_vel=0.05;
            Kinematic(1)=min_vel;
        end

    %DWA�ɂ����͒l�̌v�Z
    [u,traj]=DynamicWindowApproach(x,Kinematic,goal,evalParam,obstacle,obstacleR);
    x=f(x,u);%�^�����f���ɂ��ړ�
    %�V�~�����[�V�������ʂ̕ۑ�
    result.x=[result.x; x'];
    %�S�[������

    if norm(x(1:2)-f_goal')<0.1
             disp('Arrive Goal!!');
             break;
    end
    
    %====Animation==== 
    ArrowLength=0.5;%���̒���  
    
    plot(p_gx(q_d), p_gy(q_d),'.r','MarkerSize',30);hold on;
    plot(p_curvex, p_curvey, 'or','MarkerSize',20);hold on;
    %plot(p_gxn, p_gyn, '.g');hold on;
    %���{�b�g
    %quiver(x(1),x(2),ArrowLength*cos(x(3)),ArrowLength*sin(x(3)),'ok');hold on;
    plot(result.x(:,1),result.x(:,2),'-b');hold on;
    plot(goal(1),goal(2),'.r','MarkerSize',30);hold on;
    
    
    

    %�T���O�Օ\��
    plot(p_gx,p_gy,'-b');hold on;
    
    if ~isempty(traj)
        sizepoints=size(traj);
        sizepoints=sizepoints(2);
        
        for it=1:length(traj(:,1))/5 % 1->16
            ind=1+(it-1)*5;
            
            plot(traj(ind,:),traj(ind+1,:),'og');hold on; 
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
global min_vel;
%�ԗ����f���ɂ��Window
%Vs=[0 model(1) -model(2) model(2)];
Vs=[min_vel min_vel -model(2) model(2)];

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