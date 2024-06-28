function rbf_model = train_rbf_network(training_data_filename, sigma, lambda, epochs, K_values)
    % Load the training data
    train_data = load(training_data_filename);
    data_struct = train_data.data_training;

    % Extract and combine variables
    dBZ = data_struct.dBZ;
    ZDR = data_struct.ZDR;
    RhoHV = data_struct.RhoHV;
    dBZ_STD = data_struct.dBZ_STD;
    ZDR_STD = data_struct.ZDR_STD;
    PhiDP_STD = data_struct.PhiDP_STD;
    D = data_struct.D;

    % Combine input variables into a single matrix
    inputs = [dBZ(:)'; ZDR(:)'; RhoHV(:)'; dBZ_STD(:)'; ZDR_STD(:)'; PhiDP_STD(:)'];
    targets = D(:)';

    % Normalize inputs to have zero mean and unit variance
    input_mean = mean(inputs, 2);
    input_std = std(inputs, 0, 2);
    inputs = (inputs - input_mean) ./ input_std;

    % Initialize MSE array for different K-values
    mse_k = zeros(length(K_values), 1);

    % Loop over different K-values
    for k_idx = 1:length(K_values)
        num_centers = K_values(k_idx);

        % K-means clustering
        [~, centers] = kmeans(inputs', num_centers);
        centers = centers';

        % Initialize RLS parameters
        delta = 5e-2; % Increased small positive constant
        P = delta * eye(num_centers);
        w = 0.01 * randn(num_centers, 1); % Initialize weights with small random values

        % Get the number of samples
        num_samples = size(inputs, 2);

        % Initialize MSE array for epochs
        mse_epoch = zeros(epochs, 1);

        % RLS algorithm with epochs
        for epoch = 1:epochs
            
            % Shuffle the data
            rand_indices = randperm(num_samples);
            inputs_shuffled = inputs(:, rand_indices);
            targets_shuffled = targets(rand_indices);
            
            % Initialize MSE for this epoch
            mse_total = 0;
            
            for n = 1:num_samples
                x_n = inputs_shuffled(:, n);
                d_n = targets_shuffled(n);
                
                % Compute Gaussian RBF inline
                g = zeros(num_centers, 1);
                for j = 1:num_centers
                    g(j) = exp(-norm(x_n - centers(:, j))^2 / (2 * sigma^2));
                end

                % Compute gain vector
                k_n = P * g / (lambda + g' * P * g);

                % Update weights
                w = w + k_n * (d_n - w' * g);

                % Update inverse correlation matrix
                P = (P - k_n * g' * P) / lambda;
                
                % Calculate the prediction and MSE for this sample
                y_n = w' * g;
                mse_total = mse_total + (d_n - y_n)^2;
            end
            
            % Average MSE for this epoch
            mse_epoch(epoch) = mse_total / num_samples;
        end

        % Store the final MSE for this K-value
        mse_k(k_idx) = mean(mse_epoch);
    end

    % Plot MSE against K-values
    figure;
    plot(K_values, mse_k, '-o');
    xlabel('Number of Centers (K)');
    ylabel('Mean Squared Error (MSE)');
    title('MSE vs. Number of Centers (K)');
    grid on;

    % Save the final model (using the last K-value)
    rbf_model.centers = centers;
    rbf_model.weights = w;
    rbf_model.sigma = sigma;
    save('trained_rbf_model_rls.mat', 'rbf_model', 'input_mean', 'input_std');
end
