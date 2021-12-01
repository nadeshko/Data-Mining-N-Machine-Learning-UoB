clc
clear 

%Global values
bias  = 1   ;
Error = {}  ;
lr    = 0.5 ;

%Initializing Inputs and Weight Matrix's
input = [0.9, 0.1, 0.1, 0.1; 0.1, 0.9, 0.1, 0.1  ;
          0.1, 0.1, 0.9, 0.1; 0.1, 0.1, 0.1, 0.9];
target = input;
W_1 = dlarray(rand(4,2));
W_2 = dlarray(rand(2,4));
Delta_W1 = zeros(4,2)   ;
Delta_W2 = zeros(2,4)   ;

%Start Iteration
for epoch = 1:1:1000
    %Using different input patterns
    for i = 1:1:4
        %Input-Hidden Layer
        y_in   = dlarray(W_1'*input(:,i));
        y_out  = sigmoid(y_in)           ;
        %Hidden-Output Layer
        o_in   = W_2'*y_out              ;
        o_out = sigmoid(o_in)            ; 
 
        %EBP  
        %Output Layer                                       
        deltaj_out   = (o_out.*(o_out - target(:,i))).*(1-o_out)        ;
        Delta_W2     = Delta_W2 + (-lr * (y_out * deltaj_out'))         ;           
        %Hidden Layer
        deltaj_hid   = W_2*deltaj_out                                   ;
        Delta_W1     = Delta_W1 + (-lr * (input(:,i) * deltaj_hid'))    ;
        
        %Appending Error to a cell
        Error{epoch, i} = extractdata((1/2)*sum((o_out-target(:,i)).^2));
    end  
    %Updating weights after doing each input pattern
    W_1 = W_1 + Delta_W1./4;
    W_2 = W_2 + Delta_W2./4;
    Delta_W1 = 0           ;
    Delta_W2 = 0           ;
end

%Testing if output is correct
for i = 1:1:4
    hid_in  = W_1'*input(:,i)     ;
    hid_out = sigmoid(hid_in)     ;
    out_in  = W_2'*hid_out        ;
    out_out(:,i) = sigmoid(out_in);
end
%Output to command window
out_out

%Plotting Error vs Epoch
Error = cell2mat(Error);
plot(1:1000, Error)
