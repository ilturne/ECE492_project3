function visualize_test_data_polar(test_data_filename)
    % Loads the colormap
    [z_88D, ~, ~] = colormap_88D;

    % Loads the test data
    test_data = load(test_data_filename);

    % Access the nested structure
    field_names = fieldnames(test_data);
    data_struct = test_data.(field_names{1});

    dBZ = data_struct.dBZ;
    ZDR = data_struct.ZDR;
    RhoHV = data_struct.RhoHV;
    dBZ_STD = data_struct.dBZ_STD;
    ZDR_STD = data_struct.ZDR_STD;
    PhiDP_STD = data_struct.PhiDP_STD;
    XPLOT = data_struct.XPLOT';
    YPLOT = data_struct.YPLOT';

    % Plot the reflectivity field (dBZ) using the provided X and Y coordinates
    figure;

    colormap(z_88D);
    pcolor(XPLOT, YPLOT, dBZ);
    shading flat;
    colorbar;
    title(['Reflectivity (dBZ) - Test Data: ', test_data_filename]);
    xlabel('X-axis');
    ylabel('Y-axis');
    axis image;
    axis([-300 300 -300 300]);

    grid_on;
    set(gca, 'FontSize', 20, 'FontWeight', 'bold');
    hold off;
end
