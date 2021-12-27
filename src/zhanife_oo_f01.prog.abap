*&---------------------------------------------------------------------*
*& Include          ZHANIFE_OO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          ZHANIFE_ORNEK2_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

select * from sflight
into CORRESPONDING FIELDS OF table gt_list.

DATA IT_cellcolor TYPE lvc_T_scol .
DATA ls_cellcolor TYPE lvc_s_scol .


READ TABLE gt_list INDEX 5 .
ls_cellcolor-fname = 'PRICE' .
ls_cellcolor-color-col = '6' .
ls_cellcolor-color-int = '1' .
ls_cellcolor-COLOR-INV =  '0'.
APPEND ls_cellcolor TO IT_cellcolor .
gt_list-cellcolors[] = IT_cellcolor[].
MODIFY gt_list INDEX 5 .

READ TABLE GT_LIST INDEX 2.
GT_LIST-ROWCOLOR = 'C111'.
MODIFY GT_LIST INDEX 2.

 LOOP AT GT_LIST.
 IF gt_list-carrid = 'AA'.
 gt_list-carrid_handle = '1' .
 ENDIF.
 IF gt_list-connid = '64' .
 gt_list-connid_handle = '4' .
 ENDIF .
 MODIFY gt_list .
 ENDLOOP.


 DATA ls_style TYPE lvc_s_styl .
...
READ TABLE gt_list INDEX 7 .
ls_style-fieldname = 'SEATSMAX' .
ls_style-style = cl_gui_alv_grid=>mc_style_button .
APPEND ls_style TO gt_list-cellstyles .
MODIFY gt_list INDEX 7 .

data:gs_list like gt_list.
LOOP AT GT_LIST into gs_list.
ls_style-fieldname = 'PRICE' .
ls_style-style =  cl_gui_alv_grid=>mc_style_ENabled .
*REFRESH gs_list-cellstyles.
insert ls_style into table gs_list-cellstyles.
MODIFY gt_list from gs_list TRANSPORTING  cellstyles .
ENDLOOP.

*FORM prepare_hyperlinks_table CHANGING pt_hype TYPE lvc_t_hype .
* DATA ls_hype TYPE lvc_s_hype .
* ls_hype-handle = '1' .
* ls_hype-href = 'http://www.company.com/carrids/car1' .
* APPEND ls_hype TO pt_hype .
* ls_hype-handle = '2' .
* ls_hype-href = 'http://www.company.com/carrids/car1' .
* APPEND ls_hype TO pt_hype .
* ls_hype-handle = '3' .
* ls_hype-href = 'http://www.company.com/carrids/car1' .
* APPEND ls_hype TO pt_hype .
* ls_hype-handle = '4' .
* ls_hype-href = 'http://www.company.com/connids/con11' .
* APPEND ls_hype TO pt_hype .
* ls_hype-handle = '5' .
* ls_hype-href = 'http://www.company.com/connids/con12' .
* APPEND ls_hype TO pt_hype .
*.. ..
*ENDFORM .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form show_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_data .

ENDFORM.
