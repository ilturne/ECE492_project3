function plot_mse_vs_k(training_data_filename, sigma, lambda, epochs_list, k_values)
    mse_results = zeros(length(k_values), length(epochs_list));

    for i = 1:length(k_values)
        num_centers = k_values(i);
        fprintf('Training with K = %d...\n', num_centers);

        for j = 1:length(epochs_list)
            epochs = epochs_list(j);
            fprintf('Training with %d epochs...\n', epochs);

            [~, mse] = train_rbf_network_rls_with_kmeans(training_data_filename, num_centers, sigma, lambda, epochs);
            mse_results(i, j) = mse;
        end
    end

    % Plotting MSE vs. K
    figure;
    for j = 1:length(epochs_list)
        plot(k_values, mse_results(:, j), '-o', 'DisplayName', sprintf('%d epochs', epochs_list(j)));
        hold on;
    end
    hold off;
    xlabel('Number of Centers (K)');
    ylabel('Mean Squared Error (MSE)');
    title('MSE vs. Number of Centers (K)');
    legend('show');
    grid on;
    set(gca, 'FontSize', 12, 'FontWeight', 'bold');
end