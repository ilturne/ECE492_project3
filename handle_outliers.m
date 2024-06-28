function inputs_cleaned = handle_outliers(training_data_filename)
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

    % Combine input variables into a single matrix
    inputs = [dBZ(:)'; ZDR(:)'; RhoHV(:)'; dBZ_STD(:)'; ZDR_STD(:)'; PhiDP_STD(:)'];

    % Calculate Z-scores
    z_scores = (inputs - mean(inputs, 2)) ./ std(inputs, 0, 2);

    % Identify outliers (e.g., Z-score > 3 or Z-score < -3)
    outliers = abs(z_scores) > 3;

    % Display the number of outliers for each feature
    num_outliers = sum(outliers, 2);
    disp('Number of outliers for each feature:');
    disp(num_outliers);

    % Remove outliers from the data
    inputs_cleaned = inputs(:, ~any(outliers, 1));

    % Check the size of the cleaned data
    disp('Size of cleaned data:');

    % Save the cleaned data
    save('cleaned_data.mat', 'inputs_cleaned');
end
