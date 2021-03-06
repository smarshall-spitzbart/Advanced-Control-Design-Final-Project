function [dx] = nonlinearDynamicsQuadcopter(x, cp1, cp2, cp3, cp4)

% Nonlinear Dynamics of a Quadcopter following Mueller's Notes
% Input x is the current state vector
% Inputs cp1, cp2, cp3, cp4 are the scalar forces of each propeller (parallel to
% the body-fixed 3B axis)
% Output dx is the first derivative of the current state vector
% Unraveling the input state vector

% Position of the quadcopter COM w.r.t a fixed target point expressed in 
% the earth-fixed coordinate system
s1 = x(1);       
s2 = x(2);
s3 = x(3);

% Velocity of the quadcopter�s COM relative to the earth-fixed frame, expressed in
% the earth-fixed coordinate system
v1 = x(4);
v2 = x(5);
v3 = x(6);

% Orientation of the body-fixed frame with respect to the earth-fixed frame
% Using Euler Angles for simplicity - this might need to be changed later

phi   = x(7);     % Roll
theta = x(8);     % Pitch
psi   = x(9);     % Yaw

% Angular velocity of the body-fixed frame with respect to the earth-fixed frame, expressed
% in the body-fixed coordinate system

p = x(10);        % roll rate
q = x(11);        % pitch rate
r = x(12);        % yaw rate

% Get necessary parameters
[TM] = eulerAngles2TM(phi, theta, psi); % Convert Euler Angles to Transformation Matrix
[Jxx, Jzz, m, l, k] = quadcopterParameters();
[cSigma, n1, n2, n3] = mixerMatrix(cp1, cp2, cp3, cp4);
g = 9.81;

% Derivative of position is velocity
ds1 = v1;
ds2 = v2;
ds3 = v3;

% Derivative of velocity
dv = (cSigma/m) * TM' * [0;0;1] + [0; 0; -1*g];
dv1 = dv(1);
dv2 = dv(2);
dv3 = dv(3);

% Derivative of orientation using Euler Angles
[derivEulerAngles] = dEulerAngles(phi, theta, psi, p, q, r);
dphi   = derivEulerAngles(1);     
dtheta = derivEulerAngles(2);     
dpsi   = derivEulerAngles(3);

% Derivative of angular velocity
dw = [n1/Jxx; n2/Jxx; n3/Jzz] + ((Jxx - Jzz)/Jxx) * [q*r; -1*p*r; 0];
dp = dw(1);
dq = dw(2);
dr = dw(3);

% Pack into state derivative vector
dx = [ds1;
      ds2;
      ds3;
      dv1;
      dv2;
      dv3;
      dphi;
      dtheta;
      dpsi;
      dp;
      dq;
      dr];
  
end
