% This is an updated version of rbfin.cls built upon the original document. Author: Eduardo Horta, 2020-07-02

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEADER, PACKAGES, BASIC CONFIGS, ETC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rbfin}[2002/07/17 Standard LaTeX rbfin class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[10pt,twoside]{article}

\usepackage[a5paper, left=2cm, right=2cm, top=2cm, bottom=2cm]{geometry}

\usepackage[utf8]{inputenc} % Accept different input encodings
\usepackage[T1]{fontenc} % Standard package for selecting font encodings
\usepackage[brazilian,english]{babel} % Multilingual support

\usepackage[stable, flushmargin, symbol]{footmisc} % A collection of ways to change the typesetting of footnotes

\usepackage{mathtools} % Mathematical tools to use with amsmath
\usepackage{amssymb}
\usepackage{amsthm}

\usepackage{icomma} % comma as decimal separator
\usepackage{moresize} % more font sizes with LATEX - CTeX

\usepackage{fancyhdr} % Extensive control of page headers and footers
\usepackage{afterpage} % Execute command after the next page break

\usepackage{indentfirst} % Indent first paragraph after section header
\usepackage{setspace} % Provides support for setting the spacing between lines in a document

\usepackage{microtype} % provides a LaTeX interface to the micro-typographic extensions that were introduced by pdfTeX and have since also propagated to XeTeX and LuaTeX
\usepackage{siunitx} % provides a set of tools for authors to typeset quantities in a consistent way. The package has an extended set of configuration options which make it possible to follow varying typographic conventions with the same input syntax. The package includes automated processing of numbers and units, and the ability to control tabular alignment of numbers.
\usepackage{orcidlink} % provides a command to insert the ORCiD logo, which is hyperlinked to the URL of the researcher whose iD was specified.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures, tables and captions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%\usepackage{float} % Improved interface for floating objects
\usepackage[capposition=top]{floatrow}
\usepackage{placeins} % Control float placement (use \FloatBarrier to prevent floats from violating a section barrier)
\usepackage{longtable} % Allow tables to flow over page boundaries
\usepackage{array} % An extended implementation of the array and tabular environments
\usepackage{booktabs} % The package enhances the quality of tables in LATEX, providing extra commands as well as behind-the-scenes optimisation

% Define column types L, C and R which accept specification of column width similarly to, e.g., p{1cm}, cf. https://tex.stackexchange.com/questions/12703/how-to-create-fixed-width-table-columns-with-text-raggedright-centered-raggedlef
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}

\usepackage{multirow} % Create tabular cells spanning multiple rows
% \usepackage{colortbl} % The package allows rows and columns to be coloured, and even individual cells
% \usepackage{dcolumn} % Align on the decimal point of numbers in tabular columns. See: https://tex.stackexchange.com/questions/141671/combine-column-types-defined-in-dcolumn-with-tabularx
% \usepackage{diagbox} % Table heads with diagonal lines
\usepackage[figuresright]{rotating} % Rotation tools, including rotated full-page floats

% \usepackage{eepic} % Extensions to epic and the LATEX picture drawing environment

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alter some LaTeX defaults for better treatment of figures:
% source: https://aty.sdsu.edu/bibliog/latex/floats.html
% See p.105 of "TeX Unbound" for suggested values.
% See pp. 199-200 of Lamport's "LaTeX" book for details.
% General parameters, for ALL pages:
\renewcommand{\topfraction}{0.9}	% max fraction of floats at top
\renewcommand{\bottomfraction}{0.8}	% max fraction of floats at bottom
% Parameters for TEXT pages (not float pages):
\setcounter{topnumber}{2}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{4} % 2 may work better
\setcounter{dbltopnumber}{2} % for 2-column pages
\renewcommand{\dbltopfraction}{0.9}	% fit big float above 2-col. text
\renewcommand{\textfraction}{0.07}	% allow minimal text w. figs
% Parameters for FLOAT pages (not text pages):
\renewcommand{\floatpagefraction}{0.7}	% require fuller float pages
% N.B.: floatpagefraction MUST be less than topfraction !!
\renewcommand{\dblfloatpagefraction}{0.7}	% require fuller float pages

% remember to use [htp] or [htpb] for placement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Caption and subcaption config.
\usepackage{subcaption}
\captionsetup[sub]{size=scriptsize, textfont=rm, belowskip=1pt, aboveskip=0pt, justification=justified, singlelinecheck=off}
\captionsetup[figure]{size=small, labelfont=bf, textfont=bf, justification=centering, singlelinecheck=off}
\captionsetup[table]{size=small, labelfont=bf, textfont=bf, justification=centering, singlelinecheck=off}
\captionsetup{labelsep=newline}
\captionsetup{belowskip=0cm,aboveskip=0cm}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Other packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{hyperref}
\hypersetup{colorlinks,bookmarksnumbered,allcolors=MidnightBlue}
\usepackage[inline]{enumitem}

\usepackage[titletoc]{appendix} % Extra control of appendices

\usepackage{xurl} % Verbatim with URL-sensitive line breaks
\urlstyle{rm} % Use the rm font for URLs
\newcommand{\email}[1]{%
\footnote{\href{mailto:#1}{#1}}
}

\usepackage{lipsum} % Lorem ipsum dummy text generator

\usepackage{natbib,har2nat} % for references in harvard+dcu style
\renewcommand{\harvardurl}{\textbf{URL:} \url}
\setcitestyle{aysep={,}}

\usepackage[table,dvipsnames]{xcolor}

\usepackage[
type={CC},
modifier={by},
version={4.0},
]{doclicense} % put your document under a license and include a link to read about the license or include an icon or image of the license.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FONT HANDLING AND CODE HIGHLIGHTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand{\rmdefault}{ptm} % sets the default font to times new roman
\usepackage{mathptmx} % sets math fonts to times new roman
\usepackage{bm} % use, e.g., \bm{\alpha} for \alpha in bold with mathptmx fonts

\usepackage{nimbusmono} % uses nimbus for monospaced fonts
\usepackage{anyfontsize} % prevents some warning messages regarding font sizes
\usepackage{scalefnt} % \scalefont{2} selects the current font in twice the current size. \scalefont{.75} reduces the current font size by three quarters.

\usepackage[autostyle, english = american]{csquotes}
\MakeOuterQuote{"}

\usepackage{upquote} % correctly displays ' in verbatim and listings environments
\usepackage{verbatim}

\usepackage{listings}
\lstset{basicstyle=\ttfamily,breaklines=true}
\definecolor{backcolour}{rgb}{0.97,0.97,0.97}
\definecolor{codeblue}{rgb}{0.1,0.1,0.6}
\definecolor{codered}{rgb}{0.6,0.0,0.2}
\definecolor{codegreen}{rgb}{0,0.5,0}

\lstdefinestyle{mystyle}{
identifierstyle=\color{codeblue},
backgroundcolor=\color{backcolour},
commentstyle=\color{codegreen},
keywordstyle=\color{codeblue},
numberstyle=\ttfamily\scriptsize\color{Magenta},
stringstyle=\color{Magenta},
basicstyle=\ttfamily\small\color{codered},
breakatwhitespace=false,
breaklines=true,
captionpos=t,
keepspaces=true,
numbers=left,
numbersep=5pt,
showspaces=false,
showstringspaces=false,
showtabs=false,
tabsize=2,
rulecolor=\color{magenta}
}

\lstset{style=mystyle}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Custom definitions and layouts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a new counter for affiliations
\newcounter{affiliation}

% Store affiliations in an internal macro
\newcommand{\affiliations}[2]{%
  \stepcounter{affiliation}%
  \expandafter\def\csname affiliation\arabic{affiliation}\endcsname{#2}%
  \expandafter\edef\csname affiliationlabel#1\endcsname{\alph{affiliation}}%
}

% Define a command to produce a superscripted letter link
\newcommand{\affiliationlink}[1]{%
  \unskip\normalfont{\unskip\textsuperscript{, \csname affiliationlabel#1\endcsname}}%
}

% Define a command to produce the full affiliation name with its superscript
\newcommand{\affiliationname}[1]{%
  \normalfont{\small \textsuperscript{\csname affiliationlabel#1\endcsname}\csname affiliation#1\endcsname}\\%
}

\newcommand{\myabstract}[1]{
\iflanguage{brazilian}{\textbf{Resumo}\,\,}{{\bf Abstract}\,\,}%
#1
}

\newcommand{\keywordslist}[1]{%
  \iflanguage{brazilian}{\textbf{Palavras-chave}}{\textbf{Keywords}}: #1%
}

\newcommand{\jelcodeslist}[1]{%
  \iflanguage{brazilian}{\textbf{Códigos JEL}}{\textbf{JEL codes}}: #1%
}

\newcommand{\autor}[1]{\gdef\@autor{#1}}
\newcommand{\autorlong}[1]{\gdef\@autorlong{#1}}
\newcommand{\shorttitle}[1]{\gdef\@shorttitle{#1}}

\pagestyle{fancyplain}

\renewcommand{\headrulewidth}{0 pt}
\renewcommand{\footrulewidth}{0 pt}

% Page layout
\pagestyle{plain}
\fancyhead{}
\fancyhead[CE]{\rmfamily\scriptsize\@autor}
\fancyhead[CO]{\rmfamily\scriptsize\@shorttitle}
\fancyfoot{}
\fancyfoot[C]{\slshape\scriptsize \href
{http://bibliotecadigital.fgv.br/ojs/index.php/rbfin/index}
% {Brazilian Review of Finance (Online)}
{Revista Brasileira de Finanças (Online)}
\rbfinvolume{},
\rbfinyear{}}
\fancyfoot[LE]{\rmfamily\small\thepage}
\fancyfoot[LO]{\href{https://creativecommons.org/licenses/by/4.0/}%
\doclicenseIcon%
}
\fancyfoot[RO]{\rmfamily\small\thepage}
\fancyfoot[RE]{\href{https://creativecommons.org/licenses/by/4.0/}%
\doclicenseIcon
}

\fancypagestyle{primeirapagina}{%
\fancyhf{}
\setlength{\footskip}{21pt}
\fancyfoot[L]{\tiny
{%
%\slshape%
\href
{http://bibliotecadigital.fgv.br/ojs/index.php/rbfin/index}
{Revista Brasileira de Finanças (Online)}
% {Brazilian Review of Finance (Online)},
Rio de Janeiro,
\textcolor{BrickRed}{Vol. \rbfinvolume,}
% \textcolor{BrickRed}{No. \rbfinnumber,}
\textcolor{BrickRed}{\rbfinyear.}
% \textcolor{BrickRed}{\rbfinpages}
ISSN 1679-0731, ISSN online 1984-5146}
\\[2pt]
{\rmfamily \href{https://creativecommons.org/licenses/by/4.0/}{\doclicenseIcon}
\rbfinyear{} --
% \href
% {https://www.sbfin.org.br}
% {Sociedade Brasileira de Finanças},
The Authors,
under a \doclicenseLongNameRef{} license.
}
}
}

\renewcommand{\and}{\\[3pt]}

\newcommand{\pagina}[1]{\setcounter{page}{#1}}

\renewcommand{\maketitle}{%
\thispagestyle{primeirapagina}
\begin{flushleft}
\renewcommand*{\thefootnote}{\fnsymbol{footnote}}
\DefineFNsymbols*{mysymbols}{{}{\textdagger}{\textdaggerdbl}{*}{**}{***}{****}}
\setfnsymbol{mysymbols}
{\begin{singlespace}
\bfseries \LARGE \rmfamily{\@title}
\end{singlespace}
}\footnote{%
{{\bfseries \iflanguage{brazilian}{Como citar}{How to cite}}: \@autorlong{}. \@title{}. {\slshape Revista Brasileira de Finanças, \rbfinvolume{}}, \rbfinpages{}. {\urlstyle{rm}\url{https://doi.org/\rbfinDOI}}%
}
\\
\iflanguage{brazilian}{Submetido em}{Submitted on} \rbfinsubmitted.
%
% Revised on \rbfinrevised.
%
% \iflanguage{brazilian}{Aceito em}{Accepted on} \rbfinaccepted.
%
\iflanguage{brazilian}{Publicado \emph{on-line} em}{Published online on} \rbfinpublished.
\\
\iflanguage{brazilian}{Editor responsável}{Editor in charge}: \rbfineditor.
}
\vskip.5cm
\@author
\end{flushleft}
\renewcommand*{\thefootnote}{\arabic{footnote}}
\setcounter{footnote}{0}}

\renewcommand{\section}{\@startsection {section}{1}{\z@}%
{-2.5ex \@plus -1ex \@minus -.2ex}%
{1.3ex \@plus.2ex}%
{\normalfont\bfseries\rmfamily}}

\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
{-2.0ex\@plus -1ex \@minus -.2ex}%
{1.0ex \@plus .2ex}%
{\normalfont\bfseries\rmfamily}}

\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
{-2.0ex\@plus -1ex \@minus -.2ex}%
{1.0ex \@plus .2ex}%
{\normalfont\bfseries\rmfamily}}%

% \makeatletter
\def\@seccntformat#1{\@ifundefined{#1@cntformat}%
{\csname the#1\endcsname\quad}%
{\csname #1@cntformat\endcsname}%individual control
}
\def\thesection{\arabic{section}}
\def\section@cntformat{\thesection.\quad}
\def\thesubsection{\thesection.\arabic{subsection}}
\def\thesubsubsection{\thesubsection.\arabic{subsubsection}}
% \makeatother

\renewenvironment{abstract}
{\footnotesize
\list{}{%
\setlength{\leftmargin}{5mm}% <---------- CHANGE HERE
\setlength{\rightmargin}{\leftmargin}%
}%
\item\relax}
{\endlist}

\renewcommand\footnoterule{%
\kern-3\p@
\hrule\@width0.4\columnwidth
\kern1.6\p@}

\setlength{\textfloatsep}{10pt plus 2pt minus 4pt}
\setlength{\intextsep}{10pt plus 2pt minus 4pt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Custom environments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\theoremstyle{definition}
\newtheorem{theorem}{\iflanguage{brazilian}{Teorema}{Theorem}}
\newtheorem{lemma}{\iflanguage{brazilian}{Lema}{Lemma}}
\newtheorem{proposition}{\iflanguage{brazilian}{Proposição}{Proposition}}
\newtheorem{corollary}{\iflanguage{brazilian}{Corolário}{Corollary}}
\newtheorem{definition}{\iflanguage{brazilian}{Definição}{Definition}}
\newtheorem{example}{\iflanguage{brazilian}{Exemplo}{Example}}
\newtheorem{remark}{\iflanguage{brazilian}{Comentário}{Remark}}
\newtheorem{conjecture}{\iflanguage{brazilian}{Conjectura}{Conjecture}}
\renewcommand{\qedsymbol}{$\blacksquare$}
\makeatletter
\renewenvironment{proof}[1][\proofname]{\par
\pushQED{\qed}%
\normalfont \topsep6\p@\@plus6\p@\relax
\trivlist
\item[\hskip\labelsep
\bfseries
#1\@addpunct{.}]\ignorespaces
}{%
\popQED\endtrivlist\@endpefalse
}
\makeatother

\newcommand{\rbfinappendix}{
\newpage
\appendix
%\renewcommand{\thesection}{}
%\@addtoreset{table}{section}
%\@addtoreset{figure}{section}
%\setcounter{section}{1}
\setcounter{table}{0}
\setcounter{figure}{0}
\setcounter{footnote}{0} % inicia a contagem do footnote apos o apendice
\renewcommand{\thetable}{\thesection\arabic{table}}
\renewcommand{\thefigure}{\thesection\arabic{figure}}
\renewcommand{\thefootnote}{\thesection\arabic{footnote}} % altera a numeracao do footnote apos apendice
}
\renewcommand*{\le}{\leqslant}
\renewcommand*{\leq}{\leqslant}
\renewcommand*{\ge}{\geqslant}
\renewcommand*{\geq}{\geqslant}

\interfootnotelinepenalty=10000
\setlength\parskip{0.07cm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
