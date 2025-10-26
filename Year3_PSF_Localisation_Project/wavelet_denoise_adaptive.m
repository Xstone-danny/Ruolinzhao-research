function denoised = wavelet_denoise_adaptive(array, lambda, var)

    % Step 1: Remove background
    if lambda == 0
        Imean = mean(array(:));
    else
        Imean = lambda;
    end
    img_shifted = array - Imean;

    % Step 2: Wavelet decomposition
    level = 2;
    wname = 'sym4';
    [C, S] = wavedec2(img_shifted, level, wname);

    % Step 3: Universal soft-threshold
    T = median(abs(C(:))) / 0.6745 * sqrt(2 * log(numel(array)));% Universal threshold
    C_thresh = sign(C) .* max(abs(C) - T, 0);  % soft thresholding

    % Step 4: Reconstruction
    denoised = waverec2(C_thresh, S, wname);

    % Step 5: Restore and suppress low background
    bg_sigma = std(array(:));
    adaptive_thresh = Imean + 0.5 * bg_sigma;
    denoised(denoised < adaptive_thresh) = 0;
end
