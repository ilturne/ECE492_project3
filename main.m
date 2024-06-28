% Parameters
training_data_filename = 'data_training.mat';
num_centers = 100;  % Number of RBF centers (K) Value
sigma = 1.4;       % Spread parameter for the Gaussian RBF
lambda = 0.99;     % Forgetting factor for the RLS algorithm
epochs = 5;
K_values = [10, 50, 100];

% Call the function to train the RBF network
train_rbf_network(training_data_filename, sigma, lambda, epochs, K_values);

load('trained_rbf_model_rls.mat', 'rbf_model');
disp(rbf_model);

test_data_filename = 'data_test3.mat';
rbf_model_filename = 'trained_rbf_model_rls.mat'; % Name of the trained model file

predictions = test_rbf_network(test_data_filename, rbf_model_filename);