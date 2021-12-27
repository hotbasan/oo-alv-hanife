*&---------------------------------------------------------------------*
*& Include          ZHANIFE_ORNEK2_TOP
*&---------------------------------------------------------------------*
*-- Global data definitions for ALV
*--- ALV Grid instance reference
DATA gr_alvgrid TYPE REF TO cl_gui_alv_grid .
*--- Name of the custom control added on the screen
DATA gc_custom_control_name TYPE scrfname VALUE 'CC_ALV' .
*--- Custom container instance reference
DATA gr_ccontainer TYPE REF TO cl_gui_custom_container .
*--- Field catalog table
DATA gt_fieldcat TYPE lvc_t_fcat .
DATA:GT_FILT TYPE lvc_t_filt.
DATA:GT_SORT TYPE lvc_t_sort .
DATA:GT_HYPE TYPE lvc_t_hype.
*--- Layout structure
DATA gs_layout TYPE lvc_s_layo .


*--- Internal table holding list data
DATA BEGIN OF gt_list OCCURS 0 .
INCLUDE STRUCTURE SFLIGHT .
DATA rowcolor(4) TYPE c .
DATA CELLCOLORS TYPE lvc_t_scol .
DATA CELL_button TYPE lvc_t_scol .
DATA carrid_handle TYPE int4 .
DATA connid_handle TYPE int4 .
DATA ptype_dd_hndl TYPE int4 .
DATA CELLSTYLES TYPE lvc_t_styl .

*--In further sections, some additional fields will added here
*--for some functionality
DATA END OF gt_list .

CLASS lcl_event_handler DEFINITION .
 PUBLIC SECTION .
 METHODS:
*To add new functional buttons to the ALV toolbar
 handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
 IMPORTING e_object e_interactive ,
*To implement user commands
 handle_user_command
 FOR EVENT user_command OF cl_gui_alv_grid
 IMPORTING e_ucomm ,
*Hotspot click control
 handle_hotspot_click
 FOR EVENT hotspot_click OF cl_gui_alv_grid
 IMPORTING e_row_id e_column_id es_row_no ,
*Double-click control
 handle_double_click
 FOR EVENT double_click OF cl_gui_alv_grid
 IMPORTING e_row e_column ,
*To be triggered before user commands
 handle_before_user_command
 FOR EVENT before_user_command OF cl_gui_alv_grid
 IMPORTING e_ucomm ,
*To be triggered after user commands
* handle_after_user_command
* FOR EVENT context_menu_request OF cl_gui_alv_grid
* IMPORTING e_object,
*Controlling data changes when ALV Grid is editable
 handle_data_changed
 FOR EVENT data_changed OF cl_gui_alv_grid
 IMPORTING er_data_changed ,
*To be triggered after data changing is finished
 handle_data_changed_finished
 FOR EVENT data_changed_finished OF cl_gui_alv_grid
 IMPORTING e_modified ,
*To control menu buttons
 handle_menu_button
 FOR EVENT menu_button OF cl_gui_alv_grid
 IMPORTING e_oBject e_ucomm ,
*To control button clicks
 handle_button_click
 FOR EVENT button_click OF cl_gui_alv_grid
 IMPORTING eS_row_NO eS_col_id ,


  handle_onf4                                     " ONF4
      FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING
          e_fieldname
          e_fieldvalue
          es_row_no
          er_event_data
          et_bad_cells
          e_display.


ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION .
*Handle Toolbar
 METHOD handle_toolbar.
*PERFORM handle_toolbar USING e_object  .
 ENDMETHOD .
*Handle Hotspot Click
 METHOD handle_hotspot_click .
*PERFORM handle_hotspot_click USING e_row_id e_column_id es_row_no .
 ENDMETHOD .
*Handle Double Click
 METHOD handle_double_click .
*PERFORM handle_double_click USING e_row e_column .
 ENDMETHOD .
*Handle User Command
 METHOD handle_user_command .
*PERFORM handle_user_command USING e_ucomm .
 ENDMETHOD.
*Handle After User Command
* METHOD handle_context_menu_request .
*PERFORM handle_context_menu_request USING e_object .
* ENDMETHOD.
*Handle Before User Command
 METHOD handle_before_user_command .
*PERFORM handle_before_user_command USING e_ucomm .
 ENDMETHOD .
*Handle Data Changed
 METHOD handle_data_changed .
*PERFORM handle_data_changed USING er_data_changed .
 ENDMETHOD.
*Handle Data Changed Finished
 METHOD handle_data_changed_finished .
*PERFORM handle_data_changed_finished USING e_modified .
 ENDMETHOD .
*Handle Menu Buttons
 METHOD handle_menu_button .
* PERFORM handle_menu_button USING e_object e_ucomm .
 ENDMETHOD .
*Handle Button Click
 METHOD handle_button_click .
* PERFORM handle_button_click USING  eS_row_NO eS_col_id.
 ENDMETHOD .

 METHOD handle_onf4.

*          e_fieldname
*          e_fieldvalue
*          es_row_no
*          er_event_data
*          et_bad_cells
*          e_display.

*    CHECK e_fieldname = 'ANA_HESAP'."commented by ozans
*    er_event_data->m_event_handled = 'X'.
*
*    FIELD-SYMBOLS: <itab> TYPE lvc_t_modi.
*
*    DATA: ls_out LIKE gt_out.
*    DATA: BEGIN OF  ls_sh,
*      ana_hesap      TYPE zssi_fi_25_t_01-ana_hesap    ,
*      ana_hesap_txt  TYPE skat-txt20,
*      bas_tarih      TYPE zssi_fi_25_t_01-bas_tarih    ,
*      bit_tarih      TYPE zssi_fi_25_t_01-bit_tarih    ,
**      ana_hesap_my   TYPE zssi_fi_25_t_01-ana_hesap_my ,
*      kkeg_hesap     TYPE zssi_fi_25_t_01-kkeg_hesap   ,
*      kkeg_hesap_txt TYPE skat-txt20,
*      kkeg_hesap_my  TYPE zssi_fi_25_t_01-kkeg_hesap_my,
*      gider_turu     TYPE zssi_fi_25_t_01-gider_turu   ,
*      kisit_turu     TYPE zssi_fi_25_t_01-kisit_turu   ,
*      yuzde          TYPE zssi_fi_25_t_01-yuzde        ,
*      tutar          TYPE zssi_fi_25_t_01-tutar        ,
*      para_birimi    TYPE zssi_fi_25_t_01-para_birimi  ,
*   END OF ls_sh,
*   lt_sh LIKE TABLE OF ls_sh,
*   BEGIN OF ls_sh_tmp,
*     ktopl TYPE t001-ktopl.
*            INCLUDE STRUCTURE ls_sh.
*    DATA:END OF ls_sh_tmp,
*         lt_sh_tmp LIKE TABLE OF ls_sh_tmp,
*         BEGIN OF ls_skat,
*           ktopl TYPE skat-ktopl,
*           saknr TYPE skat-saknr,
*           txt20 TYPE skat-txt20,
*         END OF ls_skat,
*         lt_skat LIKE TABLE OF ls_skat.
*
*
**{   ->>> Inserted by Prodea Ozan Şahin - 19.03.2020 14:01:31
*    DATA: BEGIN OF  ls_sh2,
*      kokrs      TYPE tko08-kokrs    ,
*      abkrs      TYPE tko08-abkrs    ,
*      aktxt      TYPE tko09-aktxt    ,
*   END OF ls_sh2,
*   lt_sh2 LIKE TABLE OF ls_sh2.
**}     <<<- End of   Inserted - 19.03.2020 14:01:31
**{   ->>> Inserted by Prodea ilknurnacar - 20.04.2020 14:01:31
*    DATA: BEGIN OF  ls_sh3,
*            aufnr  TYPE coas-aufnr,
*            abkrs  TYPE aufk-abkrs,
*            kokrs  TYPE coas-kokrs,
*            ktext  TYPE aufk-ktext,
*          END OF ls_sh3,
*          lt_sh3 LIKE TABLE OF ls_sh3,
*          BEGIN OF  ls_sh4,
*            bukrs       TYPE lfb1-bukrs,
*            lifnr       TYPE lfa1-lifnr,
*            name1       TYPE lfa1-name1,
*            zterm       TYPE lfb1-zterm,
*            zterm_desc  TYPE t052u-text1,
*          END OF ls_sh4,
*          lt_sh4 LIKE TABLE OF ls_sh4.
**}     <<<- End of   Inserted - 20.04.2020 14:01:31
*    DATA: lt_return TYPE TABLE OF ddshretval,
*          ls_return LIKE LINE OF lt_return,
*          ls_modi   TYPE lvc_s_modi,
*          lv_lifnr  TYPE lfa1-lifnr.
*
*    CLEAR ls_out.
*    READ TABLE gt_out INTO ls_out INDEX es_row_no-row_id.
*
*    CHECK sy-subrc EQ 0.
*
*    IF  e_fieldname = 'ANA_HESAP'.
*
*      IF ls_out-budat IS INITIAL.
*
*       MESSAGE 'Ana hesap yardımı için önce kayıt tarihi girilmelidir.'
*       TYPE 'S' DISPLAY LIKE 'E'.
*
*      ELSE.
*        SELECT a~ana_hesap
*               b~txt20 AS ana_hesap_txt
*               a~bas_tarih
*               a~bit_tarih
**               a~ana_hesap_my "commented anily24042020
*               a~kkeg_hesap
**               c~txt20 AS kkeg_hesap_txt
*               a~kkeg_hesap_my
*               a~gider_turu
*               a~kisit_turu
*               a~yuzde
*               a~tutar
*               a~para_birimi
*               d~ktopl
*             FROM zssi_fi_25_t_01 AS a
*             INNER JOIN t001 AS d
*                     ON d~bukrs EQ a~bukrs
*             INNER JOIN skat AS b
*                     ON b~spras EQ sy-langu
*                    AND b~ktopl EQ d~ktopl
*                    AND b~saknr EQ a~ana_hesap
**             LEFT JOIN skat AS c
**                     ON c~spras EQ sy-langu
**                    AND c~ktopl EQ d~ktopl
**                    AND c~saknr EQ a~kkeg_hesap
*             INTO CORRESPONDING FIELDS OF TABLE lt_sh_tmp
*                WHERE a~bukrs     EQ ls_out-bukrs
*                  AND a~bas_tarih LE ls_out-budat
*                  AND a~bit_tarih GE ls_out-budat.
*
*        IF lt_sh_tmp[] IS NOT INITIAL.
*          SELECT a~ktopl
*                 a~saknr
*                 a~txt20
*            FROM skat AS a
*            INTO CORRESPONDING FIELDS OF TABLE lt_skat
*            FOR ALL ENTRIES IN lt_sh_tmp
*               WHERE a~ktopl  EQ lt_sh_tmp-ktopl
*                 AND a~saknr  EQ lt_sh_tmp-kkeg_hesap
*                 AND a~spras  EQ sy-langu.
*          SORT lt_skat BY ktopl saknr.
*        ENDIF.
*        LOOP AT lt_sh_tmp INTO ls_sh_tmp.
*          CLEAR ls_sh.
*          MOVE-CORRESPONDING ls_sh_tmp TO ls_sh.
*       READ TABLE lt_skat INTO ls_skat WITH KEY ktopl = ls_sh_tmp-ktopl
*                                           saknr = ls_sh_tmp-kkeg_hesap
*                                                BINARY SEARCH.
*          IF sy-subrc = 0.
*            ls_sh-kkeg_hesap_txt = ls_skat-txt20.
*          ENDIF.
*
*          APPEND ls_sh TO lt_sh.
*        ENDLOOP.
*
*
*        SORT lt_sh BY ana_hesap ASCENDING.
*        DELETE ADJACENT DUPLICATES FROM lt_sh COMPARING ana_hesap.
*
*        CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*          EXPORTING
*            retfield        = 'ANA_HESAP'
*            dynpprog        = sy-repid
*            dynpnr          = sy-dynnr
*            window_title    = text-015
*            value_org       = 'S'
*          TABLES
*            value_tab       = lt_sh[]
*            return_tab      = lt_return[]
*          EXCEPTIONS
*            parameter_error = 1
*            no_values_found = 2
*            OTHERS          = 3.
*        IF sy-subrc = 0.
*          CLEAR ls_return.
*          READ TABLE lt_return INTO ls_return INDEX 1.
*          IF ls_return IS NOT INITIAL.
*            ASSIGN er_event_data->m_data->* TO <itab>.
*            CLEAR: ls_modi.
*            ls_modi-row_id    = es_row_no-row_id.
*            ls_modi-fieldname = 'ANA_HESAP'.
*            ls_modi-value     = ls_return-fieldval.
*            APPEND ls_modi TO <itab>.
*
*            READ TABLE lt_sh INTO ls_sh WITH KEY ana_hesap =
*            ls_return-fieldval.
*            IF sy-subrc EQ 0.
*              CLEAR: ls_modi.
*              ls_modi-row_id    = es_row_no-row_id.
*              ls_modi-fieldname = 'ANA_HESAP_TXT'.
*              ls_modi-value     = ls_sh-ana_hesap_txt.
*              APPEND ls_modi TO <itab>.
*              CLEAR: ls_modi.
*
*              ls_modi-row_id    = es_row_no-row_id.
*              ls_modi-fieldname = 'KKEG_HESAP'.
*              ls_modi-value     = ls_sh-kkeg_hesap.
*              APPEND ls_modi TO <itab>.
*              CLEAR: ls_modi.
*              ls_modi-row_id    = es_row_no-row_id.
*              ls_modi-fieldname = 'KKEG_HESAP_TXT'.
*              ls_modi-value     = ls_sh-kkeg_hesap_txt.
*              APPEND ls_modi TO <itab>.
*              CLEAR: ls_modi.
*              ls_modi-row_id    = es_row_no-row_id.
*              ls_modi-fieldname = 'KKEG_HESAP_MY'.
*              ls_modi-value     = ls_sh-kkeg_hesap_my.
*              APPEND ls_modi TO <itab>.
*
*            ENDIF.
*          ENDIF.
*        ENDIF.
*
*      ENDIF.
*          CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
*      EXPORTING
*        functioncode           = '=00'
*      EXCEPTIONS
*        function_not_supported = 1
*        OTHERS                 = 2.
ENDMETHOD.
ENDCLASS .
*&---------------------------------------------------------------------*
*& Include          ZHANIFE_OO_TOP
*&---------------------------------------------------------------------*
