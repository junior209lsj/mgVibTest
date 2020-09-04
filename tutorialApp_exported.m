classdef tutorialApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        UIAxes                       matlab.ui.control.UIAxes
        FilenameEditFieldLabel       matlab.ui.control.Label
        FilenameEditField            matlab.ui.control.EditField
        loadButton                   matlab.ui.control.Button
        FFTButton                    matlab.ui.control.Button
        Label                        matlab.ui.control.Label
        LoadStatus                   matlab.ui.control.EditField
        fminEditFieldLabel           matlab.ui.control.Label
        fminEditField                matlab.ui.control.NumericEditField
        fmaxEditFieldLabel           matlab.ui.control.Label
        fmaxEditField                matlab.ui.control.NumericEditField
        MminEditFieldLabel           matlab.ui.control.Label
        MminEditField                matlab.ui.control.NumericEditField
        MmaxEditFieldLabel           matlab.ui.control.Label
        MmaxEditField                matlab.ui.control.NumericEditField
        ReloadfButton                matlab.ui.control.Button
        ReloadmagButton              matlab.ui.control.Button
        STFTButton                   matlab.ui.control.Button
        LowCutSliderLabel            matlab.ui.control.Label
        LowCutSlider                 matlab.ui.control.Slider
        HighCutSliderLabel           matlab.ui.control.Label
        HighCutSlider                matlab.ui.control.Slider
        LowEnable                    matlab.ui.control.CheckBox
        HighEnable                   matlab.ui.control.CheckBox
        WindowfunctionDropDownLabel  matlab.ui.control.Label
        WindowfunctionDropDown       matlab.ui.control.DropDown
    end

    
    properties (Access = private)
        y % Time domain data of audio file
        Fs % Sampling rate of audio file
        f % X-Frequency
        t % X-time
        Y % Frequency domain data of loaded file
        isFileLoad % flag checking whether file is loaded or not
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: loadButton
        function loadButtonPushed(app, event)
            app.isFileLoad = false;
            try
                fileName = app.FilenameEditField;
                [data, sr] = audioread(fileName.Value);
            catch ME
                fail = errordlg(ME.identifier, 'File load error');
                app.LoadStatus.Value = "File load failed";
            end
            app.y = data;
            app.Fs = sr;
            app.LoadStatus.Value = "File loaded successful";
        end

        % Button pushed function: FFTButton
        function FFTButtonPushed(app, event)
            yy = reshape(app.y, [], 1);
            sz = size(app.y);
            L = sz(1);
            T = 1/app.Fs;
            app.t = (0:L-1)*T;
            app.t = reshape(app.t, [], 1);
            if (app.LowEnable.Value == true)
                yy = highpass(yy, app.LowCutSlider.Value, app.Fs);
            end
            if (app.HighEnable.Value == true)
                yy = lowpass(yy, app.HighCutSlider.Value, app.Fs);
            end
            app.Y = fft(yy);
            app.f = app.Fs*(0:(L-1))/L;
            app.f = reshape(app.f, [], 1);
            plot(app.UIAxes, app.f, abs(app.Y), 'k-');
        end

        % Button pushed function: ReloadfButton
        function ReloadfButtonPushed(app, event)
            xlim(app.UIAxes, [app.fminEditField.Value, app.fmaxEditField.Value]);
        end

        % Button pushed function: ReloadmagButton
        function ReloadmagButtonPushed(app, event)
            ylim(app.UIAxes, [app.MminEditField.Value, app.MmaxEditField.Value]);
        end

        % Button pushed function: STFTButton
        function STFTButtonPushed(app, event)
            x = reshape(app.y, 1, []);
            stft(x);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 622 635];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'FFT Result')
            xlabel(app.UIAxes, 'Frequency')
            ylabel(app.UIAxes, 'Amplitude')
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.Position = [20 361 584 275];

            % Create FilenameEditFieldLabel
            app.FilenameEditFieldLabel = uilabel(app.UIFigure);
            app.FilenameEditFieldLabel.HorizontalAlignment = 'right';
            app.FilenameEditFieldLabel.FontName = 'Arial';
            app.FilenameEditFieldLabel.Position = [20 233 55 22];
            app.FilenameEditFieldLabel.Text = 'Filename';

            % Create FilenameEditField
            app.FilenameEditField = uieditfield(app.UIFigure, 'text');
            app.FilenameEditField.FontName = 'KBIZÿÿÿÿÿ R';
            app.FilenameEditField.Position = [90 233 451 22];

            % Create loadButton
            app.loadButton = uibutton(app.UIFigure, 'push');
            app.loadButton.ButtonPushedFcn = createCallbackFcn(app, @loadButtonPushed, true);
            app.loadButton.Position = [551 233 53 22];
            app.loadButton.Text = 'load';

            % Create FFTButton
            app.FFTButton = uibutton(app.UIFigure, 'push');
            app.FFTButton.ButtonPushedFcn = createCallbackFcn(app, @FFTButtonPushed, true);
            app.FFTButton.Position = [90 193 100 22];
            app.FFTButton.Text = 'FFT';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [464 193 10 22];
            app.Label.Text = '';

            % Create LoadStatus
            app.LoadStatus = uieditfield(app.UIFigure, 'text');
            app.LoadStatus.Editable = 'off';
            app.LoadStatus.HorizontalAlignment = 'center';
            app.LoadStatus.Position = [434 193 170 22];
            app.LoadStatus.Value = 'File not loaded';

            % Create fminEditFieldLabel
            app.fminEditFieldLabel = uilabel(app.UIFigure);
            app.fminEditFieldLabel.HorizontalAlignment = 'right';
            app.fminEditFieldLabel.Position = [47 299 28 22];
            app.fminEditFieldLabel.Text = 'fmin';

            % Create fminEditField
            app.fminEditField = uieditfield(app.UIFigure, 'numeric');
            app.fminEditField.Position = [90 299 100 22];

            % Create fmaxEditFieldLabel
            app.fmaxEditFieldLabel = uilabel(app.UIFigure);
            app.fmaxEditFieldLabel.HorizontalAlignment = 'right';
            app.fmaxEditFieldLabel.Position = [244 299 32 22];
            app.fmaxEditFieldLabel.Text = 'fmax';

            % Create fmaxEditField
            app.fmaxEditField = uieditfield(app.UIFigure, 'numeric');
            app.fmaxEditField.Position = [291 299 100 22];

            % Create MminEditFieldLabel
            app.MminEditFieldLabel = uilabel(app.UIFigure);
            app.MminEditFieldLabel.HorizontalAlignment = 'right';
            app.MminEditFieldLabel.Position = [40 267 35 22];
            app.MminEditFieldLabel.Text = 'Mmin';

            % Create MminEditField
            app.MminEditField = uieditfield(app.UIFigure, 'numeric');
            app.MminEditField.Position = [90 267 100 22];

            % Create MmaxEditFieldLabel
            app.MmaxEditFieldLabel = uilabel(app.UIFigure);
            app.MmaxEditFieldLabel.HorizontalAlignment = 'right';
            app.MmaxEditFieldLabel.Position = [238 267 38 22];
            app.MmaxEditFieldLabel.Text = 'Mmax';

            % Create MmaxEditField
            app.MmaxEditField = uieditfield(app.UIFigure, 'numeric');
            app.MmaxEditField.Position = [291 267 100 22];

            % Create ReloadfButton
            app.ReloadfButton = uibutton(app.UIFigure, 'push');
            app.ReloadfButton.ButtonPushedFcn = createCallbackFcn(app, @ReloadfButtonPushed, true);
            app.ReloadfButton.Position = [419 299 100 22];
            app.ReloadfButton.Text = 'Reload f';

            % Create ReloadmagButton
            app.ReloadmagButton = uibutton(app.UIFigure, 'push');
            app.ReloadmagButton.ButtonPushedFcn = createCallbackFcn(app, @ReloadmagButtonPushed, true);
            app.ReloadmagButton.Position = [419 267 100 22];
            app.ReloadmagButton.Text = 'Reload mag';

            % Create STFTButton
            app.STFTButton = uibutton(app.UIFigure, 'push');
            app.STFTButton.ButtonPushedFcn = createCallbackFcn(app, @STFTButtonPushed, true);
            app.STFTButton.Position = [209 193 100 22];
            app.STFTButton.Text = 'STFT';

            % Create LowCutSliderLabel
            app.LowCutSliderLabel = uilabel(app.UIFigure);
            app.LowCutSliderLabel.HorizontalAlignment = 'right';
            app.LowCutSliderLabel.Position = [54 151 50 22];
            app.LowCutSliderLabel.Text = 'Low Cut';

            % Create LowCutSlider
            app.LowCutSlider = uislider(app.UIFigure);
            app.LowCutSlider.Limits = [0 1000];
            app.LowCutSlider.Position = [125 160 445 3];

            % Create HighCutSliderLabel
            app.HighCutSliderLabel = uilabel(app.UIFigure);
            app.HighCutSliderLabel.HorizontalAlignment = 'right';
            app.HighCutSliderLabel.Position = [52 89 52 22];
            app.HighCutSliderLabel.Text = 'High Cut';

            % Create HighCutSlider
            app.HighCutSlider = uislider(app.UIFigure);
            app.HighCutSlider.Limits = [10000 1000000];
            app.HighCutSlider.Position = [125 98 445 3];
            app.HighCutSlider.Value = 10000;

            % Create LowEnable
            app.LowEnable = uicheckbox(app.UIFigure);
            app.LowEnable.Text = '';
            app.LowEnable.Position = [69 130 17 22];
            app.LowEnable.Value = true;

            % Create HighEnable
            app.HighEnable = uicheckbox(app.UIFigure);
            app.HighEnable.Text = '';
            app.HighEnable.Position = [72 68 19 22];

            % Create WindowfunctionDropDownLabel
            app.WindowfunctionDropDownLabel = uilabel(app.UIFigure);
            app.WindowfunctionDropDownLabel.HorizontalAlignment = 'right';
            app.WindowfunctionDropDownLabel.Position = [54 25 94 22];
            app.WindowfunctionDropDownLabel.Text = 'Window function';

            % Create WindowfunctionDropDown
            app.WindowfunctionDropDown = uidropdown(app.UIFigure);
            app.WindowfunctionDropDown.Items = {'No Window', 'Gaussian', 'Hamming'};
            app.WindowfunctionDropDown.Position = [163 25 100 22];
            app.WindowfunctionDropDown.Value = 'Hamming';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = tutorialApp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end