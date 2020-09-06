classdef BandPassFilterDbox_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        LowPassFilteringLabel   matlab.ui.control.Label
        ThresholdHighHzLabel    matlab.ui.control.Label
        thresholdHighEditField  matlab.ui.control.EditField
        xApplyButton            matlab.ui.control.Button
        ThresholdLowHzLabel     matlab.ui.control.Label
        thresholdLowEditField   matlab.ui.control.EditField
    end

    
    properties (Access = private)
        mainApp % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            app.mainApp = mainapp;
        end

        % Button pushed function: xApplyButton
        function xApplyButtonPushed(app, event)
            h = str2double(app.thresholdHighEditField.Value);
            l = str2double(app.thresholdLowEditField.Value);
            filterBandPass(app.mainApp, l, h);
            delete(app);
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            app.mainApp.BandPassFilterMenu.Enable = 'on';
            delete(app)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 340 103];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create LowPassFilteringLabel
            app.LowPassFilteringLabel = uilabel(app.UIFigure);
            app.LowPassFilteringLabel.HorizontalAlignment = 'center';
            app.LowPassFilteringLabel.Position = [1 82 340 22];
            app.LowPassFilteringLabel.Text = 'Low Pass Filtering';

            % Create ThresholdHighHzLabel
            app.ThresholdHighHzLabel = uilabel(app.UIFigure);
            app.ThresholdHighHzLabel.HorizontalAlignment = 'right';
            app.ThresholdHighHzLabel.Position = [15 43 113 22];
            app.ThresholdHighHzLabel.Text = 'Threshold High (Hz)';

            % Create thresholdHighEditField
            app.thresholdHighEditField = uieditfield(app.UIFigure, 'text');
            app.thresholdHighEditField.Position = [143 43 68 22];

            % Create xApplyButton
            app.xApplyButton = uibutton(app.UIFigure, 'push');
            app.xApplyButton.ButtonPushedFcn = createCallbackFcn(app, @xApplyButtonPushed, true);
            app.xApplyButton.Position = [247 43 67 22];
            app.xApplyButton.Text = 'Apply';

            % Create ThresholdLowHzLabel
            app.ThresholdLowHzLabel = uilabel(app.UIFigure);
            app.ThresholdLowHzLabel.HorizontalAlignment = 'right';
            app.ThresholdLowHzLabel.Position = [18 12 110 22];
            app.ThresholdLowHzLabel.Text = 'Threshold Low (Hz)';

            % Create thresholdLowEditField
            app.thresholdLowEditField = uieditfield(app.UIFigure, 'text');
            app.thresholdLowEditField.Position = [143 12 68 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = BandPassFilterDbox_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

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