function predictions = test_rbf_network(test_data_filename, rbf_model_filename)
    [z_88D, ~, ~] = colormap_88D;
    
    % Load the test data
    test_data = load(test_data_filename);
    field_names = fieldnames(test_data);
    data_struct = test_data.(field_names{1});

    % Extract and combine variables
    dBZ = data_struct.dBZ;
    ZDR = data_struct.ZDR;
    RhoHV = data_struct.RhoHV;
    dBZ_STD = data_struct.dBZ_STD;
    ZDR_STD = data_struct.ZDR_STD;
    PhiDP_STD = data_struct.PhiDP_STD;
    XPLOT = data_struct.XPLOT';
    YPLOT = data_struct.YPLOT';

    % Combine input variables into a single matrix
    test_inputs = [dBZ(:)'; ZDR(:)'; RhoHV(:)'; dBZ_STD(:)'; ZDR_STD(:)'; PhiDP_STD(:)'];

    % Debugging: Check for NaN values in raw input data
    fprintf('NaN values in raw input data: %d\n', sum(isnan(test_inputs(:))));

    % Debugging: Check for NaN values after handling
    fprintf('NaN values after handling in input data: %d\n', sum(isnan(test_inputs(:))));

    % Load the trained RBF model and normalization statistics
    load(rbf_model_filename, 'rbf_model', 'input_mean', 'input_std');
    centers = rbf_model.centers;
    weights = rbf_model.weights;
    sigma = rbf_model.sigma;

    % Debugging: Check for NaN values in centers
    fprintf('NaN values in centers: %d\n', sum(isnan(centers(:))));

    % Normalize the test inputs using training statistics
    test_inputs = (test_inputs - input_mean) ./ input_std;

    % Debugging: Check for NaN values in normalized input data
    fprintf('NaN values in normalized input data: %d\n', sum(isnan(test_inputs(:))));
    fprintf('Normalized test input sample values:\n');
    disp(test_inputs(:, 1:5));

    % Number of test samples and centers
    num_test_samples = size(test_inputs, 2);
    num_centers = size(centers, 2);

    % Compute Gaussian RBF for test data (vectorized)
    distances = pdist2(single(test_inputs'), single(centers'), 'euclidean');
    fprintf('NaN values in distances: %d\n', sum(isnan(distances(:))));
    fprintf('Distances min value: %f\n', min(distances(:)));
    fprintf('Distances max value: %f\n', max(distances(:)));

    Phi_test = exp(-distances.^2 / (2 * sigma^2));
    fprintf('NaN values in Phi_test: %d\n', sum(isnan(Phi_test(:))));
    fprintf('Phi_test min value: %f\n', min(Phi_test(:)));
    fprintf('Phi_test max value: %f\n', max(Phi_test(:)));

    % Predict using trained weights
    predictions = Phi_test * weights;

    % Apply thresholding to filter out noise
    threshold = -0.5; % Adjust this value based on your data characteristics
    predictions(predictions < threshold) = NaN;

    % Reshape predictions for visualization
    predictions = reshape(predictions, size(dBZ));

    % Debugging output for dimensions and sample values
    fprintf('XPLOT dimensions: %d x %d\n', size(XPLOT));
    fprintf('YPLOT dimensions: %d x %d\n', size(YPLOT));
    fprintf('Predictions dimensions: %d x %d\n', size(predictions));
    fprintf('Predictions min value: %f\n', min(predictions(:)));
    fprintf('Predictions max value: %f\n', max(predictions(:)));
    fprintf('Predictions sample values:\n');
    disp(predictions(1:5, 1:5));

    % Plot the predictions
    figure;
    colormap(z_88D);
    pcolor(XPLOT, YPLOT, predictions);
    shading flat;
    colorbar;
    title(['Predicted Reflectivity (dBZ) - Test Data: ', test_data_filename]);
    xlabel('X-axis');
    ylabel('Y-axis');
    axis image;
    axis([-300 300 -300 300]);

    grid_on;

    % Enhance the plot
    set(gca, 'FontSize', 20, 'FontWeight', 'bold');
    hold off;
end
