%% the angle thetas
syms theta1;
syms theta2;
syms theta3;
syms theta4;
syms theta5;
flag = 0;
%% broken joint
%set equal to 1 for broken joint
broken1 = 0;
broken2 = 1;
broken3 = 0;
broken4 = 0;
broken5 = 0;
robotJoints = [broken1 broken2 broken3 broken4 broken5];
%% angle about the norm from old Z axis to new z axis
% basically how much to rotate old z axis of previous frame
% to match the orientation of the z axis in the current frame
alpha1 = - pi/2;
alpha2 = 0;
alpha3 = 0;
alpha4 = pi/2;
alpha5 = 0;

%% distance from center of frame to next frame 
% the lengt of each arm/segment in general
r1= 0;
r2=  .729;
r3 = 0.729;
r4 = 0;
r5 = 0;

%% offset of previous z axis to the current z axis
d1= 1.1458333;
d2 = 0;
d3= 0;
d4 = 0;
d5= .354;

%% attempt to prealocate memory 
jacobian = zeros(6,5);
jinverse = zeros(6,5);
dtheta = [.001;.001;0.001;0.001;.001];

%tdtheta = zeros(6,1);

%% homogenious matrix for each frame from frame n-1 to n
% 0 to 1 is A1 for example
A1 = [cos(theta1) -sin(theta1)*cos(alpha1) sin(theta1)*sin(alpha1) r1*cos(theta1);
		sin(theta1) cos(theta1)*cos(alpha1) -cos(theta1)*sin(alpha1) r1*sin(theta1);
		0 sin(alpha1) cos(alpha1) d1;
		0 0 0 1];
		
A2 = [cos(theta2) -sin(theta2)*cos(alpha2) sin(theta2)*sin(alpha2) r2*cos(theta2);
		sin(theta2) cos(theta2)*cos(alpha2) -cos(theta2)*sin(alpha2) r2*sin(theta2);
		0 sin(alpha2) cos(alpha2) d2;
		0 0 0 1];
		
A3 = [cos(theta3) -sin(theta3)*cos(alpha3) sin(theta3)*sin(alpha3) r3*cos(theta3);
		sin(theta3) cos(theta3)*cos(alpha3) -cos(theta3)*sin(alpha3) r3*sin(theta3);
		0 sin(alpha3) cos(alpha3) d3;
		0 0 0 1];
		
A4 = [cos(theta4) -sin(theta4)*cos(alpha4) sin(theta4)*sin(alpha4) r4*cos(theta4);
		sin(theta4) cos(theta4)*cos(alpha4) -cos(theta4)*sin(alpha4) r4*sin(theta4);
		0 sin(alpha4) cos(alpha4) d4;
		0 0 0 1];
		
A5 = [cos(theta5) -sin(theta5)*cos(alpha5) sin(theta5)*sin(alpha5) r5*cos(theta5);
		sin(theta5) cos(theta5)*cos(alpha5) -cos(theta5)*sin(alpha5) r5*sin(theta5);
		0 sin(alpha5) cos(alpha5) d5;
		0 0 0 1];
		


j1 = A1;
j2 = A1*A2;
j3 = j2*A3;
j4 = j3*A4;
j5 = j4*A5;

dog1 = (symfun(j1(1:3,4), [theta1 theta2 theta3 theta4 theta5 ]));
dog2 = (symfun(j2(1:3,4), [theta1 theta2 theta3 theta4 theta5 ]));
dog3 = (symfun(j3(1:3,4), [theta1 theta2 theta3 theta4 theta5 ]));
dog4 = (symfun(j4(1:3,4), [theta1 theta2 theta3 theta4 theta5 ]));
dog5 = (symfun(j5(1:3,4), [theta1 theta2 theta3 theta4 theta5 ]));



%%the complete homogenious matrix
homoGen = (((((A1*A2)*A3)*A4)*A5));

%making a function out of the translation portion of homogenious matrix
dog = (symfun(homoGen(1:3,4), [theta1 theta2 theta3 theta4 theta5]));
dog = vpa(dog);

sm = (symfun(homoGen, [theta1 theta2 theta3 theta4 theta5]));

%% extracting rotation matrix from homogenios matrix
%and then turning them to euler angles
rotM = homoGen(1:3,1:3);
dotM = (symfun(homoGen, [ theta1 theta2 theta3 theta4 theta5 ])); 
syseul = [ atan2(-rotM(3,1),(sqrt((rotM(3,2)^2) + rotM(3,3)^2))); atan2(rotM(2,1),rotM(1,1)); atan2(rotM(3,2),rotM(3,3))];

%making a function out of these euler angles
eul = (symfun(syseul, [ theta1 theta2 theta3 theta4 theta5 ]));
eul = vpa(eul);

%taking partial derivative with respect to each theta



%% the initial values of the thetas (can change to any reachable position)
thetav1 = 0.000;
thetav2 = -2.27;
thetav3 = 0;
thetav4 = 0;
thetav5 = 0;

% thetav1 = -1.32;
% thetav2 = .586;
% thetav3 = -2.244;
% thetav4 = 2.25;
% thetav5 = 1.5;

thetaRow = [thetav1, thetav2, thetav3, thetav4, thetav5];
% maxtv1 = 6.2831;
% maxtv2 = 1.57;
% maxtv3 = 2.705;
% maxtv4 = 1.5708;
% maxtv5 = 1.5708;

maxtv1 = 5.41;
maxtv2 = .61;
maxtv3 = 2.27;
maxtv4 = 2.27;
maxtv5 = 2.27;

mintv1 = -5.41;
mintv2 = -2.27;
mintv3 = -2.27;
mintv4 = -2.27;
mintv5 = -2.27;

maxRow = [maxtv1, maxtv2, maxtv3, maxtv4, maxtv5];
minRow = [mintv1, mintv2, mintv3, mintv4, mintv5];
% mintv1 = 0;
% mintv2 = 0;
% mintv3 = 0;
% mintv4 = 0;
% mintv5 = 0;

%% determining current position by plugging in current theta angles
newDog = dog(thetav1,thetav2,thetav3,thetav4,thetav5);
newEul = eul(thetav1,thetav2,thetav3,thetav4,thetav5);

cPos = [ newDog(1,1);newDog(2,1);newDog(3,1); newEul(1,1); newEul(2,1); newEul(3,1) ];
if (broken1 == 1 || broken2 == 1|| broken3 == 1 || broken4 == 1|| broken5 == 1)
    cPos = [cPos(1); cPos(2); cPos(3)];
end

iPos = cPos;
vpa(cPos)

%% calculating error and target position
%targetPos = [.08;.2977;1.89;-1.2;1.3;0];
targetPos = [.87;-1;1.0448;0.4;0.93;2.3];
%targetPos = [1.65;0;1.5948;0.4;0.93;2.3];
targetPos = [-1;1;1.5;0.4;0.93;2.3];
if (broken1 == 1 || broken2 == 1|| broken3 == 1|| broken4 == 1|| broken5 == 1)
    targetPos = [targetPos(1); targetPos(2); targetPos(3)];
end
error = (targetPos - cPos);
ierror = error;
n = 0;
divi = 10;
scalar = .01;
ss= 1;
first = 0;
%while n < 2
index = 2;
x = [double(cPos(1,1))];
y = [double(cPos(2,1))];
z = [double(cPos(3,1))];

cat1 = dog1(thetav1,thetav2,thetav3,thetav4,thetav5);
cat2 = dog2(thetav1,thetav2,thetav3,thetav4,thetav5);
cat3 = dog3(thetav1,thetav2,thetav3,thetav4,thetav5);
cat4 = dog4(thetav1,thetav2,thetav3,thetav4,thetav5);
cat5 = dog5(thetav1,thetav2,thetav3,thetav4,thetav5);
tempError = error;

%% loop to find the change in angles needed to reach target position
%while n < 1
while ( abs(error(1,1)) >= .05 || abs(error(2,1)) >= .05 || abs(error(3,1)) >= .05 || abs(error(4,1)) >= .05 || abs(error(5,1)) >= .05 || abs(error(6,1)) >= .05)  
%while ( abs(error(1,1)) >= .05 || abs(error(2,1)) >= .05 || abs(error(3,1)) >= .05)  
% plugging in current thetas in to partial derivatives
if (broken1 == 1 || broken2 == 1 || broken3 == 1 || broken4 == 1 || broken5 == 1)
    error = tempError;
end
if broken1 == 1
    dtheta(1,1) = 0;
end
if broken2 == 1
    dtheta(2,1) = 0;
end
if broken3 == 1
    dtheta(3,1) = 0;
end
if broken4 == 1
    dtheta(4,1) = 0;
end
if broken5 == 1
    dtheta(5,1) = 0;
end
fk1 = dog(thetav1 + dtheta(1,1),thetav2,thetav3,thetav4,thetav5);
fk2 = dog(thetav1,thetav2+ dtheta(2,1),thetav3,thetav4,thetav5);
fk3 = dog(thetav1,thetav2,thetav3 +dtheta(3,1),thetav4,thetav5);
fk4 = dog(thetav1,thetav2,thetav3,thetav4+ dtheta(4,1),thetav5);
fk5 = dog(thetav1,thetav2,thetav3,thetav4,thetav5+ dtheta(5,1));

efk1 = eul(thetav1 + dtheta(1,1),thetav2,thetav3,thetav4,thetav5);
efk2 = eul(thetav1,thetav2+ dtheta(2,1),thetav3,thetav4,thetav5);
efk3 = eul(thetav1,thetav2,thetav3+ dtheta(3,1),thetav4,thetav5);
efk4 = eul(thetav1,thetav2,thetav3,thetav4+ dtheta(4,1),thetav5);
efk5 = eul(thetav1,thetav2,thetav3,thetav4,thetav5+ dtheta(5,1));

jac1 = [vpa(((fk1(1,1) - cPos(1,1))/(dtheta(1,1)))); vpa(((fk1(2,1) - cPos(2,1))/(dtheta(1,1)))); vpa(((fk1(3,1) - cPos(3,1))/(dtheta(1,1))))];
jac2 = [vpa(((fk2(1,1) - cPos(1,1))/(dtheta(2,1)))); vpa(((fk2(2,1) - cPos(2,1))/(dtheta(2,1)))); vpa(((fk2(3,1) - cPos(3,1))/(dtheta(2,1))))];
jac3 = [vpa(((fk3(1,1) - cPos(1,1))/(dtheta(3,1)))); vpa(((fk3(2,1) - cPos(2,1))/(dtheta(3,1)))); vpa(((fk3(3,1) - cPos(3,1))/(dtheta(3,1))))];
jac4 = [vpa(((fk4(1,1) - cPos(1,1))/(dtheta(4,1)))); vpa(((fk4(2,1) - cPos(2,1))/(dtheta(4,1)))); vpa(((fk4(3,1) - cPos(3,1))/(dtheta(4,1))))];
jac5 = [vpa(((fk5(1,1) - cPos(1,1))/(dtheta(5,1)))); vpa(((fk5(2,1) - cPos(2,1))/(dtheta(5,1)))); vpa(((fk5(3,1) - cPos(3,1))/(dtheta(5,1))))];
%computing jacobian
jacobian = [];
jacFull = [jac1,jac2,jac3,jac4,jac5];
for c = 1:1:length(robotJoints)
    if (robotJoints(c) == 0)
        jacobian = horzcat(jacobian,jacFull(:,c));
    end
end
if (broken1 == 0 && broken2 == 0 && broken3 == 0 && broken4 == 0 && broken5 == 0)
    jacRPY = [vpa(((efk1(1,1) - cPos(4,1))/(dtheta(1,1)))), vpa(((efk2(1,1) - cPos(4,1))/(dtheta(2,1)))), vpa(((efk3(1,1) - cPos(4,1))/(dtheta(3,1)))), vpa(((efk4(1,1) - cPos(4,1))/(dtheta(4,1)))),vpa(((efk5(1,1) - cPos(4,1))/(dtheta(5,1))));
        vpa(((efk1(2,1) - cPos(5,1))/(dtheta(1,1)))), vpa(((efk2(2,1) - cPos(5,1))/(dtheta(2,1)))), vpa(((efk3(2,1) - cPos(5,1))/(dtheta(3,1)))), vpa(((efk4(2,1) - cPos(5,1))/(dtheta(4,1)))),vpa(((efk5(2,1) - cPos(5,1))/(dtheta(5,1))));
        vpa(((efk1(3,1) - cPos(6,1))/(dtheta(1,1)))), vpa(((efk2(3,1) - cPos(6,1))/(dtheta(2,1)))), vpa(((efk3(3,1) - cPos(6,1))/(dtheta(3,1)))), vpa(((efk4(3,1) - cPos(6,1))/(dtheta(4,1)))),vpa(((efk5(3,1) - cPos(6,1))/(dtheta(5,1))))];
        jacobian = vertcat(jacobian,jacRPY);
end



% finding inverse
jinverse = vpa(pinv(vpa(jacobian)));
% finding dtheta
derror = vpa(error)/divi;
dtheta = vpa(jinverse)*vpa(derror);
checkDtheta = dtheta %used for debugging
for q = 1:1:size(jacobian,2)
    while(abs(dtheta(q,1)) > 1)
        dtheta(q,1) = dtheta(q,1)/10;
    end
end


%vpa(dtheta)



% moving the theta values by a small amount
index = 1;
for g=1:1:length(robotJoints)
    if (robotJoints(g) == 0)
        thetaRow(g) = vpa(thetaRow(g) + vpa(dtheta(index,1))/ss);
        if (thetaRow(g) > maxRow(g))
            thetaRow(g) = vpa(thetaRow(g) - vpa(dtheta(index,1))/ss);
            dtheta(index,1) = 0;
        elseif (thetaRow(g) < minRow(g))
            thetaRow(g) = vpa(thetaRow(g) + vpa(dtheta(index,1))/ss);
            dtheta(index,1) = 0;
        end
        index = index + 1;
    end
end
thetav1 = thetaRow(1);
thetav2 = thetaRow(2);
thetav3 = thetaRow(3);
thetav4 = thetaRow(4);
thetav5 = thetaRow(5);

% calculate new position and update error and show new position
newDog = vpa(dog(thetav1,thetav2,thetav3,thetav4,thetav5));
newEul = vpa(eul(thetav1,thetav2,thetav3,thetav4,thetav5));

cPos = [ newDog(1,1);newDog(2,1);newDog(3,1); newEul(1,1); newEul(2,1); newEul(3,1) ];
%cPos = [ newDog(1,1);newDog(2,1);newDog(3,1)];
if (broken1 == 1 || broken2 == 1|| broken3 == 1 || broken4 == 1|| broken5 == 1)
    cPos = [cPos(1); cPos(2); cPos(3)];
end
cat1 = dog1(thetav1,thetav2,thetav3,thetav4,thetav5);
cat2 = dog2(thetav1,thetav2,thetav3,thetav4,thetav5);
cat3 = dog3(thetav1,thetav2,thetav3,thetav4,thetav5);
cat4 = dog4(thetav1,thetav2,thetav3,thetav4,thetav5);
cat5 = dog5(thetav1,thetav2,thetav3,thetav4,thetav5);


x(index) = double(cPos(1));
y(index) = double(cPos(2));
z(index) = double(cPos(3));

index = index + 1;
error = (targetPos - vpa(cPos));

vpa(cPos)
dtheta = [.001;.001;0.001;0.001;.001];
j1x(index) = vpa(cat1(1,1));
j1y(index) = vpa(cat1(2,1));
j1z(index) = vpa(cat1(3,1));
j2x(index) = vpa(cat2(1,1));
j2y(index) = vpa(cat2(2,1));
j2z(index) = vpa(cat2(3,1));
j3x(index) = vpa(cat3(1,1));
j3y(index) = vpa(cat3(2,1));
j3z(index) = vpa(cat3(3,1));
j4x(index) = vpa(cat4(1,1));
j4y(index) = vpa(cat4(2,1));
j4z(index) = vpa(cat4(3,1));
j5x(index) = vpa(cat5(1,1));
j5y(index) = vpa(cat5(2,1));
j5z(index) = vpa(cat5(3,1));
pBase = [[0,0,0];transpose(vpa(cat1))];
p12 = [transpose(vpa(cat1));transpose(vpa(cat2))];
p23 = [transpose(vpa(cat2));transpose(vpa(cat3))];
p34 = [transpose(vpa(cat3));transpose(vpa(cat4))];
p45 = [transpose(vpa(cat4));transpose(vpa(cat5))];
figure(1);
plot3(pBase(:,1),pBase(:,2),pBase(:,3),'g');
hold on;
plot3(p12(:,1),p12(:,2),p12(:,3),'r');
hold on;
plot3(p23(:,1),p23(:,2),p23(:,3),'k');
hold on;
plot3(p34(:,1),p34(:,2),p34(:,3),'m');
hold on;
plot3(p45(:,1),p45(:,2),p45(:,3),'b');
hold on;
scatter3(targetPos(1,1),targetPos(2,1),targetPos(3,1),'kx');
hold on;
scatter3(j1x(index),j1y(index),j1z(index),'g');
hold on;
scatter3(j2x(index),j2y(index),j2z(index),'r');
hold on;
scatter3(j3x(index),j3y(index),j3z(index),'k');
hold on;
scatter3(j4x(index),j4y(index),j4z(index),'m');
hold on;
scatter3(j5x(index),j5y(index),j5z(index),'b^');
hold on;
xlabel('x coordinate');
ylabel('y coordinate');
zlabel('z coordinate');
axis([-2 2 -2 2 0 2])
grid on;
F=getframe;
movie(F);
% filename = sprintf('%s_%d','RobustDemo',n)
% filename = strcat(filename,'.jpg');
% saveas(figure(1),filename);
clf;
if (broken1 == 1 || broken2 == 1 || broken3 == 1 || broken4 == 1 || broken5 == 1)
    tempError = error;
    error = [error;0;0;0];
end
n = n+1;
end
figure(2);
plot3(pBase(:,1),pBase(:,2),pBase(:,3),'g');
hold on;
plot3(p12(:,1),p12(:,2),p12(:,3),'r');
hold on;
plot3(p23(:,1),p23(:,2),p23(:,3),'k');
hold on;
plot3(p34(:,1),p34(:,2),p34(:,3),'m');
hold on;
plot3(p45(:,1),p45(:,2),p45(:,3),'b');
hold on;
scatter3(targetPos(1,1),targetPos(2,1),targetPos(3,1),'kx');
hold on;
scatter3(j1x(index),j1y(index),j1z(index),'g');
hold on;
scatter3(j2x(index),j2y(index),j2z(index),'r');
hold on;
scatter3(j3x(index),j3y(index),j3z(index),'k');
hold on;
scatter3(j4x(index),j4y(index),j4z(index),'m');
hold on;
scatter3(j5x(index),j5y(index),j5z(index),'b');
hold on;
xlabel('x coordinate');
ylabel('y coordinate');
zlabel('z coordinate');
axis([-2 2 -2 2 0 2])
grid on;