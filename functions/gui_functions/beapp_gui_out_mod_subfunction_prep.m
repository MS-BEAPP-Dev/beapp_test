function [out_mod_button_list,out_mod_button_geometry,out_mod_ver_geometry,skipline_panel,...
    adv_out_mod_button_list,adv_out_mod_button_geometry,adv_out_mod_ver_geometry] =...
    beapp_gui_out_mod_subfunction_prep (current_sub_panel,grp_proc_info)

% spacer for formatting in supergui
extra_space_line = {{'style','text','string',''}};

switch current_sub_panel
    case 'out_mod_general'
        
        empty_10_cell = cell(10,1);
        empty_10_cell(:) = deal({''});
        
        out_mod_inds = find(ismember(grp_proc_info.beapp_toggle_mods.Module_Output_Type,'out')|ismember(grp_proc_info.beapp_toggle_mods.Module_Output_Type,'psd'));
        bw_names = empty_10_cell;
        bw_low_freqs = NaN(10,1);
        bw_high_freqs = NaN(10,1);
        
        bw_names(1:length(grp_proc_info.bw_name),1) = grp_proc_info.bw_name';
        bw_low_freqs(1:length(grp_proc_info.bw_name),1) = grp_proc_info.bw(:,1);
        bw_high_freqs(1:length(grp_proc_info.bw_name),1) = grp_proc_info.bw(:,2);
        
        % create display string based on total frequencies that currently
        % exist
        disp_str_total_freqs = beapp_arr_to_colon_note_string (grp_proc_info.bw_total_freqs);
        
        out_mod_button_list = [{{'style','text','string', 'General Output Module Settings:'}},...
            {{'style','text','string', 'Select Modules to Run Below:'}},...
            {{'style','uitable','data', [grp_proc_info.beapp_toggle_mods.Mod_Names(out_mod_inds),...
            num2cell(grp_proc_info.beapp_toggle_mods.Module_On(out_mod_inds)), ...
            num2cell(grp_proc_info.beapp_toggle_mods.Module_Export_On(out_mod_inds))],'tag','out_mod_sel_table',...
            'ColumnEditable',[false,true,true], 'ColumnName',{'Module','Module On?','Save Module Outputs?'}}}...
            extra_space_line,...
            {{'style','text','string', 'Bandwidth information:'}},...
            {{'style','uitable','data', [bw_names num2cell(bw_low_freqs) num2cell(bw_high_freqs)], 'ColumnEditable',[true,true,true],...
            'ColumnName',{'Band Name', 'Band Low Frequency Bound','Band High Frequency Bound'},...
            'ColumnFormat',{'char','numeric','numeric'},'tag','out_mod_band_table'}},...
            extra_space_line,...
            {{'style','text','string', sprintf(['Frequencies to use in total power (for normalization). Separate ranges with commas' ,'\n',...
            'Def = [1:100], ex. [2:58.3,62.1:100]'])}},{{'style','edit','string',  disp_str_total_freqs,'tag', 'bw_total_freqs_resp'}}];
        out_mod_button_geometry = {1 1 2 1 1 1 1 [.7 .3]};
        out_mod_ver_geometry=  [1 1 3 1 1 6 1 1];
        
        if grp_proc_info.src_data_type ==2 % if event-related data
            out_mod_button_list =[out_mod_button_list , extra_space_line...
                {{'style','text','string',sprintf(['Segment analysis window start time \n relative to event marker in seconds (def: -0.100)'])}},...
                {{'style','text','string',sprintf(['Segment analysis window end time  \n relative to event marker in seconds (def: 0.800)'])}},...
                {{'style','edit','string',num2str(grp_proc_info.evt_analysis_win_start),'tag','evt_analysis_win_start'}},...
                {{'style','edit','string',num2str(grp_proc_info.evt_analysis_win_end),'tag','evt_analysis_win_end'}}];
            out_mod_button_geometry = [out_mod_button_geometry 1 [.5 .5] [.5 .5]];
            out_mod_ver_geometry =  [out_mod_ver_geometry 1 1 1];
        end
        
        skipline_panel ='on';
        
    case 'psd'
        out_mod_button_list = [{{'style','text','string', 'PSD Module Settings:'}},...
            {{'style','text','string', 'Select PSD window type:'}},...
            {{'style','text','string', 'Select PSD interpolation type (def: none):'}},...
            {{'style','popupmenu','string', {'Rectangular','Hanning','Multitaper (rec. 2 seconds or longer)'},...
            'tag','psd_win_typ','Value', grp_proc_info.psd_win_typ+1}},...
            {{'style','popupmenu','string', {'None','Linear','Nearest Neighbor','Piecewise Cubic Spline'},...
            'tag','psd_interp_typ','Value', grp_proc_info.psd_interp_typ}},...
            {{'style','checkbox','string', 'Generate PSD Excel Report?','tag','psd_xls_rep_on','Value',grp_proc_info.beapp_toggle_mods{'psd','Module_Xls_Out_On'}}},...
            extra_space_line,{{'style','pushbutton','string', 'Adv. PSD Settings','CallBack',...
            ['beapp_gui_trigger_adv_settings_panel']}}];
        
        out_mod_button_geometry = {1 [.5 .5] [.5 .5] 1 [.7 .3] };
        out_mod_ver_geometry=  [1 1 1.5 1 1];
        skipline_panel ='on';
        
    case 'itpc'
        %{{'style','edit','string', num2str(grp_proc_info.beapp_itpc_params.win_size),'tag','itpc_win_size'}},...
        out_mod_button_list = [{{'style','text','string', 'ITPC Module Settings:'}},...
            {{'style','checkbox','string', 'Set frequency range? (Frequency inputs below will not be used if unchecked)','tag','itpc_set_freq_range','Value',grp_proc_info.beapp_itpc_params.set_freq_range}}...
            {{'style','text','string', 'frequency range (min,max):'}},...
            {{'style','edit','string',  grp_proc_info.beapp_itpc_params.min_freq,'tag', 'itpc_min_freq'}}...
            {{'style','edit','string',  grp_proc_info.beapp_itpc_params.max_freq,'tag', 'itpc_max_freq'}}...
            {{'style','text','string', 'Number of cycles in each Morlet Wavelet at (min,max) frequencies:'}},...
            {{'style','edit','string',  grp_proc_info.beapp_itpc_params.min_cyc,'tag', 'itpc_min_cyc'}}...
            {{'style','edit','string',  grp_proc_info.beapp_itpc_params.max_cyc,'tag', 'itpc_max_cyc'}}...
            {{'style','checkbox','string', 'Normalize ERSP to baseline?','tag','itpc_base_norm_on','Value',grp_proc_info.beapp_itpc_params.baseline_norm}}...
            {{'style','checkbox','string', 'Generate ITPC Excel Report?','tag','itpc_xls_rep_on','Value',grp_proc_info.beapp_toggle_mods{'itpc','Module_Xls_Out_On'}}},...
            extra_space_line,{{'style','pushbutton','string', 'Adv. ITPC Settings','CallBack',...
            ['beapp_gui_trigger_adv_settings_panel']}}];
        out_mod_button_geometry = {1 1 [.5 .25 .25] [.5 .25 .25] 1 1 [.7 .3]};
        out_mod_ver_geometry=  [1 1 1 1 1 1 1];
        skipline_panel ='on';
        
     case 'fooof'
         
         %create string from channel group variable
         chan_grp_str = '';
         for i=1:size(grp_proc_info.fooof_channel_groups,2)
             curr_grp_chan = num2str(grp_proc_info.fooof_channel_groups{1,i});
             curr_grp_chan = strrep(curr_grp_chan,'  ',',');
             chan_grp_str = strcat(chan_grp_str,{' '},curr_grp_chan);
         end
         save_prt_str = '';
         for i=1:size(grp_proc_info.fooof_save_participants,2)
             save_prt_str = strcat(save_prt_str,{' '},grp_proc_info.fooof_save_participants{1,i});
         end
         out_mod_button_list = [{{'style','text','string', 'FOOOF Module Settings:'}},...
             {{'style','text','string', 'frequency range (min,max):'}},...
             {{'style','edit','string',  grp_proc_info.fooof_min_freq,'tag', 'fooof_min_freq'}}...
             {{'style','edit','string',  grp_proc_info.fooof_max_freq,'tag', 'fooof_max_freq'}}...
             {{'style','text','string', 'peak width limit range (min,max):'}}...
             {{'style','edit','string',  grp_proc_info.fooof_peak_width_limits(1,1),'tag', 'fooof_min_peak_width'}}...
             {{'style','edit','string',  grp_proc_info.fooof_peak_width_limits(1,2),'tag', 'fooof_max_peak_width'}}...
             {{'style','text','string','Max number of peaks:'}},...
             {{'style','edit','string', num2str(grp_proc_info.fooof_max_n_peaks),'tag','fooof_max_n_peaks'}}...
             {{'style','text','string', 'Min peak amplitude:'}},...
             {{'style','edit','string', num2str(grp_proc_info.fooof_min_peak_amplitude),'tag','fooof_min_peak_amplitude'}}...
             {{'style','text','string','Min peak threshold'}},...
             {{'style','edit','string', num2str(grp_proc_info.fooof_min_peak_threshold ),'tag','fooof_min_peak_threshold'}}...
             {{'style','text','string','Background Mode'}},...
             {{'style','popupmenu','string',{'fixed','knee'},'tag','fooof_background_mode','Value',grp_proc_info.fooof_background_mode}},...
             {{'style','checkbox','string', 'Generate FOOOF Excel Report?','tag','fooof_xls_rep_on','Value',grp_proc_info.fooof_xlsout_on}}...
             {{'style','checkbox','string', 'Save all FOOOF Figures?','tag','fooof_fig_rep_on','Value',grp_proc_info.fooof_save_all_reports}}...
             {{'style','checkbox','string', 'Average channels together?','tag','fooof_avg_chans','Value',grp_proc_info.fooof_average_chans}}...
             {{'style','text','string','Specify channels to analyze (leave blank to analyze all, seperate by spaces)'}},...
             {{'style','edit','string',num2str(grp_proc_info.fooof_chans_to_analyze),'tag','fooof_chans_to_analyze'}},...
             {{'style','text','string','Specify channel groups to analyze (Seperate group channels by comma, seperate groups by space; Ex: 1,2 3,4; Leave blank to not specify)'}},...
             {{'style','edit','string',chan_grp_str,'tag','fooof_channel_groups'}},...
             {{'style','text','string','Specify participants to save reports for (leave blank to not specify)'}},...
             {{'style','edit','string',save_prt_str,'tag','fooof_save_participants'}},...
             {{'style','text','string','Specify channels to save reports for (leave blank to not specify, seperate by spaces)'}},...
             {{'style','edit','string',num2str(grp_proc_info.fooof_save_channels),'tag','fooof_save_channels'}},...
             {{'style','text','string','Specify groups to save reports for (leave blank to not specify, seperate by spaces)'}},...
             {{'style','edit','string',num2str(grp_proc_info.fooof_save_groups),'tag','fooof_save_groups'}}]; 
    
         out_mod_button_geometry = {1 [.5 .25 .25] [.5 .25 .25] [.5 .5] [.5 .5] [.5 .5] [.5 .5] 1 1 1 [.75 .25] [.75 .25] [.75 .25] [.75 .25] [.75 .25]};
         out_mod_ver_geometry=  [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
         skipline_panel ='on';
         
    case 'pac'
        
        %reformat pac_method as index for drop down panel
        pac_method = 1;
        switch grp_proc_info.pac_method
            case 'ozkurt'
                pac_method = 1;
            case 'canolty'
                pac_method = 2;
            case 'tort'
                pac_method = 3;
            case 'penny'
                pac_method = 4;
            case 'vanwijk'
                pac_method = 5;
            case 'duprelatour'
                pac_method = 6;
            case 'colgin'
                pac_method = 7;
            case 'sigl'
                pac_method = 8;
            case 'bispectrum'
                pac_method = 9;
            otherwise
                warndlg (['Method' grp_proc_info.pac_method ' is not yet available in BEAPP']);
        end
        
        save_prt_str = '';
        for i=1:size(grp_proc_info.pac_save_participants,2)
             save_prt_str = strcat(save_prt_str,{' '},grp_proc_info.pac_save_participants{1,i});
        end
         out_mod_button_list = [{{'style','text','string', 'PAC Module Settings:'}},...
             {{'style','text','string','PAC Method:'}},...
             {{'style','popupmenu','string',{'ozkurt', 'canolty', 'tort', 'penny', 'vanwijk', 'duprelatour', 'colgin', 'sigl', 'bispectrum'},'tag','pac_method','Value',pac_method}},...
             {{'style','text','string', 'low frequency range (min,max):'}},...
             {{'style','edit','string',  grp_proc_info.pac_low_fq_min,'tag', 'pac_low_fq_min'}}...
             {{'style','edit','string',  grp_proc_info.pac_low_fq_max,'tag', 'pac_low_fq_max'}}...
             {{'style','text','string', 'low frequency resolution:'}},...
             {{'style','edit','string',  grp_proc_info.pac_low_fq_res,'tag', 'pac_low_fq_res'}}...
             {{'style','text','string', 'low frequency bandwidth:'}},...
             {{'style','edit','string',  grp_proc_info.pac_low_fq_width,'tag', 'pac_low_fq_width'}}...
             {{'style','text','string', 'high frequency range (min,max):'}},...
             {{'style','edit','string',  grp_proc_info.pac_high_fq_min,'tag', 'pac_high_fq_min'}}...
             {{'style','edit','string',  grp_proc_info.pac_high_fq_max,'tag', 'pac_high_fq_max'}}...
             {{'style','text','string', 'high frequency resolution:'}},...
             {{'style','edit','string',  grp_proc_info.pac_high_fq_res,'tag', 'pac_high_fq_res'}}...
             {{'style','text','string', 'high frequency bandwidth:'}},...
             {{'style','edit','string',  grp_proc_info.pac_high_fq_width,'tag', 'pac_high_fq_width'}}...
             {{'style','text','string','Specify channels to analyze (leave blank to analyze all, seperate by spaces)'}},...
             {{'style','edit','string',num2str(grp_proc_info.pac_chans_to_analyze),'tag','pac_chans_to_analyze'}}...
             {{'style','checkbox','string', 'Generate PAC Excel Report?','tag','pac_xls_rep_on','Value',grp_proc_info.pac_xlsout_on}}...
             {{'style','checkbox','string', 'Save all PAC Figures?','tag','pac_fig_rep_on','Value',grp_proc_info.pac_save_all_reports}}...
             {{'style','text','string','Specify participants to save reports for (leave blank to not specify)'}},...
             {{'style','edit','string',save_prt_str,'tag','pac_save_participants'}},...
             {{'style','text','string','Specify channels to save reports for (leave blank to not specify, seperate by spaces)'}},... 
             {{'style','edit','string',num2str(grp_proc_info.pac_save_channels),'tag','pac_save_channels'}}];
         out_mod_button_geometry = {1 [.5 .5] [.5 .25 .25] [.5 .5] [.5 .5] [.5 .25 .25] [.5 .5] [.5 .5] [.5 .5] [.5 .5] [.75 .25] [.75 .25]};
         out_mod_ver_geometry=  [1 1.5 1 1 1 1 1 1 1 1 1 1];
         skipline_panel ='off';
             %todo: add method dropdown
    otherwise
        warndlg (['Output module ' current_sub_panel ' is not yet available in BEAPP GUI, please turn off']);
        out_mod_button_list = [{{'style','text','string','This panel does not have settings'}}];
        out_mod_button_geometry ={1};
       out_mod_ver_geometry =1;
       skipline_panel = 'on';
        
end

[adv_out_mod_button_list,adv_out_mod_button_geometry,adv_out_mod_ver_geometry] =...
    beapp_gui_adv_out_mod_settings_prep(current_sub_panel,grp_proc_info);
end