classdef HighPassFilterDbox_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        HighPassFilteringLabel  matlab.ui.control.Label
        ThresholdHzLabel        matlab.ui.control.Label
        thresholdEditField      matlab.ui.control.EditField
        xApplyButton            matlab.ui.control.Button
    end

    
    properties (Access = private)
        mainApp % Description
        threshold
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            app.mainApp = mainapp;
        end

        % Button pushed function: xApplyButton
        function xApplyButtonPushed(app, event)
            app.threshold = str2double(app.thresholdEditField.Value);
            filterHighPass(app.mainApp, app.threshold);
            
            delete(app);
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            app.mainApp.HighPassFilterMenu.Enable = 'on';
            delete(app)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 340 78];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create HighPassFilteringLabel
            app.HighPassFilteringLabel = uilabel(app.UIFigure);
            app.HighPassFilteringLabel.HorizontalAlignment = 'center';
            app.HighPassFilteringLabel.Position = [1 57 340 22];
            app.HighPassFilteringLabel.Text = 'High Pass Filtering';

            % Create ThresholdHzLabel
            app.ThresholdHzLabel = uilabel(app.UIFigure);
            app.ThresholdHzLabel.HorizontalAlignment = 'right';
            app.ThresholdHzLabel.Position = [43 18 85 22];
            app.ThresholdHzLabel.Text = 'Threshold (Hz)';

            % Create thresholdEditField
            app.thresholdEditField = uieditfield(app.UIFigure, 'text');
            app.thresholdEditField.Position = [143 18 68 22];

            % Create xApplyButton
            app.xApplyButton = uibutton(app.UIFigure, 'push');
            app.xApplyButton.ButtonPushedFcn = createCallbackFcn(app, @xApplyButtonPushed, true);
            app.xApplyButton.Position = [247 18 67 22];
            app.xApplyButton.Text = 'Apply';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HighPassFilterDbox_exported(varargin)

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