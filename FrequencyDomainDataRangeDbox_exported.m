classdef FrequencyDomainDataRangeDbox_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        SetrangeoffrequencydomaindataLabel  matlab.ui.control.Label
        xminHzLabel            matlab.ui.control.Label
        xminEditField          matlab.ui.control.EditField
        yminampEditFieldLabel  matlab.ui.control.Label
        yminEditField          matlab.ui.control.EditField
        xmaxHzLabel            matlab.ui.control.Label
        xmaxEditField          matlab.ui.control.EditField
        ymaxampLabel           matlab.ui.control.Label
        ymaxEditField          matlab.ui.control.EditField
        yApplyButton           matlab.ui.control.Button
        xApplyButton           matlab.ui.control.Button
        xAutoButton            matlab.ui.control.Button
        yAutoButton            matlab.ui.control.Button
    end

    
    properties (Access = private)
        mainApp % Description
        xMin
        xMax
        yMin
        yMax
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            app.mainApp = mainapp;
        end

        % Button pushed function: xAutoButton
        function xAutoButtonPushed(app, event)
            xlim(app.mainApp.FFTAxes, [-inf inf]);
        end

        % Button pushed function: yAutoButton
        function yAutoButtonPushed(app, event)
            ylim(app.mainApp.FFTAxes, [-inf inf]);
        end

        % Button pushed function: xApplyButton
        function xApplyButtonPushed(app, event)
            app.xMin = str2double(app.xminEditField.Value);
            app.xMax = str2double(app.xmaxEditField.Value);
            xlim(app.mainApp.FFTAxes, [app.xMin, app.xMax]);
        end

        % Button pushed function: yApplyButton
        function yApplyButtonPushed(app, event)
            app.yMin = str2double(app.yminEditField.Value);
            app.yMax = str2double(app.ymaxEditField.Value);
            ylim(app.mainApp.FFTAxes, [app.yMin, app.yMax]);
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            app.mainApp.FrequencyDomainDataRangeMenu.Enable = 'on';
            delete(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 480 132];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create SetrangeoffrequencydomaindataLabel
            app.SetrangeoffrequencydomaindataLabel = uilabel(app.UIFigure);
            app.SetrangeoffrequencydomaindataLabel.HorizontalAlignment = 'center';
            app.SetrangeoffrequencydomaindataLabel.Position = [1 111 480 22];
            app.SetrangeoffrequencydomaindataLabel.Text = 'Set range of frequency domain data';

            % Create xminHzLabel
            app.xminHzLabel = uilabel(app.UIFigure);
            app.xminHzLabel.HorizontalAlignment = 'right';
            app.xminHzLabel.Position = [11 72 57 22];
            app.xminHzLabel.Text = 'xmin (Hz)';

            % Create xminEditField
            app.xminEditField = uieditfield(app.UIFigure, 'text');
            app.xminEditField.Position = [83 72 68 22];

            % Create yminampEditFieldLabel
            app.yminampEditFieldLabel = uilabel(app.UIFigure);
            app.yminampEditFieldLabel.HorizontalAlignment = 'right';
            app.yminampEditFieldLabel.Position = [2 42 66 22];
            app.yminampEditFieldLabel.Text = 'ymin (amp)';

            % Create yminEditField
            app.yminEditField = uieditfield(app.UIFigure, 'text');
            app.yminEditField.Position = [83 42 68 22];

            % Create xmaxHzLabel
            app.xmaxHzLabel = uilabel(app.UIFigure);
            app.xmaxHzLabel.HorizontalAlignment = 'right';
            app.xmaxHzLabel.Position = [163 72 60 22];
            app.xmaxHzLabel.Text = 'xmax (Hz)';

            % Create xmaxEditField
            app.xmaxEditField = uieditfield(app.UIFigure, 'text');
            app.xmaxEditField.Position = [238 72 68 22];

            % Create ymaxampLabel
            app.ymaxampLabel = uilabel(app.UIFigure);
            app.ymaxampLabel.HorizontalAlignment = 'right';
            app.ymaxampLabel.Position = [154 42 69 22];
            app.ymaxampLabel.Text = 'ymax (amp)';

            % Create ymaxEditField
            app.ymaxEditField = uieditfield(app.UIFigure, 'text');
            app.ymaxEditField.Position = [238 42 68 22];

            % Create yApplyButton
            app.yApplyButton = uibutton(app.UIFigure, 'push');
            app.yApplyButton.ButtonPushedFcn = createCallbackFcn(app, @yApplyButtonPushed, true);
            app.yApplyButton.Position = [317 42 67 22];
            app.yApplyButton.Text = 'Apply';

            % Create xApplyButton
            app.xApplyButton = uibutton(app.UIFigure, 'push');
            app.xApplyButton.ButtonPushedFcn = createCallbackFcn(app, @xApplyButtonPushed, true);
            app.xApplyButton.Position = [317 72 67 22];
            app.xApplyButton.Text = 'Apply';

            % Create xAutoButton
            app.xAutoButton = uibutton(app.UIFigure, 'push');
            app.xAutoButton.ButtonPushedFcn = createCallbackFcn(app, @xAutoButtonPushed, true);
            app.xAutoButton.Position = [400 72 67 22];
            app.xAutoButton.Text = 'Auto';

            % Create yAutoButton
            app.yAutoButton = uibutton(app.UIFigure, 'push');
            app.yAutoButton.ButtonPushedFcn = createCallbackFcn(app, @yAutoButtonPushed, true);
            app.yAutoButton.Position = [400 42 67 22];
            app.yAutoButton.Text = 'Auto';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = FrequencyDomainDataRangeDbox_exported(varargin)

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