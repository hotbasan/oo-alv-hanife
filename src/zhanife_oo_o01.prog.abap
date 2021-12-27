*&---------------------------------------------------------------------*
*& Include          ZHANIFE_ORNEK2_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'Z100'.
* SET TITLEBAR 'xxx'.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_alv OUTPUT.

 IF gr_alvgrid IS INITIAL .
*----Creating custom container instance
 CREATE OBJECT gr_ccontainer
 EXPORTING
 container_name = gc_custom_control_name
 EXCEPTIONS
 cntl_error = 1
 cntl_system_error = 2
 create_error = 3
 lifetime_error = 4
 lifetime_dynpro_dynpro_link = 5
 OTHERS = 6 .
 IF sy-subrc <> 0.
*--Exception handling
 ENDIF.


* *----Creating ALV Grid instance
 CREATE OBJECT gr_alvgrid
 EXPORTING
 i_parent = gr_ccontainer
 EXCEPTIONS
 error_cntl_create = 1
 error_cntl_init = 2
 error_cntl_link = 3
 error_dp_create = 4
 OTHERS = 5 .
 IF sy-subrc <> 0.
*--Exception handling
 ENDIF.
*----Preparing field catalog.
 PERFORM prepare_field_catalog CHANGING gt_fieldcat .
*----Preparing layout structure
 PERFORM prepare_layout CHANGING gs_layout .
 PERFORM prepare_filter_table CHANGING gt_filt.
 PERFORM prepare_sort_table CHANGING GT_sort .
 PERFORM prepare_hyperlinks_table CHANGING Gt_hype .
 PERFORM prepare_drilldown_values.
 PERFORM adjust_editables USING GT_LIST[].

 DATA gr_event_handler TYPE REF TO lcl_event_handler .

   CALL METHOD gr_alvgrid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.
.. ..
*--Creating an instance for the event handler
 CREATE OBJECT gr_event_handler .
*--Registering handler methods to handle ALV Grid events
 SET HANDLER gr_event_handler->handle_user_command FOR gr_alvgrid .
 SET HANDLER gr_event_handler->handle_toolbar FOR gr_alvgrid .
 SET HANDLER gr_event_handler->handle_menu_button FOR gr_alvgrid .
 SET HANDLER gr_event_handler->handle_double_click FOR gr_alvgrid .
 SET HANDLER gr_event_handler->handle_hotspot_click FOR gr_alvgrid .
 SET HANDLER gr_event_handler->handle_button_click FOR gr_alvgrid .
 SET HANDLER  gr_event_handler->handle_onf4
 FOR gr_alvgrid .
 SET HANDLER gr_event_handler->handle_before_user_command
 FOR gr_alvgrid .
* SET HANDLER gr_event_handler->handle_context_menu_request
* FOR gr_alvgrid .
 SET HANDLER gr_event_handler->handle_data_changed FOR gr_alvgrid .
 SET HANDLER gr_event_handler->handle_data_changed_finished
 FOR gr_alvgrid .

     PERFORM field_f4_register.

     CALL METHOD  gr_alvgrid->set_toolbar_interactive.

*   ENTER key is pressed or
    CALL METHOD  gr_alvgrid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

*   data is changed and cursor is moved from the cell
    CALL METHOD  gr_alvgrid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    CALL METHOD  gr_alvgrid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.


*----Here will be additional preparations
*--e.g. initial sorting criteria, initial filtering criteria, excluding
*--functions
 CALL METHOD gr_alvgrid->set_table_for_first_display
 EXPORTING
* I_BUFFER_ACTIVE =
* I_CONSISTENCY_CHECK =
* I_STRUCTURE_NAME =
* IS_VARIANT =
* I_SAVE =
* I_DEFAULT = 'X'
 is_layout = gs_layout
* IS_PRINT =
* IT_SPECIAL_GROUPS =
* IT_TOOLBAR_EXCLUDING =
 IT_HYPERLINK = GT_HYPE
 CHANGING
 it_outtab = gt_list[]
 it_fieldcatalog = gt_fieldcat
 IT_SORT = GT_SORT
 IT_FILTER = GT_FILT
 EXCEPTIONS
 invalid_parameter_combination = 1
 program_error = 2
 too_many_lines = 3
 OTHERS = 4 .


 IF sy-subrc <> 0.
*--Exception handling
 ENDIF.
 ELSE .
 CALL METHOD gr_alvgrid->refresh_table_display
* EXPORTING
* IS_STABLE =
* I_SOFT_REFRESH =
 EXCEPTIONS
 finished = 1
 OTHERS = 2 .
 IF sy-subrc <> 0.
*--Exception handling
 ENDIF.
 ENDIF .



ENDMODULE.
*&---------------------------------------------------------------------*
*& Form prepare_field_catalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_FIELDCAT
*&---------------------------------------------------------------------*
FORM prepare_field_catalog CHANGING pt_fieldcat TYPE lvc_t_fcat .
DATA ls_fcat TYPE lvc_s_fcat .
 CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
 i_structure_name = 'SFLIGHT'
 CHANGING
 ct_fieldcat = pt_fieldcat[]
 EXCEPTIONS
 inconsistent_interface = 1
 program_error = 2
 OTHERS = 3.
 IF sy-subrc <> 0.
*--Exception handling
 ENDIF.
 LOOP AT pt_fieldcat INTO ls_fcat .
 CASE LS_fcat-fieldname .
 WHEN 'CARRID' .
 ls_fcat-outpuTlen = '10' .
 ls_fcat-coltext = 'Airline Carrier ID' .
 WHEN 'CURRENCY'.
 ls_fcat-hotspot  = 'X'.
 MODIFY pt_fieldcat FROM ls_fcat .
 WHEN 'PAYMENTSUM' .
 ls_fcat-no_out = 'X' .
 WHEN  'CARRID'.
  ls_fcat-web_field = 'CARRID_HANDLE'.
 WHEN 'CONNID'.
  ls_fcat-web_field = 'CONNID_HANDLE'.
WHEN 'SEATMAX'.
  ls_fcat-edit = 'X'.
*  gs_fcat-edit    = 'X'.
*  gs_fcat-f4availabl = 'X'.
 MODIFY pt_fieldcat FROM ls_fcat .
 ENDCASE .
  MODIFY pt_fieldcat FROM ls_fcat .
 ENDLOOP .
ENDFORM .
*&---------------------------------------------------------------------*
*& Form prepare_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LAYOUT
*&---------------------------------------------------------------------*
 FORM prepare_layout CHANGING ps_layout TYPE lvc_s_layo.
ps_layout-zebra = 'X' .
ps_layout-grid_title = 'Flights' .
ps_layout-smalltitle = 'X' .
ps_layout-stylefname = 'CELLSTYLES' .
PS_laYout-ctab_fname = 'CELLCOLORS'.
PS_laYout-info_fname = 'ROWCOLOR'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form prepare_filter_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_FILT
*&---------------------------------------------------------------------*
FORM prepare_filter_table CHANGING pt_filt TYPE lvc_t_filt .
 DATA ls_filt TYPE lvc_s_filt .
 ls_filt-fieldname = 'FLDATE' .
 ls_filt-sign = 'E' .
 ls_filt-option = 'BT' .
 ls_filt-low = '20200101' .
 ls_filt-high = '20200130' .
 APPEND ls_filt TO pt_filt .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form prepare_sort_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_SORT
*&      <-- TYPE
*&      <-- LVC_T_SORT
*&---------------------------------------------------------------------*
FORM prepare_sort_table CHANGING pt_sort TYPE lvc_t_sort .
 DATA ls_sort TYPE lvc_s_sort .
 ls_sort-spos = '1' .
 ls_sort-fieldname = 'CARRID' .
 ls_sort-up = 'X' . "A to Z
 ls_sort-down = space .
 APPEND ls_sort TO pt_sort .
 ls_sort-spos = '2' .
 ls_sort-fieldname = 'CONNID' .
 ls_sort-up = space .
 ls_sort-down = 'X' . "Z to A
 APPEND ls_sort TO pt_sort .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form prepare_hyperlinks_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GT_HYPE
*&---------------------------------------------------------------------*
FORM prepare_hyperlinks_table CHANGING pt_hype TYPE lvc_t_hype .

 DATA ls_hype TYPE lvc_s_hype .
 ls_hype-handle = '1' .
 ls_hype-href = 'http://www.company.com/carrids/car1' .
 APPEND ls_hype TO pt_hype .
 ls_hype-handle = '2' .
 ls_hype-href = 'http://www.company.com/carrids/car1' .
 APPEND ls_hype TO pt_hype .
 ls_hype-handle = '3' .
 ls_hype-href = 'http://www.company.com/carrids/car1' .
 APPEND ls_hype TO pt_hype .
 ls_hype-handle = '4' .
 ls_hype-href = 'http://www.company.com/connids/con11' .
 APPEND ls_hype TO pt_hype .
 ls_hype-handle = '5' .
 ls_hype-href = 'http://www.company.com/connids/con12' .
 APPEND ls_hype TO pt_hype .

ENDFORM .
*&---------------------------------------------------------------------*
*& Form prepare_drilldown_values
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM prepare_drilldown_values.
 DATA lt_ddval TYPE lvc_t_drop .
 DATA ls_ddval TYPE lvc_s_drop .
 ls_ddval-handle = '1' .
 ls_ddval-value = 'JFK-12' .
 APPEND ls_ddval TO lt_ddval .
 ls_ddval-handle = '1' .
 ls_ddval-value = 'JSF-44' .
 APPEND ls_ddval TO lt_ddval .
 ls_ddval-handle = '1' .
 ls_ddval-value = 'KMDA-53' .
 APPEND ls_ddval TO lt_ddval .
 ls_ddval-handle = '1' .
 ls_ddval-value = 'SS3O/N' .
 APPEND ls_ddval TO lt_ddval .
 CALL METHOD gr_alvgrid->set_drop_down_table
 EXPORTING
 it_drop_down = lt_ddval .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&      --> ES_ROW_NO
*&---------------------------------------------------------------------*
 FORM handle_hotspot_click USING i_row_id TYPE lvc_s_row
 i_column_id TYPE lvc_s_col
 is_row_no TYPE lvc_s_roid.
 READ TABLE gt_list INDEX is_row_no-row_id .
 IF sy-subrc = 0 AND i_column_id-fieldname = 'SEATSOCC' .
* CALL SCREEN 200 . "Details about passenger-seat matching
 ENDIF .
 ENDFORM .
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
 FORM handle_double_click USING i_row TYPE lvc_s_row
                                i_column TYPE lvc_s_col.

 READ TABLE gt_list INDEX i_row-index .
 IF sy-subrc = 0 AND i_column-fieldname = 'SEATSOCC' .
* CALL SCREEN 200 . "Details about passenger-seat matching
 ENDIF .
 ENDFORM .
*&---------------------------------------------------------------------*
*& Form handle_toolbar
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_INTERACTIVE
*&---------------------------------------------------------------------*
*eference we can reach via the parameter “e_object” of the event.
*Code Part 27 – Filling the structure for two new buttons
 FORM handle_toolbar USING i_object TYPE REF TO cl_alv_event_toolbar_set .
 DATA: ls_toolbar TYPE stb_button.
 CLEAR ls_toolbar.
 MOVE 3 TO ls_toolbar-butn_type.
 APPEND ls_toolbar TO i_object->mt_toolbar.
 CLEAR ls_toolbar.
 MOVE 'PER' TO ls_toolbar-function. "#EC NOTEXT
 MOVE icon_display_text TO ls_toolbar-icon.
 MOVE 'Passenger Info'(201) TO ls_toolbar-quickinfo.
 MOVE 'Passenger Info'(201) TO ls_toolbar-text.
 MOVE ' ' TO ls_toolbar-disabled. "#EC NOTEXT
 APPEND ls_toolbar TO i_object->mt_toolbar.
 CLEAR ls_toolbar.
 MOVE 'EXCH' TO ls_toolbar-function. "#EC NOTEXT
 MOVE 2 TO ls_toolbar-butn_type.
 MOVE icon_calculation TO ls_toolbar-icon.
 MOVE 'Payment in Other Currencies'(202) TO ls_toolbar-quickinfo.
 MOVE ' ' TO ls_toolbar-text.
 MOVE ' ' TO ls_toolbar-disabled. "#EC NOTEXT
 APPEND ls_toolbar TO i_object->mt_toolbar.
 ENDFORM .
*&---------------------------------------------------------------------*
*& Form handle_menu_button
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM handle_menu_button USING i_object TYPE REF TO cl_ctmenu
 i_ucomm TYPE syucomm .
 CASE i_ucomm .
 WHEN 'EXCH' .
 CALL METHOD i_object->add_function
 EXPORTING
 fcode = 'EU'
 text = 'Euro' .
 CALL METHOD i_object->add_function
 EXPORTING
 fcode = 'TRL'
 text = 'Turkish Lira' .
 .. ..
 ENDCASE .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_user_command
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM handle_user_command USING i_ucomm TYPE syucomm .
 DATA lt_selected_rows TYPE lvc_t_roid .
 DATA ls_selected_row TYPE lvc_s_roid .
 CALL METHOD gr_alvgrid->get_selected_rows
 IMPORTING
 et_row_no = lt_selected_rows .
 READ TABLE lt_selected_rows INTO ls_selected_row INDEX 1 .
 IF sy-subrc ne 0 .
 MESSAGE s000(su) WITH 'Select a row!'(203) .
 ENDIF .
 CASE i_ucomm .
 WHEN 'CAR' .
 READ TABLE gt_list INDEX ls_selected_row-row_id .
 IF sy-subrc = 0 .
 CALL FUNCTION 'ZDISPLAY_CARRIER_INFO'
 EXPORTING carrid = gt_list-carrid
 EXCEPTIONS carrier_not_found = 1
 OTHERS = 2.
 IF sy-subrc NE 0 .
*--Exception handling
 ENDIF .
 ENDIF .
 WHEN 'EU' .
 READ TABLE gt_list INDEX ls_selected_row-row_id .
 IF sy-subrc = 0 .
 CALL FUNCTION 'ZPOPUP_CONV_CURR_AND_DISPLAY'
 EXPORTING monun = 'EU'
 quant = gt_list-paymentsum.
 ENDIF .
 .. ..
 ENDCASE .
ENDFORM .
*&---------------------------------------------------------------------*
*& Form handle_before_user_command
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
FORM handle_before_user_command USING i_ucomm TYPE syucomm .
 CASE i_ucomm .
 WHEN '&INFO' .
 CALL FUNCTION 'ZSFLIGHT_PROG_INFO' .
 CALL METHOD gr_alvgrid->set_user_command
 EXPORTING i_ucomm = space.
 ENDCASE .
ENDFORM .
*&---------------------------------------------------------------------*
*& Form adjust_editables
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_LIST
*&---------------------------------------------------------------------*
FORM adjust_editables USING pt_list LIKE gt_list[] .



 DATA ls_listrow LIKE LINE OF pt_list .
 DATA ls_stylerow TYPE lvc_s_styl .
 DATA lt_styletab TYPE lvc_t_styl .


* LOOP AT pt_list INTO ls_listrow .
* IF ls_listrow-carrid = 'AA' .
* ls_stylerow-fieldname = 'PRICE' .
* ls_stylerow-style = cl_gui_alv_grid=>mc_style_ENabled .
* APPEND ls_stylerow TO ls_listrow-cellstyles .
* INSERT ls_stylerow into table ls_listrow-cellstyles.
*      MODIFY PT_LIST FROM ls_listrow.
* CLEAR:  ls_stylerow,ls_listrow-cellstyles.
* ENDIF .
* ENDLOOP .
ENDFORM .
*&---------------------------------------------------------------------*
*& Form handle_data_changed
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM handle_data_changed USING ir_data_changed
 TYPE REF TO cl_alv_changed_data_protocol.
 DATA : ls_mod_cell TYPE lvc_s_modi ,
 lv_value TYPE lvc_value .
 SORT ir_data_changed->mt_mod_cells BY row_id .
 LOOP AT ir_data_changed->mt_mod_cells
 INTO ls_mod_cell
 WHERE fieldname = 'SEATSMAX' .
 CALL METHOD ir_data_changed->get_cell_value
 EXPORTING i_row_id = ls_mod_cell-row_id
 i_fieldname = 'CARRID'
 IMPORTING e_value = lv_value .
 IF lv_value = 'THY' AND ls_mod_cell-value > '500' .
 CALL METHOD ir_data_changed->add_protocol_entry
 EXPORTING
 i_msgid = 'SU'
 i_msgno = '000'
 i_msgty = 'E'
 i_msgv1 = 'This number can not exceed 500 for '
 i_msgv2 = lv_value
 i_msgv3 = 'The value is et to ''500'''
 i_fieldname = ls_mod_cell-fieldname
 i_row_id = ls_mod_cell-row_id .
 CALL METHOD ir_data_changed->modify_cell
 EXPORTING i_row_id = ls_mod_cell-row_id
 i_fieldname = ls_mod_cell-fieldname
 i_value = '500' .
 ENDIF .
 ENDLOOP .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form field_f4_register
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM field_f4_register .
*  DATA:
*    lt_f4 TYPE lvc_t_f4,
*    ls_f4 TYPE lvc_s_f4.
*
*  ls_f4-fieldname  = 'ANA_HESAP'.
*  ls_f4-register   = 'X'.
*  ls_f4-getbefore  = ' '.
*  ls_f4-chngeafter = 'X'.
*  INSERT ls_f4 INTO TABLE lt_f4.
*
**{   ->>> Inserted by Prodea Ozan Şahin - 19.03.2020 13:59:47
*  ls_f4-fieldname  = 'ABKRS'.
*  ls_f4-register   = 'X'.
*  ls_f4-getbefore  = ' '.
*  ls_f4-chngeafter = 'X'.
*  INSERT ls_f4 INTO TABLE lt_f4.
**}     <<<- End of   Inserted - 19.03.2020 13:59:47
*
**{   ->>> Inserted by Prodea ilknunacar - 20.04.2020 13:59:47
*  ls_f4-fieldname  = 'AUFNR'.
*  ls_f4-register   = 'X'.
*  ls_f4-getbefore  = ' '.
*  ls_f4-chngeafter = 'X'.
*  INSERT ls_f4 INTO TABLE lt_f4.
**}     <<<- End of   Inserted - 20.04.2020 13:59:47
*  ls_f4-fieldname  = 'LIFNR'.
*  ls_f4-register   = 'X'.
*  ls_f4-getbefore  = ' '.
*  ls_f4-chngeafter = 'X'.
*  INSERT ls_f4 INTO TABLE lt_f4.
*
*  CALL METHOD grid->register_f4_for_fields
*    EXPORTING
*      it_f4 = lt_f4.
ENDFORM.
*&---------------------------------------------------------------------*
*& Include          ZHANIFE_OO_O01
*&---------------------------------------------------------------------*
