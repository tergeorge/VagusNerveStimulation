classdef FlatlineHeart_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        UIAxes                    matlab.ui.control.UIAxes
        Electrode1LampLabel       matlab.ui.control.Label
        Electrode1Lamp            matlab.ui.control.Lamp
        Electrode2LampLabel       matlab.ui.control.Label
        Electrode2Lamp            matlab.ui.control.Lamp
        UIAxes2                   matlab.ui.control.UIAxes
        UIAxes3                   matlab.ui.control.UIAxes
        StimulationButtonGroup    matlab.ui.container.ButtonGroup
        AutoButton                matlab.ui.control.ToggleButton
        Electrode1Button          matlab.ui.control.ToggleButton
        Electrode2Button          matlab.ui.control.ToggleButton
        V_threshmVEditFieldLabel  matlab.ui.control.Label
        V_threshmVEditField       matlab.ui.control.NumericEditField
        I_stimuAEditFieldLabel    matlab.ui.control.Label
        I_stimuAEditField         matlab.ui.control.NumericEditField
    end

    
    properties (Access = private)
       % Description
       I_stim
       dur
       dt
       no_nodes
       ipi
       pulse_width
       V_out
       time
       I
       mid_pt;
       ecg;
       V_thresh;
       ecg_time;
       t_instant;
    end
    
    methods (Access = private)
        
        function results = plot_AP1(app)
        cla(app.UIAxes2)
        hold(app.UIAxes2,'on')
        %plot(app.UIAxes2,len,app.V_out)
        plot(app.UIAxes2,app.time,app.V_out(:,app.mid_pt));
        %title(app.UIAxes2,'Action potential at center node');
        %xlabel(app.UIAxes2,'Time(ms)');
        %ylabel(app.UIAxes2,'Voltage (mV)');
            
        end
        
        function results = call_electrode1(app)
            app.V_out = electrod1_stim(app.I_stim,app.ipi,app.pulse_width,app.dur,app.dt);
        end
        
        
        function results = plot_AP2(app)
            cla(app.UIAxes3)
            hold(app.UIAxes3,'on')
            plot(app.UIAxes3,app.time,app.V_out(:,app.mid_pt));
            end
        
        function results = call_electrode2(app)
            app.V_out = electrod2_stim(app.I_stim,app.ipi,app.pulse_width,app.dur,app.dt);
        end
        
        function results = plot_ECG(app)
            cla(app.UIAxes)
            hold(app.UIAxes,'on')
            h = animatedline(app.UIAxes);
            x = app.ecg_time;
            for k = 1:length(app.ecg)
                y = app.ecg(:,k);
                addpoints(h,x(:,k),y);drawnow;
                if(k<101)
                    axis(app.UIAxes,[x(:,1) x(:,100) 0 3]);drawnow
                else
                    axis(app.UIAxes,[x(:,k-50) x(:,k+100) 0 3]);drawnow
                end
                app.t_instant = app.t_instant+1;
            end
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.I_stim = app.I_stimuAEditField.Value;
            app.dur = 10;
            app.pulse_width = 500;
            app.ipi = 100;
            app.dt=0.001;
            app.no_nodes = 101;
            app.mid_pt = 51;
            app.time = (0:10000);
            app.ecg_time = (0:0.01:1000)
            V_threshmVEditFieldValueChanged(app);
            I_stimuAEditFieldValueChanged(app);
            app.ecg = get_ecg(app.ecg_time,app.V_thresh,10);
            app.t_instant = 1;
            app.I = I_input(app.I_stim,app.dur,app.dt,app.ipi,app.pulse_width);
            app.Electrode1Lamp.Enable = 'off';
            app.Electrode2Lamp.Enable = 'off';
            plot_ECG(app)
        end

        % Selection changed function: StimulationButtonGroup
        function StimulationButtonGroupSelectionChanged(app, event)
            selectedButton = app.StimulationButtonGroup.SelectedObject;
            if (selectedButton.Text == 'Electrode-1')
                app.Electrode1Lamp.Enable = 'on';
                app.Electrode2Lamp.Enable = 'off';
                cla(app.UIAxes3)
                V_threshmVEditFieldValueChanged(app);
                I_stimuAEditFieldValueChanged(app);
                call_electrode1(app);
                %V = load('Vtot_elec1.mat');
                %app.V_out = V.V_tot;
                plot_AP1(app);
                V_max = max(app.V_out,[],'all');
                tim_stim = (0:120);
                if(V_max>app.V_thresh)
                   ecg_stim = get_ecg(tim_stim,app.V_thresh,V_max);
                   app.ecg(app.t_instant:app.t_instant+length(tim_stim)-1) = ecg_stim;
                   %plot_ECG(app);
                end
            end
            if (selectedButton.Text == 'Electrode-2')
                app.Electrode2Lamp.Enable = 'on';
                cla(app.UIAxes2)
                app.Electrode1Lamp.Enable = 'off';
                V_threshmVEditFieldValueChanged(app);
                I_stimuAEditFieldValueChanged(app);
                %V = load('Vtot_elec2.mat');
                %app.V_out = V.V_tot;
                call_electrode2(app);x
                %plot_AP2(app);
                V_max = max(app.V_out,[],'all');
                tim_stim = (0:120);
                if(V_max>app.V_thresh)
                   ecg_stim = get_ecg(tim_stim,app.V_thresh,V_max);
                   app.ecg(app.t_instant:app.t_instant+length(tim_stim)-1) = ecg_stim;
                   %plot_ECG(app);
                end
            end
%             if (selectedButton.Text == 'Auto')
%                 cla(app.UIAxes2)
%                 cla(app.UIAxes3)
%             end
        end

        % Value changed function: V_threshmVEditField
        function V_threshmVEditFieldValueChanged(app, event)
            app.V_thresh = app.V_threshmVEditField.Value;
        end

        % Value changed function: I_stimuAEditField
        function I_stimuAEditFieldValueChanged(app, event)
            app.I_stim = app.I_stimuAEditField.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'ECG')
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, 'Voltage (ms)')
            app.UIAxes.Position = [276 234 339 224];

            % Create Electrode1LampLabel
            app.Electrode1LampLabel = uilabel(app.UIFigure);
            app.Electrode1LampLabel.HorizontalAlignment = 'right';
            app.Electrode1LampLabel.Position = [312 79 67 22];
            app.Electrode1LampLabel.Text = 'Electrode-1';

            % Create Electrode1Lamp
            app.Electrode1Lamp = uilamp(app.UIFigure);
            app.Electrode1Lamp.Position = [394 79 20 20];

            % Create Electrode2LampLabel
            app.Electrode2LampLabel = uilabel(app.UIFigure);
            app.Electrode2LampLabel.HorizontalAlignment = 'right';
            app.Electrode2LampLabel.Position = [469 78 67 22];
            app.Electrode2LampLabel.Text = 'Electrode-2';

            % Create Electrode2Lamp
            app.Electrode2Lamp = uilamp(app.UIFigure);
            app.Electrode2Lamp.Position = [551 78 20 20];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Electrode-1 AP')
            xlabel(app.UIAxes2, 'Time')
            ylabel(app.UIAxes2, 'Voltage (ms)')
            app.UIAxes2.Position = [264 100 163 131];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'Electrode-2 AP')
            xlabel(app.UIAxes3, 'Time')
            ylabel(app.UIAxes3, 'Voltage (ms)')
            app.UIAxes3.Position = [426 100 160 127];

            % Create StimulationButtonGroup
            app.StimulationButtonGroup = uibuttongroup(app.UIFigure);
            app.StimulationButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @StimulationButtonGroupSelectionChanged, true);
            app.StimulationButtonGroup.Title = 'Stimulation';
            app.StimulationButtonGroup.Position = [30 129 123 106];

            % Create AutoButton
            app.AutoButton = uitogglebutton(app.StimulationButtonGroup);
            app.AutoButton.Text = 'Auto';
            app.AutoButton.Position = [11 53 100 22];
            app.AutoButton.Value = true;

            % Create Electrode1Button
            app.Electrode1Button = uitogglebutton(app.StimulationButtonGroup);
            app.Electrode1Button.Text = 'Electrode-1';
            app.Electrode1Button.Position = [11 32 100 22];

            % Create Electrode2Button
            app.Electrode2Button = uitogglebutton(app.StimulationButtonGroup);
            app.Electrode2Button.Text = 'Electrode-2';
            app.Electrode2Button.Position = [11 11 100 22];

            % Create V_threshmVEditFieldLabel
            app.V_threshmVEditFieldLabel = uilabel(app.UIFigure);
            app.V_threshmVEditFieldLabel.HorizontalAlignment = 'right';
            app.V_threshmVEditFieldLabel.Position = [10 343 83 22];
            app.V_threshmVEditFieldLabel.Text = 'V_thresh (mV)';

            % Create V_threshmVEditField
            app.V_threshmVEditField = uieditfield(app.UIFigure, 'numeric');
            app.V_threshmVEditField.ValueChangedFcn = createCallbackFcn(app, @V_threshmVEditFieldValueChanged, true);
            app.V_threshmVEditField.Position = [108 343 100 22];
            app.V_threshmVEditField.Value = 80;

            % Create I_stimuAEditFieldLabel
            app.I_stimuAEditFieldLabel = uilabel(app.UIFigure);
            app.I_stimuAEditFieldLabel.HorizontalAlignment = 'right';
            app.I_stimuAEditFieldLabel.Position = [30 304 63 22];
            app.I_stimuAEditFieldLabel.Text = 'I_stim (uA)';

            % Create I_stimuAEditField
            app.I_stimuAEditField = uieditfield(app.UIFigure, 'numeric');
            app.I_stimuAEditField.ValueChangedFcn = createCallbackFcn(app, @I_stimuAEditFieldValueChanged, true);
            app.I_stimuAEditField.Position = [108 304 100 22];
            app.I_stimuAEditField.Value = -500;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = FlatlineHeart_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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