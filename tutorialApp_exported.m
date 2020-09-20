classdef tutorialApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        FileMenu                        matlab.ui.container.Menu
        OpenFileMenu                    matlab.ui.container.Menu
        SaveTimeDomainFileMenu          matlab.ui.container.Menu
        SaveFrequencyDomainFileMenu     matlab.ui.container.Menu
        CloseFileMenu                   matlab.ui.container.Menu
        ExportMenu                      matlab.ui.container.Menu
        EditMenu                        matlab.ui.container.Menu
        RangeMenu                       matlab.ui.container.Menu
        TimeDomainDataRangeMenu         matlab.ui.container.Menu
        FrequencyDomainDataRangeMenu    matlab.ui.container.Menu
        ScaleMenu                       matlab.ui.container.Menu
        TimeDomainDataScaleMenu         matlab.ui.container.Menu
        LinearScaleMenuTimeDomain       matlab.ui.container.Menu
        LogScaleMenuTimeDomain          matlab.ui.container.Menu
        FrequencyDomainDataScaleMenu    matlab.ui.container.Menu
        LinearScaleMenuFrequencyDomain  matlab.ui.container.Menu
        LogScaleMenuFrequencyDomain     matlab.ui.container.Menu
        ToolsMenu                       matlab.ui.container.Menu
        ResetDataMenu                   matlab.ui.container.Menu
        FFTAnalysisMenu                 matlab.ui.container.Menu
        FilterMenu                      matlab.ui.container.Menu
        LowPassFilterMenu               matlab.ui.container.Menu
        HighPassFilterMenu              matlab.ui.container.Menu
        BandPassFilterMenu              matlab.ui.container.Menu
        WindowFunctionMenu              matlab.ui.container.Menu
        WindowHannMenu                  matlab.ui.container.Menu
        WindowGaussianMenu              matlab.ui.container.Menu
        WindowBlakmanMenu               matlab.ui.container.Menu
        WindowHammingMenu               matlab.ui.container.Menu
        WindowFlattopMenu               matlab.ui.container.Menu
        AveragingMenu                   matlab.ui.container.Menu
        FFTAxes                         matlab.ui.control.UIAxes
        Label                           matlab.ui.control.Label
        DataAxes                        matlab.ui.control.UIAxes
        ConsoleTextAreaLabel            matlab.ui.control.Label
        ConsoleTextArea                 matlab.ui.control.TextArea
        DataProcessedAxes               matlab.ui.control.UIAxes
        RefreshRawDataButton            matlab.ui.control.Button
        RefreshProcessedDataButton      matlab.ui.control.Button
        RefreshFFTDataButton            matlab.ui.control.Button
    end

    
    properties (Access = private)
        %% Dialog Box ÿÿ
        % TimeDomainDataRangeDlg: ÿÿÿ ÿÿÿ ÿÿÿ ÿ ÿÿÿ ÿÿÿÿ
        % FrequencyDomainDataRangeDlg: ÿÿÿÿ ÿÿÿ ÿÿÿ ÿ ÿÿÿ ÿÿÿÿ
        % LowPassFilterDlg: ÿÿÿÿ ÿÿ ÿÿÿ ÿÿ ÿÿÿÿ
        % HighPassFilterDlg: ÿÿÿÿ ÿÿ ÿÿÿ ÿÿ ÿÿÿÿ
        % BandPassFilterDlg: ÿÿÿÿ ÿÿ ÿÿÿ ÿÿ ÿÿÿÿ
        TimeDomainDataRangeDlg
        FrequencyDomainDataRangeDlg
        LowPassFilterDlg
        HighPassFilterDlg
        BandPassFilterDlg
        
        %% Private Member
        % audioFilePath: ÿÿÿ ÿÿ ÿÿ
        % audioFileName: ÿÿÿ ÿÿ ÿÿ
        % data_t: ÿÿÿ raw data
        % dataProcessed_t: ÿÿÿ ÿÿ ÿÿÿ (ÿÿÿ ÿÿÿ ÿÿ)
        % rms_t: rmsÿ
        % pk_t: ÿÿÿ
        % pk2pk_t: ÿÿÿ - ÿÿÿ
        % pk2rms_t: ÿÿÿÿ rmsÿÿ ÿÿ
        % data_f: FFTÿ ÿÿÿ ÿÿÿÿ ÿÿÿ (complex)
        % dataAbs_f: FFTÿ ÿÿÿ ÿÿÿÿ ÿÿÿ (absolute value)
        % Fs: ÿÿÿ ÿÿÿ
        % L: ÿÿ ÿÿ
        % f: ÿÿÿ ÿ
        % t: ÿÿ ÿ
        audioFilePath
        audioFileName
        data_t
        dataProcessed_t
        rms_t
        pk_t
        pk2pk_t
        pk2rms_t
        crest_t
        kurtosis_t
        data_f
        dataAbs_f
        pk_f
        pkfreq_f
        Fs
        L
        f
        t
        f_processed
        t_processed
    end
    
    properties (Access = public)
    end
    
    methods (Access = public)
        
        %% loadFile: ÿÿÿ ÿÿÿÿ ÿÿ ÿÿÿ ÿÿÿ ÿÿ ÿÿÿÿ ÿÿ
        function [filePath, fileName] = loadFile(app, fpath, fname)
            filePath = fpath;
            fileName = fname;
            app.audioFilePath = filePath;
            app.audioFileName = fileName;
            [app.data_t, app.Fs] = audioread(strcat(app.audioFilePath, app.audioFileName));
            app.data_t = reshape(app.data_t, [], 1);
            app.dataProcessed_t = app.data_t;
            sz = size(app.data_t);
            app.L = sz(1);
            T = 1 / app.Fs;
            app.t = (0:app.L - 1) * T;
            app.t = reshape(app.t, [], 1);
            app.f = app.Fs * (0:(app.L - 1)) / app.L;
            app.f = reshape(app.f, [], 1);
            
            app.pk_t = max(app.data_t);
            app.pk2pk_t = peak2peak(app.data_t);
            
            app.rms_t = rms(app.data_t);
            app.pk2rms_t = peak2rms(app.data_t);
            
            
            dispstr = sprintf('%s%s\nfile name: %s, sampling rate: %s, file length: %s', ...
                string(datetime), " File loaded", ...
                string(app.audioFileName), string(app.Fs), string(size(app.data_t)));
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
            dispstr = sprintf('%s: %f\n%s: %f\n%s: %f\n%s: %f\n', ...
                'peak', app.pk_t, ...
                'rms', app.rms_t, ...
                'peak to peak', app.pk2pk_t, ...
                'ratio of the peak and rms', app.pk2rms_t);
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
            
            plot(app.DataAxes, app.t, app.dataProcessed_t, "-k");
            
        end
        
        %% filterLowPass: Low pass filter ÿÿ
        function filterLowPass(app, hval)
            d = app.dataProcessed_t;
            app.dataProcessed_t = lowpass(d, hval, app.Fs);
            plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, "-k");
            app.LowPassFilterMenu.Enable = 'on';
            dispstr = sprintf('%s%s\nFrequency threshold: %f', ...
                string(datetime), " Low pass filter is applied", ...
                hval);
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end
        
        %% filterLowPass: High pass filter ÿÿ
        function filterHighPass(app, hval)
            d = app.dataProcessed_t;
            app.dataProcessed_t = highpass(d, hval, app.Fs);
            plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            app.HighPassFilterMenu.Enable = 'on';
            dispstr = sprintf('%s%s\nFrequency threshold: %f', ...
                string(datetime), " High pass filter is applied", ...
                hval);
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end
        
        %% filterLowPass: Band pass filter ÿÿ
        function filterBandPass(app, lval, hval)
            d = app.dataProcessed_t;
            app.dataProcessed_t = bandpass(d, [lval, hval], app.Fs);
            plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            app.BandPassFilterMenu.Enable = 'on';
            dispstr = sprintf('%s%s\nFrequency threshold: [%f  %f]', ...
                string(datetime), " Low pass filter is applied", ...
                lval, hval);
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Menu selected function: OpenFileMenu
        function OpenFileMenuSelected(app, event)
            app.OpenFileMenu.Enable = 'off';
            try
                [fname, fpath] = uigetfile({'*.wav;*.ogg;*.flac;*.au;*.aiff;*.aif;*.aifc;*.mp3;*.m4a;*.mp4', ...
                    'Audio Files(*.wav, *.ogg, *.flac, *.au, *.aiff, *.aif ,*.aifc ,*.mp3 ,*.m4a ,*.mp4)';
                    '*.*',  'All Files (*.*)'}, 'Select a File');
                loadFile(app, fpath, fname);
            catch ME
                errordlg(ME.identifier, 'File Open Error');
            end
            app.OpenFileMenu.Enable = 'on';
        end

        % Menu selected function: SaveTimeDomainFileMenu
        function SaveTimeDomainFileMenuSelected(app, event)
            app.SaveTimeDomainFileMenu.Enable = 'off';
            try
                [fname, fpath] = uiputfile({'*.wav;*.ogg;*.flac;*.au;*.aiff;*.aif;*.aifc;*.mp3;*.m4a;*.mp4', ...
                    'Audio Files(*.wav, *.ogg, *.flac, *.au, *.aiff, *.aif ,*.aifc ,*.mp3 ,*.m4a ,*.mp4)';
                    '*.*',  'All Files (*.*)'}, 'Select a File');
                s = strcat(fpath, fname);
                audiowrite(s, app.dataProcessed_t, app.Fs);
                dispstr = sprintf('%s%s\nfilename: %s\n', ...
                    string(datetime), " Processed time domain data is saved", ...
                    string(fname));
                app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                    app.ConsoleTextArea.Value);
            catch ME
                errordlg(ME.identifier, 'File Save Error');
            end
            app.SaveTimeDomainFileMenu.Enable = 'on';
        end

        % Menu selected function: SaveFrequencyDomainFileMenu
        function SaveFrequencyDomainFileMenuSelected(app, event)
            try
                [fname, fpath] = uiputfile({'*.mat', ...
                    'MAT file(*.mat)';
                    '*.*',  'All Files (*.*)'}, 'Select a File');
                s = strcat(fpath, fname);
                data = app.data_f;
                freq = app.f;
                sampling_rate = app.Fs;
                save(s, 'data', 'freq', 'sampling_rate');
            catch ME
                errordlg(ME.identifier, 'File Save Error');
            end
            dispstr = sprintf('%s%s\nfilename: %s\n', ...
                string(datetime), " Processed frequency domain data is saved", ...
                string(fname));
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Menu selected function: CloseFileMenu
        function CloseFileMenuSelected(app, event)
            try
                cla(app.DataAxes);
                cla(app.DataProcessedAxes);
                cla(app.FFTAxes);
                app.data_t = 0;
                app.dataProcessed_t = 0;
                app.data_f = 0;
                app.dataAbs_f = 0;
            catch ME
                errordlg(ME.identifier, 'File Close Error');
            end
            dispstr = sprintf('%s%s\n\n', ...
                string(datetime), " The file is closed and charts are cleared");
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Menu selected function: TimeDomainDataRangeMenu
        function TimeDomainDataRangeMenuSelected(app, event)
            app.TimeDomainDataRangeMenu.Enable = 'off';
            try
                app.TimeDomainDataRangeDlg = TimeDomainDataRangeDbox(app);
            catch ME
                errordlg(ME.identifier, 'Time Domain Range Set Error');
            end
        end

        % Menu selected function: FrequencyDomainDataRangeMenu
        function FrequencyDomainDataRangeMenuSelected(app, event)
            app.FrequencyDomainDataRangeMenu.Enable = 'off';
            try
                app.FrequencyDomainDataRangeDlg = FrequencyDomainDataRangeDbox(app);
            catch ME
                errordlg(ME.identifier, 'Frequency Domain Range Set Error');
            end
        end

        % Menu selected function: LinearScaleMenuTimeDomain
        function LinearScaleMenuTimeDomainSelected(app, event)
            try
                set(app.DataAxes, 'Yscale', 'linear');
                set(app.DataProcessedAxes, 'Yscale', 'linear');
            catch ME
                errordlg(ME.identifier, 'Time Domain Scaler Error');
            end
        end

        % Menu selected function: LogScaleMenuTimeDomain
        function LogScaleMenuTimeDomainSelected(app, event)
        try
            set(app.DataAxes, 'Yscale', 'log');
            set(app.DataProcessedAxes, 'Yscale', 'log');
        catch ME
            errordlg(ME.identifier, 'Time Domain Scaler Error');
        end
        
        end

        % Menu selected function: LinearScaleMenuFrequencyDomain
        function LinearScaleMenuFrequencyDomainSelected(app, event)
            try
                set(app.FFTAxes, 'Yscale', 'linear');
            catch ME
                errordlg(ME.identifier, 'Frequency Domain Scaler Error');
            end
            
        end

        % Menu selected function: LogScaleMenuFrequencyDomain
        function LogScaleMenuFrequencyDomainSelected(app, event)
            try
                set(app.FFTAxes, 'Yscale', 'log');
            catch ME
                errordlg(ME.identifier, 'Frequency Domain Scaler Error');
            end
        end

        % Menu selected function: ResetDataMenu
        function ResetDataMenuSelected(app, event)
            try
                app.dataProcessed_t = app.data_t;
                plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            catch ME
                errordlg(ME.identifier, 'Data Reset Error');
            end
            dispstr = sprintf('%s%s\n\n', ...
                string(datetime), " Processed data are reset");
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Menu selected function: FFTAnalysisMenu
        function FFTAnalysisMenuSelected(app, event)
            try
                app.data_f = fft(app.dataProcessed_t);
                app.data_f = reshape(app.data_f, [], 1);
                app.dataAbs_f = abs(app.data_f);
                app.pk_f = max(app.dataAbs_f);
                peakind = find(app.dataAbs_f == app.pk_f);
                peakind = peakind(1);
                app.pkfreq_f = app.f(peakind);
                plot(app.FFTAxes, app.f, app.dataAbs_f, '-k', app.pkfreq_f, app.pk_f, 'r*');
            catch ME
                errordlg(ME.identifier, 'FFT Analysis Error');
            end
            dispstr = sprintf('%s%s\n\n', ...
                string(datetime), " FFT Analysis Completed");
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
            dispstr = sprintf('%s: (%f, %f)', ...
                '(max frequency, amplitude) = ', app.pkfreq_f, app.pk_f);
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Menu selected function: WindowHannMenu
        function WindowHannMenuSelected(app, event)
            try
                w = hann(app.L);
                app.dataProcessed_t = app.dataProcessed_t .* w;
                plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            catch ME
                errordlg(ME.identifier, 'Window Function Error');
            end
            dispstr = sprintf('%s%s\n\n', ...
                string(datetime), " Hanning Window Function is applied");
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Menu selected function: WindowGaussianMenu
        function WindowGaussianMenuSelected(app, event)
            try
                w = gausswin(app.L);
                app.dataProcessed_t = app.dataProcessed_t .* w;
                plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            catch ME
                errordlg(ME.identifier, 'Window Function Error');
            end
            dispstr = sprintf('%s%s\n\n', ...
                string(datetime), " Gaussian Window Function is applied");
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Menu selected function: WindowHammingMenu
        function WindowHammingMenuSelected(app, event)
            try
                w = hamming(app.L);
                app.dataProcessed_t = app.dataProcessed_t .* w;
                plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            catch ME
                errordlg(ME.identifier, 'Window Function Error');
            end
            dispstr = sprintf('%s%s\n\n', ...
                string(datetime), " Hamming Window Function is applied");
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Menu selected function: WindowBlakmanMenu
        function WindowBlakmanMenuSelected(app, event)
            try
                w = blackman(app.L);
                app.dataProcessed_t = app.dataProcessed_t .* w;
                plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            catch ME
                errordlg(ME.identifier, 'Window Function Error');
            end
            dispstr = sprintf('%s%s\n\n', ...
                string(datetime), " Blackman Window Function is applied");
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Menu selected function: WindowFlattopMenu
        function WindowFlattopMenuSelected(app, event)
            try
                w = flattopwin(app.L);
                app.dataProcessed_t = app.dataProcessed_t .* w;
                plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            catch ME
                errordlg(ME.identifier, 'Window Function Error');
            end
            dispstr = sprintf('%s%s\n\n', ...
                string(datetime), " Flat top Window Function is applied");
            app.ConsoleTextArea.Value = vertcat(cellstr(dispstr), ...
                app.ConsoleTextArea.Value);
        end

        % Button pushed function: RefreshRawDataButton
        function RefreshRawDataButtonPushed(app, event)
            app.TimeDomainDataRangeMenu.Enable = 'on';
            plot(app.DataAxes, app.t, app.data_t, '-k');
            xlim(app.DataAxes, [-inf inf]);
            ylim(app.DataAxes, [-inf inf]);
        end

        % Button pushed function: RefreshProcessedDataButton
        function RefreshProcessedDataButtonPushed(app, event)
            app.TimeDomainDataRangeMenu.Enable = 'on';
            plot(app.DataProcessedAxes, app.t, app.dataProcessed_t, '-k');
            xlim(app.DataProcessedAxes, [-inf inf]);
            ylim(app.DataProcessedAxes, [-inf inf]);
        end

        % Button pushed function: RefreshFFTDataButton
        function RefreshFFTDataButtonPushed(app, event)
            app.FrequencyDomainDataRangeMenu.Enable = 'on';
            plot(app.FFTAxes, app.t, app.dataAbs_f, '-k');
            xlim(app.FFTAxes, [-inf inf]);
            ylim(app.FFTAxes, [-inf inf]);
        end

        % Menu selected function: LowPassFilterMenu
        function LowPassFilterMenuSelected(app, event)
            app.LowPassFilterMenu.Enable = 'off';
            try
                app.LowPassFilterDlg = LowPassFilterDbox(app);
            catch ME
                
            end
        end

        % Menu selected function: HighPassFilterMenu
        function HighPassFilterMenuSelected(app, event)
            app.HighPassFilterMenu.Enable = 'off';
            try
                app.HighPassFilterDlg = HighPassFilterDbox(app);
            catch ME
                errordlg(ME.identifier, 'High Pass Filter Error');
            end
        end

        % Menu selected function: BandPassFilterMenu
        function BandPassFilterMenuSelected(app, event)
            app.BandPassFilterMenu.Enable = 'off';
            try
                app.BandPassFilterDlg = BandPassFilterDbox(app);
            catch ME
                errordlg(ME.identifier, 'Band Pass Filter Error');
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 622 896];
            app.UIFigure.Name = 'UI Figure';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Text = 'File';

            % Create OpenFileMenu
            app.OpenFileMenu = uimenu(app.FileMenu);
            app.OpenFileMenu.MenuSelectedFcn = createCallbackFcn(app, @OpenFileMenuSelected, true);
            app.OpenFileMenu.Text = 'Open File';

            % Create SaveTimeDomainFileMenu
            app.SaveTimeDomainFileMenu = uimenu(app.FileMenu);
            app.SaveTimeDomainFileMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveTimeDomainFileMenuSelected, true);
            app.SaveTimeDomainFileMenu.Text = 'Save Time Domain File';

            % Create SaveFrequencyDomainFileMenu
            app.SaveFrequencyDomainFileMenu = uimenu(app.FileMenu);
            app.SaveFrequencyDomainFileMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveFrequencyDomainFileMenuSelected, true);
            app.SaveFrequencyDomainFileMenu.Text = 'Save Frequency Domain File';

            % Create CloseFileMenu
            app.CloseFileMenu = uimenu(app.FileMenu);
            app.CloseFileMenu.MenuSelectedFcn = createCallbackFcn(app, @CloseFileMenuSelected, true);
            app.CloseFileMenu.Text = 'Close File';

            % Create ExportMenu
            app.ExportMenu = uimenu(app.FileMenu);
            app.ExportMenu.Text = 'Export';

            % Create EditMenu
            app.EditMenu = uimenu(app.UIFigure);
            app.EditMenu.Text = 'Edit';

            % Create RangeMenu
            app.RangeMenu = uimenu(app.EditMenu);
            app.RangeMenu.Text = 'Range';

            % Create TimeDomainDataRangeMenu
            app.TimeDomainDataRangeMenu = uimenu(app.RangeMenu);
            app.TimeDomainDataRangeMenu.MenuSelectedFcn = createCallbackFcn(app, @TimeDomainDataRangeMenuSelected, true);
            app.TimeDomainDataRangeMenu.Text = 'Time Domain Data';

            % Create FrequencyDomainDataRangeMenu
            app.FrequencyDomainDataRangeMenu = uimenu(app.RangeMenu);
            app.FrequencyDomainDataRangeMenu.MenuSelectedFcn = createCallbackFcn(app, @FrequencyDomainDataRangeMenuSelected, true);
            app.FrequencyDomainDataRangeMenu.Text = 'Frequency Domain Data';

            % Create ScaleMenu
            app.ScaleMenu = uimenu(app.EditMenu);
            app.ScaleMenu.Text = 'Scale';

            % Create TimeDomainDataScaleMenu
            app.TimeDomainDataScaleMenu = uimenu(app.ScaleMenu);
            app.TimeDomainDataScaleMenu.Text = 'Time Domain Data';

            % Create LinearScaleMenuTimeDomain
            app.LinearScaleMenuTimeDomain = uimenu(app.TimeDomainDataScaleMenu);
            app.LinearScaleMenuTimeDomain.MenuSelectedFcn = createCallbackFcn(app, @LinearScaleMenuTimeDomainSelected, true);
            app.LinearScaleMenuTimeDomain.Text = 'Linear Scale';

            % Create LogScaleMenuTimeDomain
            app.LogScaleMenuTimeDomain = uimenu(app.TimeDomainDataScaleMenu);
            app.LogScaleMenuTimeDomain.MenuSelectedFcn = createCallbackFcn(app, @LogScaleMenuTimeDomainSelected, true);
            app.LogScaleMenuTimeDomain.Text = 'Log Scale';

            % Create FrequencyDomainDataScaleMenu
            app.FrequencyDomainDataScaleMenu = uimenu(app.ScaleMenu);
            app.FrequencyDomainDataScaleMenu.Text = 'Frequency Domain Data';

            % Create LinearScaleMenuFrequencyDomain
            app.LinearScaleMenuFrequencyDomain = uimenu(app.FrequencyDomainDataScaleMenu);
            app.LinearScaleMenuFrequencyDomain.MenuSelectedFcn = createCallbackFcn(app, @LinearScaleMenuFrequencyDomainSelected, true);
            app.LinearScaleMenuFrequencyDomain.Text = 'Linear Scale';

            % Create LogScaleMenuFrequencyDomain
            app.LogScaleMenuFrequencyDomain = uimenu(app.FrequencyDomainDataScaleMenu);
            app.LogScaleMenuFrequencyDomain.MenuSelectedFcn = createCallbackFcn(app, @LogScaleMenuFrequencyDomainSelected, true);
            app.LogScaleMenuFrequencyDomain.Text = 'Log Scale';

            % Create ToolsMenu
            app.ToolsMenu = uimenu(app.UIFigure);
            app.ToolsMenu.Text = 'Tools';

            % Create ResetDataMenu
            app.ResetDataMenu = uimenu(app.ToolsMenu);
            app.ResetDataMenu.MenuSelectedFcn = createCallbackFcn(app, @ResetDataMenuSelected, true);
            app.ResetDataMenu.Text = 'Reset Data';

            % Create FFTAnalysisMenu
            app.FFTAnalysisMenu = uimenu(app.ToolsMenu);
            app.FFTAnalysisMenu.MenuSelectedFcn = createCallbackFcn(app, @FFTAnalysisMenuSelected, true);
            app.FFTAnalysisMenu.Text = 'FFT Analysis';

            % Create FilterMenu
            app.FilterMenu = uimenu(app.ToolsMenu);
            app.FilterMenu.Text = 'Filter';

            % Create LowPassFilterMenu
            app.LowPassFilterMenu = uimenu(app.FilterMenu);
            app.LowPassFilterMenu.MenuSelectedFcn = createCallbackFcn(app, @LowPassFilterMenuSelected, true);
            app.LowPassFilterMenu.Text = 'Low Pass Filter';

            % Create HighPassFilterMenu
            app.HighPassFilterMenu = uimenu(app.FilterMenu);
            app.HighPassFilterMenu.MenuSelectedFcn = createCallbackFcn(app, @HighPassFilterMenuSelected, true);
            app.HighPassFilterMenu.Text = 'High Pass Filter';

            % Create BandPassFilterMenu
            app.BandPassFilterMenu = uimenu(app.FilterMenu);
            app.BandPassFilterMenu.MenuSelectedFcn = createCallbackFcn(app, @BandPassFilterMenuSelected, true);
            app.BandPassFilterMenu.Text = 'Band Pass Filter';

            % Create WindowFunctionMenu
            app.WindowFunctionMenu = uimenu(app.ToolsMenu);
            app.WindowFunctionMenu.Text = 'Window Function';

            % Create WindowHannMenu
            app.WindowHannMenu = uimenu(app.WindowFunctionMenu);
            app.WindowHannMenu.MenuSelectedFcn = createCallbackFcn(app, @WindowHannMenuSelected, true);
            app.WindowHannMenu.Text = 'Hannning';

            % Create WindowGaussianMenu
            app.WindowGaussianMenu = uimenu(app.WindowFunctionMenu);
            app.WindowGaussianMenu.MenuSelectedFcn = createCallbackFcn(app, @WindowGaussianMenuSelected, true);
            app.WindowGaussianMenu.Text = 'Gaussian';

            % Create WindowBlakmanMenu
            app.WindowBlakmanMenu = uimenu(app.WindowFunctionMenu);
            app.WindowBlakmanMenu.MenuSelectedFcn = createCallbackFcn(app, @WindowBlakmanMenuSelected, true);
            app.WindowBlakmanMenu.Text = 'Blackman';

            % Create WindowHammingMenu
            app.WindowHammingMenu = uimenu(app.WindowFunctionMenu);
            app.WindowHammingMenu.MenuSelectedFcn = createCallbackFcn(app, @WindowHammingMenuSelected, true);
            app.WindowHammingMenu.Text = 'Hamming';

            % Create WindowFlattopMenu
            app.WindowFlattopMenu = uimenu(app.WindowFunctionMenu);
            app.WindowFlattopMenu.MenuSelectedFcn = createCallbackFcn(app, @WindowFlattopMenuSelected, true);
            app.WindowFlattopMenu.Text = 'Flat top';

            % Create AveragingMenu
            app.AveragingMenu = uimenu(app.ToolsMenu);
            app.AveragingMenu.Text = 'Averaging';

            % Create FFTAxes
            app.FFTAxes = uiaxes(app.UIFigure);
            title(app.FFTAxes, 'FFT Result')
            xlabel(app.FFTAxes, 'Frequency (Hz)')
            ylabel(app.FFTAxes, 'Amplitude')
            app.FFTAxes.TitleFontWeight = 'bold';
            app.FFTAxes.Position = [34 193 562 217];

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [456 67 10 22];
            app.Label.Text = '';

            % Create DataAxes
            app.DataAxes = uiaxes(app.UIFigure);
            title(app.DataAxes, 'Raw Data')
            xlabel(app.DataAxes, 'Time (s)')
            ylabel(app.DataAxes, 'Amplitude')
            app.DataAxes.TitleFontWeight = 'bold';
            app.DataAxes.Position = [33 641 565 222];

            % Create ConsoleTextAreaLabel
            app.ConsoleTextAreaLabel = uilabel(app.UIFigure);
            app.ConsoleTextAreaLabel.HorizontalAlignment = 'right';
            app.ConsoleTextAreaLabel.Position = [34 143 50 22];
            app.ConsoleTextAreaLabel.Text = 'Console';

            % Create ConsoleTextArea
            app.ConsoleTextArea = uitextarea(app.UIFigure);
            app.ConsoleTextArea.Editable = 'off';
            app.ConsoleTextArea.Position = [99 18 497 149];

            % Create DataProcessedAxes
            app.DataProcessedAxes = uiaxes(app.UIFigure);
            title(app.DataProcessedAxes, 'Processed Data')
            xlabel(app.DataProcessedAxes, 'Time(s)')
            ylabel(app.DataProcessedAxes, 'Amplitude')
            app.DataProcessedAxes.TitleFontWeight = 'bold';
            app.DataProcessedAxes.Position = [34 420 564 222];

            % Create RefreshRawDataButton
            app.RefreshRawDataButton = uibutton(app.UIFigure, 'push');
            app.RefreshRawDataButton.ButtonPushedFcn = createCallbackFcn(app, @RefreshRawDataButtonPushed, true);
            app.RefreshRawDataButton.Position = [390 850 84 22];
            app.RefreshRawDataButton.Text = 'Refresh';

            % Create RefreshProcessedDataButton
            app.RefreshProcessedDataButton = uibutton(app.UIFigure, 'push');
            app.RefreshProcessedDataButton.ButtonPushedFcn = createCallbackFcn(app, @RefreshProcessedDataButtonPushed, true);
            app.RefreshProcessedDataButton.Position = [390 630 84 22];
            app.RefreshProcessedDataButton.Text = 'Refresh';

            % Create RefreshFFTDataButton
            app.RefreshFFTDataButton = uibutton(app.UIFigure, 'push');
            app.RefreshFFTDataButton.ButtonPushedFcn = createCallbackFcn(app, @RefreshFFTDataButtonPushed, true);
            app.RefreshFFTDataButton.Position = [390 398 84 22];
            app.RefreshFFTDataButton.Text = 'Refresh';

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