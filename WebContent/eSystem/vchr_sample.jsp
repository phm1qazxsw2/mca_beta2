<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<style>
.type1 {
  background-color: #FFFFFF;
  border: 0px solid #000;
  border-right: 1px solid #000;
  border-bottom: 1px solid #000;
  font-size:16px;
}
.type2 {
  background-color: #FFFFFF;
  border: 0px solid #000;
  border-right: 1px solid #000;
  font-size:16px;
}
.type3 {
  background-color: #FFFFFF;
  border: 0px solid #000;
  border-bottom: 1px solid #000;
  font-size:16px;
}
.type4 {
  background-color: #FFFFFF;
  border: 0px solid #000;
  font-size:16px;
}
.type5 {
  background-color: #FFFFFF;
  border: 0px solid #000;
  border-left: 1px solid #000;
  border-right: 1px solid #000;
  font-size:16px;
}
</style>
<!--
    Samples:
        <table border=0 cellpadding=3 cellspacing=0 style="border:solid black 1px">
        <tr>
            <td class=type1>A</td><td class=type1>B</td><td class=type3>C</td>
        </tr>
        <tr>
            <td class=type1>D</td><td class=type1>E</td><td class=type3>F</td>
        </tr>
        <tr>
            <td class=type2>X</td><td class=type2>Y</td><td class=type4>Z</td>
        </tr>
        </table>
-->

<table border=0 width=100%>
<tr align=center >
   <td colspan=3 style="font-size:26px">
       公司名稱
   </td>
</tr>
<tr align=left>
   <td style="font-size:16px">
       入帳日期: 2009/01/10
   </td>
   <td style="font-size:16px">
       傳票編號: XYZ0987655676
   </td>
   <td style="font-size:16px">
       登入人: Peter
   </td>
</tr>
<tr>
   <td colspan=3>
        <table border=0 cellpadding=3 cellspacing=0 style="border:solid black 1px" align=left width=100%>
        <tr align=center>
            <td class=type1>借 貸</td>
            <td class=type1>部門</td>
            <td class=type1>專案</td>
            <td class=type1>科目編號</td>
            <td class=type1>科目名稱</td>
            <td class=type1>摘要</td>
            <td class=type1>借方金額</td>
            <td class=type3>貸方金額</td>
        </tr>
        <tr>
            <td class=type2>01234</td>
            <td class=type2>01234567</td>
            <td class=type2>01234567</td>
            <td class=type2>01234567</td>
            <td class=type2>012345678901234</td>
            <td class=type2>01234567890123456789</td>
            <td class=type2>0123456789</td>
            <td class=type4>0123456789</td>
        </tr>
        <tr>
            <td class=type2>2</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>3</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>4</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>5</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>6</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>7</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>8</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>9</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>10</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>11</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>12</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>13</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>14</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type2>15</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type2>　</td>
            <td class=type4>　</td>
        </tr>
        <tr>
            <td class=type1>16</td>
            <td class=type1>　</td>
            <td class=type1>　</td>
            <td class=type1>　</td>
            <td class=type1>　</td>
            <td class=type1>　</td>
            <td class=type1>　</td>
            <td class=type3>　</td>
        </tr>
        <tr>
            <td class=type3>17</td>
            <td class=type3>　</td>
            <td class=type3>　</td>
            <td class=type3>　</td>
            <td class=type3>　</td>
            <td class=type1 align=right>合計</td>
            <td class=type1>　</td>
            <td class=type3>　</td>
        </tr>
        <tr>
            <td colspan=8>
                <table border=0 cellpadding=3 cellspacing=0 style="border:solid black 1px" align=center width=100%>
                    <tr>
                        <td class=type2 width=10>核<br>準</td>
                        <td width="*"></td>
                        <td class=type5 width=10>主<br>管</td>
                        <td width="*"></td>
                        <td class=type5 width=10>會<br>計</td>
                        <td width="*"></td>
                        <td class=type5 width=10>製<br>單</td>
                        <td width="*"></td>
                    </tr>
                </table>
            </td>
        </tr>
        </table>
   </td>
</tr>
</table>

