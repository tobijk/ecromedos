-------------------------------------------------------------------------------

subject: Test - Markdown
title: General Test of all Language Features
author: Tobias Koch
date: 26 July 2016
publisher: ecromedos.net

document-type: report
bcor: 0cm
div: 16
lang: en_US
papersize: a4
parskip: half
secnumdepth: 5
secsplitdepth: 1
tocdepth: 5
have-lof: no
have-lot: yes
have-lol: no

-------------------------------------------------------------------------------

# Inline Elements

## Text *Formatting*

Lorem _ipsum_ dolor *sit* amet, **consectetur adipiscing** ***elit***, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua[^1]. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat.

[^1]: This *is* a footnote.

Testing entity references: &emdash;, &quot;, &amp;.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

## ECML Inline

Lorem <i>ipsum</i> dolor <b>sit</b> amet, <u>consectetur</u> adipiscing elit,
sed do <color rgb="#ee7777">eiusmod</color> tempor incididunt ut <tt>labore</tt>
et dolo<sub>re</sub> mag<sup>na</sup> aliqua. <xx-small>Ut</xx-small> enim
<x-small>ad</x-small> minim <small>veniam</small>, quis <x-large>nostrud</x-large>
exercitation <xx-large>ullamco</xx-large> laboris nisi ut <medium>aliquip</medium>
ex <large>ea</large> commodo consequat.

# Block Elements

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua.

## Blockquotes

Here comes a blockquote:

> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
> incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
> nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
> incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
> nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur.

## Lists

Here comes an ordered list:

1. This is the first list item, spanning over
   several paragraphs.

   Bla bla.

2. Second list item.

Here comes an unordered list:

* This is the first list item, spanning over
  several paragraphs.

  Bla bla.

* Second list item.

Here comes a mixed and nested list:

1. First ordered
   * First sub unordered
      1. First sub sub
      2. Second sub sub
   * Second sub unordered
2. Second ordered

## Tables

Here comes a table with columns and header:

 Col1 | Col2 | Col3 
:-----|:----:|-----:
  A   |      |   a  
  B   |  2   |   b  
  C   |  3   |   c

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

Here comes a table formatted in <qq>native</qq> ECML:

<table print-width="100%" screen-width="600px"
    align="left" id="tbl:example_4x4">
    <caption>
        Example of a simple 4x4 table without frame borders
    </caption>
    <shortcaption>
        Example of a 4x4 table (continued)
    </shortcaption>
    <colgroup>
        <col width="45%"/>
        <col width="55%"/>
    </colgroup>
    <tr>
        <td>First column, first row  </td>
        <td>Second column, first row </td>
    </tr>
    <tr>
        <td>First column, second row </td>
        <td>Second column, second row</td>
    </tr>
</table>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua.

## Listings

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Here is a standard indented listing that is *not* going to be auto-highlighted:

    #include <stdio.h>

    int main(int argc, char *argv[])
    {
        printf("Hello World!\n");
        return 0;
    }

Here comes <qq>Hello World</qq> in C:

```c
#include <stdio.h>

int main(int argc, char *argv[])
{
    printf("Hello World!\n");
    return 0;
}
```

And here comes <qq>Hello World</qq> in Python:

```python3
import sys
sys.stdout.write("Hello World!\n")
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua.

## ECML Blocks

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua.

<p>
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua.
</p>

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur.

<table print-width="100%" screen-width="600px"
    align="left" id="tbl:example_grid" frame="top,bottom"
    print-rulewidth="1pt" screen-rulewidth="1px" rulecolor="#000000">
    <colgroup>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
        <col width="25%"/>
    </colgroup>
    <th frame="rowsep">
        <td colspan="4"><b>Header</b></td>
    </th>
    <tr frame="colsep">
        <td frame="rowsep">1</td><td>2</td><td>3</td><td>4</td>
    </tr>
    <tr frame="colsep">
        <td>5</td><td frame="rowsep">6</td><td>7</td><td>8</td>
    </tr>
    <tr frame="rowsep,colsep">
        <td>9</td><td>10</td><td>11</td><td frame="rowsep">12</td>
    </tr>
    <tr>
        <td>13</td><td>14</td><td>15</td><td>16</td>
    </tr>
</table>

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
deserunt mollit anim id est laborum.

## Images

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
![Gradient](../docs/gradient.png) eiusmod tempor incididunt ut labore et dolore magna
aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

![Gradient](../docs/gradient.png)

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

