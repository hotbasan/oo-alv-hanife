*&---------------------------------------------------------------------*
*& Report ZHANIFE_OO_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZHANIFE_OO_ALV.

INCLUDE ZHANIFE_OO_TOP.
INCLUDE ZHANIFE_OO_C01.
INCLUDE ZHANIFE_OO_F01.
INCLUDE ZHANIFE_OO_I01.
INCLUDE ZHANIFE_OO_O01.


START-OF-SELECTION.
  PERFORM GET_DATA.
  CALL SCREEN '0100'.
