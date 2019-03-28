clear;
close all;
clc;

MONTE_CARLO = 10000;                                                       % Size of the Monte Carlo ensemble

B = 4;                                                                     % Number of bits in each symbol
N = 100000;                                                                   % Number of blocks in the transmission

M = 500;                                                                   % Number of antennas at the base station
K = 5;                                                                     % Number of users at the cell

snr_db = -20:1:10;                                                         % SNR in dB
snr    = 10.^(snr_db/10);                                                  % SNR
n_snr  = length(snr_db);

commcell.array_type  = 'linear';
commcell.antenna     = M;                                                  % Number of Antennas
commcell.user        = K;                                                  % Number of Users
commcell.multipath   = 2;                                                  % Number of Multipaths
commcell.radius      = 500;                                                % Cell's raidus (circumradius) in meters
commcell.bs_height   = 30;                                                 % Height of base station in meters
commcell.user_height = [1 2];                                              % Height of user terminals in meters ([min max])

c   = 3e8;                                                                 % Light speed
f_c = 2e9;                                                                 % Carrier frequency in Hz

propagation.lambda             = c/f_c;                                    % Wavelength of transmitted signal
propagation.ref_distance       = 1000;                                     % Reference distance for path loss calculation
propagation.mean_shadow_fad    = 0;                                        % Shadow fading mean in dB
propagation.std_dev_shadow_fad = 8;                                        % Shadow fading standard deviation in dB
propagation.path_loss_exponent = 3.8;                                      % Decay exponent

% Initialization

b = zeros(B*N,K);                                                          % Message in bits
s = zeros(K,N);                                                            % Message modulated in 2^B-QAM

b_hat = zeros(B*N,K);                                                      % Estimated message in bits

H = zeros(M,K,MONTE_CARLO);                                                % Channel matrix
D = zeros(K,K,MONTE_CARLO);                                                % Correlation matrix

I_K = eye(K);                                                              % Eye matrix

ber = zeros(n_snr,K,MONTE_CARLO);                                          % Bit-error rate

% Decoder parameters
    
decpar.precoder = 'mf';

for monte_carlo = 1:MONTE_CARLO
    
    monte_carlo
    
    [H(:,:,monte_carlo), beta] = massiveMIMOChannel(commcell,propagation,'rich');
    
    H(:,:,monte_carlo) = H(:,:,monte_carlo)*sqrt(diag(1./beta));           % We do not need take the large-scale fading into consideration in a BER analyse
    
    % Correlation between user's channel
    
    D(:,:,monte_carlo) = H(:,:,monte_carlo)'*H(:,:,monte_carlo)/M;
    
    % Signal generation for each user
    
    for k = 1:K
        b(:,k) = randi([0 1],B*N,1);                                       % Message in bits of the kth user
        s(k,:) = qammod(b(:,k),2^B,'InputType','bit').';                   % Message modulated in 2^B-QAM for the kth user
    end
    
    % Transmission power calculation
    
    Ps = norm(s(:),2)^2/(K*N);                                         % Transmitted signal's power
    
    for snr_index = 1:n_snr
        
        % Noise power calculation
        
        v  = randn(M,N) + 1i*randn(M,N);
        Pv = norm(v(:),2)^2/(M*N);
        
        % Received signal
        
        y = H(:,:,monte_carlo)*s + sqrt((Ps/Pv)/snr(snr_index))*v;
        
        % Decoding received signal
        
        s_hat = decoder(y,H(:,:,monte_carlo),decpar);
        
        % Received signal power calculation
        
        Ps_hat = norm(s_hat(:),2)^2/(K*N);
        
        % Received signal power normalization
        
        s_hat = sqrt(Ps/Ps_hat)*s_hat;
        
        % Signal decodification for each user
        
        for k = 1:K
            b_hat(:,k) = qamdemod(s_hat(k,:).',2^B,'OutputType','bit');
        end
        
        [~,ber(snr_index,:,monte_carlo)] = biterr(b_hat,b,[],'column-wise');
        
    end
    
end

save(['ber_' decpar.precoder '_M_'  num2str(M) '_K_' num2str(K) '_MC_' num2str(MONTE_CARLO) '.mat'],'ber','H','D');