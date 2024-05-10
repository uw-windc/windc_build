%% ------------------------------------------------------------------------
%%	Note: ejb.cls has the header turned off (search ejb)
%% LaTeX 2e class file for the "Journal of Global Economic Analysis" (JGEA)
%% ------------------------------------------------------------------------
%%
%% This is the class file "jgea.cls" provided for the "Journal of Global
%% Economic Analysis" (JGEA). jgea.cls class file loads standard "article.cls" 
%% with appropriate setting and redefines the layout based on the JGEA style.
%%
%% Macros written by Zeynep Akgul and Altug Ozcelikkale 
%% for the "Journal of Global Economic Analysis".
%%
%% jgea.cls is provided for the convenience of the author. 
%% Please note that its usage does not guarantee complete adherence 
%% to format requirements for publication in JGEA. It is the author's 
%% responsibility to follow the guidelines and make sure the formatting 
%% requirements are fulfilled.
%%
%% Please feel free to use this style class as you see fit, provided 
%% that you do not make changes to the file. You are required to
%% rename this file and keep the history information in the file, if 
%% you DO make changes.
%%
%% -------------------
%% History of the file
%% -------------------
%% Version 1.0: 13 May 2016
%% TeX programming by Zeynep Akgul (ZA) and Altug Ozcelikkale (AO) 
%% Purdue University, USA
%%
%% Copyright 2016
%% JGEA and any individual authors listed elsewhere in this file.
%%
%% It may be distributed under the terms of the LaTeX Project Public
%% License, as described in lppl.txt in the base LaTeX distribution.
%% Either version 1.0 or, at your option, any later version.
%%
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
%%
%%
%% --------------
%% IDENTIFICATION
%% --------------
\newcommand\jgea@version{2016/05/15}
\newcommand\jgea@shortname{JGEA}
\newcommand\jgea@longname{Journal of Global Economic Analysis}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jgea}[\jgea@version \jgea@longname]

%% ------------------------
%% PRELIMINARY DECLARATIONS
%% ------------------------
% Load the article class with the desired options. Select 11pt and US letter.
\LoadClass[11pt,letterpaper]{article}

\RequirePackage[left=1.5in,right=1.5in,top=1.5in,bottom=1.5in,headheight=14pt,headsep=58pt,footskip=56pt]{geometry} 	% For margins. Heading base is ~48pt from top.
\RequirePackage{lineno} 		% For linenumbers 
\RequirePackage{calc} 			% For length calculations
\RequirePackage[osf,sc]{mathpazo} 		% For Palatino font type
\RequirePackage{courier} 		% Courier as monospace font
\RequirePackage{indentfirst} 	% For paragraph indentation
\RequirePackage{changepage} 	% Ensure narrow margins in abstract
\RequirePackage{titlesec}		% For section headers
\RequirePackage[usenames,dvipsnames,svgnames,table]{xcolor}  % For color settings

\definecolor{lightgray}{RGB}{230,230,230}
%\definecolor{lightgray}{gray}{0.95}	% New color for shaded tables
\setlength{\parindent}{0.2in}	% Paragraph indentation is 0.2pt
\setlength{\parskip}{0pt}

%% -------
%% OPTIONS
%% -------
%% jgea.cls is based on the standard article.cls. However only a small subset of
%% the article class options must be made available to the user to maintain the precise
%% formatting of the template.
%%
%% Define jgea specific class options here:
%% Options supported by jgea.cls:
%% 		'draft' 	  : Include figures as plain bounding boxes only, indicate
%% 						overflown lines with black filled boxes on the margin. Allows
%%						faster compilation and is useful for debugging.
%% 		'linenumbers' : Print line numbers on left margin.
%% 		'showframe'   : Display a frame on each page indicating the margins. Useful
%%						for identifying overflown text and floats.
%%
%% ! Please use jgea WITHOUT ANY OPTIONS for FINAL submission !
%%

% Allow only a small subset of article class/package options:
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{article}} % Faster compilation
\DeclareOption{linenumbers}{\linenumbers} % For line numbers
\DeclareOption{showframe}{\PassOptionsToPackage{\CurrentOption}{geometry}} % For margins

% Any option other than above will generate an error:
\DeclareOption*{\OptionNotUsed
	\ClassError{jgea}
	{Option '\CurrentOption' is not available for the \jgea@shortname\space class}
	{Remove option '\CurrentOption' and try again}}
\ProcessOptions\relax

%% -------------------------------------------
%% VOLUME, YEAR, ISSUE NO, ARTICLE NO, PAGE NO
%% -------------------------------------------
%% Volume number. Latex gives a warning if this information is not inputed.
\def\volume#1{\gdef\@volume{#1}}
\gdef\@volume{\@latex@warning@no@line{No \noexpand\volume given}}

%% Publication year. Latex gives a warning if this information is not inputed.
\def\pubyear#1{\gdef\@pubyear{#1}}
\def\@pubyear{\@latex@warning@no@line{No \noexpand\pubyear given}}

%% Issue number. Latex gives a warning if this information is not inputed.
\def\issueno#1{\gdef\@issueno{#1}}
\gdef\@issueno{\@latex@warning@no@line{No \noexpand\issueno given}}

%% Article number. Latex gives a warning if this information is not inputed.
\def\articleno#1{\gdef\@articleno{#1}}
\gdef\@articleno{\@latex@warning@no@line{No \noexpand\articleno given}}

%% Page number. Latex gives a warning if this information is not inputed.
\def\pagerange#1#2{\gdef\@firstpage{#1} \gdef\@lastpage{#2}}
\gdef\@firstpage{\@latex@warning@no@line{No \noexpand\pagerange given}}
\gdef\@lastpage{\@latex@warning@no@line{No \noexpand\pagerange given}}

%% ------
%% HEADER
%% ------
\RequirePackage{fancyhdr} 	% Customize pagestyle, header, title
\pagestyle{fancy} 			% Customize pagestyle, header, title
\lhead{}					% For left header
\rhead{}					% For right header
\renewcommand*{\headrulewidth}{0pt} % Remove header ruler
% Header Palatino 10 pt, italic, with volume, year, issue, article, page info.
%\chead{\small\selectfont{\itshape Journal of Global Economic Analysis}, Volume \@volume \space (\@pubyear), No. \@issueno, Article \@articleno, pp. \@firstpage -\@lastpage.} % with article number in the header

%%ejb (Turn the header off)
%\chead{\small\selectfont{\itshape Journal of Global Economic Analysis}, Volume \@volume \space (\@pubyear), No. \@issueno, pp. \@firstpage -\@lastpage.} % without article number in the header

%% ----------
%% TITLE PAGE
%% ----------
% Define title format here. Palatino 22pt, centered. 0 pt before 12 pt after paragraph spacing.
% Define author format here. Palatino 11 pt, centered. 0 pt before 18 pt after paragraph spacing. Author footnotes are numbered by a,b..

\renewcommand*\maketitle{
	{
		\thispagestyle{fancy}
		\def\thefootnote{\alph{footnote}}% author footnote style
		\setlength{\parskip}{0pt}
		\setlength{\parindent}{0pt}
		\null \vspace{-29.5pt}% by trial and error
		\begin{center}
			{\fontsize{22}{30.8}\selectfont\@title\par}% title style
			\vspace{25pt}% by trial and error
% Remove the ``By''	{\fontsize{11}{13.2}\selectfont\scshape By\space}% author style
			{\fontsize{11}{13.2}\selectfont\scshape\@author\par}% author style
			\vskip 21pt % by trial and error
		\end{center}
		\setcounter{footnote}{0}%
		\global\let\thanks\relax
		\global\let\maketitle\relax
		\global\let\@thanks\@empty
		\global\let\@author\@empty
		\global\let\@date\@empty
		\global\let\@title\@empty
		\global\let\title\relax
		\global\let\author\relax
		\global\let\and\relax
	}
}

\def\@affiliation\relax
\def\@affiliation#1#2{\gdef\textsuperscript{#1}\space#2}

%% -----------------------------
%% ABSTRACT, KEYWORDS, JEL CODES
%% -----------------------------
% Define abstract environment here. Palatino 11 pt, italic, right and left indentation 0.2in, second paragraph indentation 0.2in, 12 pt after paragraph spacing. 
\renewenvironment{abstract}{\begin{adjustwidth}{0.2in}{0.2in}\noindent \itshape\ignorespaces}{\end{adjustwidth}\vspace{9pt}}

% Define jel code environment here. Palatino 10 pt, right and left indentation 0.2in, 12 pt after paragraph spacing.
\newenvironment{jelcodes}{\begin{adjustwidth}{0.2in}{0.2in}\noindent\small JEL codes:}{\end{adjustwidth}\vspace{9pt}}

% Define keywords environment here. Palatino 10 pt, right and left indentation 0.2in, 12 pt after paragraph spacing.
\newenvironment{keywords}{\begin{adjustwidth}{0.2in}{0.2in}\noindent\small Keywords:}{\end{adjustwidth}\vspace{0pt}}

%% ----------------
%% SECTION HEADINGS
%% ----------------
% Define first level heading here. Palatino 11 pt.
\titleformat{\section}[block]
{\normalfont\normalsize\bfseries}{\thesection.}{0.25em}{}

% Define second level heading here. Palatino 11 pt, italic.
\titleformat{\subsection}[block]
{\normalfont\normalsize\itshape}{\thesubsection}{0.25em}{}

% Define first level heading here. Palatino 11 pt.
\titleformat{\subsubsection}[block]
{\normalfont\normalsize}{\thesubsubsection}{0.25em}{}

\titlespacing{\section} {0pt}{12pt}{7pt} 	 % 12 pt before and 6 pt after spacing
\titlespacing{\subsection} {0pt}{6pt}{7pt} 	 % 6 pt before and 6 pt after spacing
\titlespacing{\subsubsection}{0pt}{6pt}{7pt} % 6 pt before and 6 pt after spacing

\let\paragraph\relax	% Fourth level and above headings are not allowed.
\let\subparagraph\relax	% Fourth level and above headings are not allowed.

%% --------------
%% FOOTNOTE STYLE
%% --------------
% Define footnote format here. Palatino, 10 pt with numeric labels.
\def\footnote@style{\normalfont\small\selectfont}
\def\thefootnote{\arabic{footnote}}%
\def\@makefnmark{{\footnote@style\textsuperscript{\thefootnote}}}%
\long\def\@makefntext#1{\footnote@style\noindent\@makefnmark\ #1}%
\renewcommand{\footnoterule}{%
	\kern -3pt
	\hrule width 2in height 1pt
	\kern 6pt
}
\setlength{\skip\footins}{16pt} % Set space above footnote seperator

%% ---------
%% EQUATIONS
%% ---------
% Define equations here. Palatino, 11 pt, centered, right-numbered, 6 pt before and after paragraph spacing.
\RequirePackage[reqno]{amsmath}

% 6pt spacing before and after the equations
\g@addto@macro\normalsize{%
	\setlength\abovedisplayskip{6pt}
	\setlength\belowdisplayskip{6pt}
	\setlength\abovedisplayshortskip{6pt}
	\setlength\belowdisplayshortskip{6pt}
}

%% -----------
%% LIST STYLES
%% -----------
% Define list stylesh here. Palatino 11 pt, left indent 0.3in, hanging 0.25in, 6pt before and after spacing.
\RequirePackage[shortlabels]{enumitem} % Customize listings
% left indent 0.3in + hanging 0.25in. Hanging by trial and error
\setlist[itemize,1]{leftmargin=*,labelindent=0.3in,labelsep=0.15in} 
\setlist[enumerate,1]{label={\arabic*)},leftmargin=*,labelindent=0.3in,labelsep=0.15in} 
\setlist{itemsep=-4pt, topsep=6pt} % 6pt before paragraph spacing and singlespacing between items


%% -------------
%% CODE EXTRACTS
%% -------------
%% This template uses the listing style "jgea" defined in jgea.cls. 
%% The listings environment is customized in the jgea.cls file for code extracts with %% default jgea style. Additional customizations, e.g. language selection, syntax
%% highlighting, can be done in document preable using \lstset \lstdefinestyle commands
%% as described in package documentation: 
%% http://ctan.sharelatex.com/tex-archive/macros/latex/contrib/listings/listings.pdf
%%
% Define code extract style here. Courier 8pt, single spaced, 0.2in indentation, 6pt before and after paragraph spacing. 
\RequirePackage{listings} % For listings, code extracts.

% Define listing style for short code snippets here.
\lstdefinestyle{shortcode}%
{
	basicstyle       =\color{black}\ttfamily\scriptsize, % Courier 8pt, black
	breaklines       = true, 		% Break long lines 
	aboveskip        = 6pt,			% 6pt before paragraph spacing
	belowskip        = 6pt,			% 6pt after paragraph spacing
	xleftmargin      = 0.2in,		% 0.2in left indentation
	xrightmargin     = 0in,			% No right indentation
	breakindent      = 0pt,			% Indentation break
	columns          = flexible,	% For columns
	showstringspaces = false,  		% Don't show space characters
	showtabs  		 = false,		% Don't show tab characters
	sensitive 		 = false,		% Case sensitivity
}

% Define listing style for long code here.
\lstdefinestyle{longcode}%
{
	basicstyle       =\color{black}\ttfamily\scriptsize, % Courier 8pt, black
	breaklines       = true, 		% Break long lines 
	aboveskip        = 6pt,			% 6pt before paragraph spacing
	belowskip        = 6pt,			% 6pt after paragraph spacing
	xleftmargin      = 0.2in,		% 0.2in left indentation
	xrightmargin     = 0in,			% No right indentation
	breakindent      = 0pt,			% Indentation break
	columns          = flexible,	% For columns
	showstringspaces = false,  		% Don't show space characters
	showtabs  		 = false,		% Don't show tab characters
	sensitive 		 = false,		% Case sensitivity
	framerule		 = 0.5pt,		% Frame thickness
	frame			 = tb,			% Add top and bottom rules
	numbers			 = left,		% Add line numbers
	numberstyle	 	 = \color{black}\ttfamily\tiny,	% Number style
	numberblanklines = false,		
}

% Set lstlisting environment defaults
\lstset{style=shortcode}

%% --------------------------------------------------------
%% FLOATS: 1.TABLES, 2.FIGURES, 3. FLOAT CAPTIONS and NOTES
%% --------------------------------------------------------
% Define float format here. Paragraph spacing before and after floats are determined by spacing before and after float captions or float titles. Here we make sure no more spacing is added on top of the caption and title spacing. See 3. Float Captions and Notes below for paragraph spacing in floats.
\setlength{\textfloatsep}{0pt plus 2pt minus 0pt} 	% space before and after floats
\setlength{\intextsep}{0pt plus 2pt minus 0pt} 		% space before and after floats

%% --------
%% 1.TABLES 
%% --------
% Define table format here. Text in table Palatino 10pt. Horizontal lines in tables are 0.5pt.
\RequirePackage{booktabs} 			% For enhancing the table quality
% Top rule, bottom rule, mid rule
\setlength\heavyrulewidth{0.5pt}	% Rule width 0.5pt
\setlength\lightrulewidth{0.5pt}	% Rule width 0.5pt
\setlength\cmidrulewidth{0.5pt}		% Rule width 0.5pt

% Convenience commands for column alignment: Enable simultaneous specification of justification and column width in tabular e.g. L{0.5in} results in a left justified column 0.5 inches wide.
\RequirePackage{array}		% For \newcolumntype
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

%% ---------
%% 2.FIGURES
%% ---------
% Define figure format here. This is taken care of by the graphicx package. Figures are included in the template by the minipage environment.
\RequirePackage{graphicx} 	% Enable figure inclusion with \includegraphics
\DeclareGraphicsExtensions{.png,.pdf,.jpg} % Look for these extensions in order
\renewcommand{\figurename}{Figure}

%% --------------------------
%% 3.FLOAT CAPTIONS and NOTES
%% --------------------------
% Define float caption format here. 
\RequirePackage{caption}	% For float captions

% Define table caption format here. Palatino 10pt, bold, centered, 6pt before and 2pt after paragraph spacing.
\captionsetup[table]{labelfont=bf,labelsep=period,font=small,justification=centering, aboveskip=2pt,belowskip=6pt,list=no}
% Define figure caption format here. Palatino 10pt, bold, centered, 6pt before and 6pt after paragraph spacing.
\captionsetup[figure]{labelfont=bf,labelsep=period,font=small,justification=centering, aboveskip=6pt,belowskip=6pt,list=no}
% Define listings caption format here. Palatino 10pt, bold, centered, 6pt before and 2pt after paragraph spacing.
\captionsetup[lstlisting]{labelfont=bf,labelsep=period,font=small,justification=centering, aboveskip=6pt,belowskip=2pt,list=no}

% Define float notes and sources here. Notes and sources in Palatino 9pt, 0 pt before and 6pt after paragraph spacing.
\newcommand\floatnote[1]{\par\footnotesize\raggedright\textit{Notes:}\space#1\par\vspace*{6pt}}
\newcommand\floatsource[1]{\par\footnotesize\raggedright\textit{Source:}\space#1\par\vspace*{6pt}}

%% ----------
%% REFERENCES
%% ----------
% Define citation and reference format here. JGEA template uses jgea.bst bibliography style and natbib for references.
\RequirePackage{natbib}		% Use natbib for references

%% Define the hyperlinks and include url and doi in references.
%% This part from Dominique van der Mensbrugghe 05/12/16.
\RequirePackage{url}		% For url in references
\RequirePackage{hyperref}	% For hyperlink reference
\RequirePackage{doi}		% For doi in references
\RequirePackage{breakurl} 	% Keep url within margins
\definecolor{URLBlue}{rgb}{0,0,0.5} % Define new color for hyperlinks
\hypersetup{
	colorlinks   = true,	
	citecolor    = URLBlue,
	linkcolor    = URLBlue,
	urlcolor     = URLBlue
}
\urlstyle{same} 			% Use same font type and size for url as the text.
\setlength{\bibsep}{0.0pt} 	% Remove space between bib entries.
\setlength{\bibhang}{0.2in}	% 0.2in hanging indentation in bibliography

\makeatletter
%% Space between the double slash at the beginning of url address is too wide. The following reduces that space. 
\let\UrlSpecialsOld\UrlSpecials
\def\UrlSpecials{\UrlSpecialsOld\do\/{\Url@slash}\do\_{\Url@underscore}}%
\def\Url@slash{\@ifnextchar/{\kern-.11em\mathchar47\kern-.2em}%
	{\kern-.0em\mathchar47\kern-.08em\penalty\UrlBigBreakPenalty}}
\def\Url@underscore{\nfss@text{\leavevmode \kern.06em\vbox{\hrule\@width.3em}}}
\makeatother

%% ----------------
%% ACKNOWLEDGEMENTS
%% ----------------
% Define acknowledgement format here. Uses first level heading.
\newenvironment{acknowledgements}{\section*{Acknowledgements}}{}

%% -----------------------
%% APPENDIX and APPENDICES
%% -----------------------
%% Define the appendix format here. Appendix equations, tables, figures, listings should be given separate numbering. If there is only one appendix, it is labeled as "Appendix" and the format follows (1) Single Appendix below. If there are more than one appendix, they are labeled as Appendix A, Appendix B and the format follows (2) Multiple Appendices below.
%%
\RequirePackage[titletoc, title]{appendix}	% For customized appendices
\RequirePackage{chngcntr} % Separate numbering for equations, tables, figures in appendix

%% (1) Single Appendix:
% Don't use the default \appendix command. We define a custom appendix environment as follows. We should ask the user to use this environment instead of the default command.
\let\originalappendix\appendix
\let\appendix\relax
\newenvironment{appendix}{%
	% Generate page breaks after each Appendix section
	\newcommand{\sectionbreak}{\clearpage}
	% Format Appendix titles, including the Appendix name in the title.
	\titleformat{\section}[block]{\normalfont\normalsize\bfseries}{\appendixname.}{0.5ex}{}
	% Number equations, figures and tables within each appendix separately
	\counterwithin{equation}{section}
	\counterwithin{figure}{section}
	\counterwithin{table}{section}
	\counterwithin{lstlisting}{section}
	% Also redefine labels in Appendix to have the prefix, like A.1
	\renewcommand\theequation{A.\arabic{equation}}
	\renewcommand\thefigure{A.\arabic{figure}}
	\renewcommand\thetable{A.\arabic{table}}
	\renewcommand\thelstlisting{A.\arabic{lstlisting}}
}
{
	%Some of the commands need to be undone if appendix is going to be followed by additional text. This should be discouraged. For the time being, we ignore what happens after appendix environment ends. 
}

%% (2) Multiple Appendices:
% Appendices environment is already defined by the 'appendix' package. We modify the '\appendices' macro i.e the commands that are executed at the beginning of the environment, by additional formatting:
% Tip: Redefine the macro '\endappendices' if you need to modify the commands that are being executed at the end of appendices environment.
\let\originalappendices\appendices
\def\appendices{%
	% Generate page breaks after each Appendix section
	\newcommand{\sectionbreak}{\clearpage}
	% Format Appendix titles, including the Appendix name in the title.
	\titleformat{\section}[block]{\normalfont\normalsize\bfseries}{\appendixname~\thesection.}{0.5ex}{}
	% Number equations, figures and tables within each appendix separately
	\counterwithin{equation}{section}
	\counterwithin{figure}{section}
	\counterwithin{table}{section}
	\counterwithin{lstlisting}{section}
	% Also redefine labels in Appendix to have the section prefix, like A.1, B.2
	\renewcommand\theequation{\thesection.\arabic{equation}}
	\renewcommand\thefigure{\thesection.\arabic{figure}}
	\renewcommand\thetable{\thesection.\arabic{table}}
	\renewcommand\thelstlisting{\thesection.\arabic{lstlisting}}
	% Original appendices code executes here
	\originalappendices 
}

%% ---------------
%% End of jgea.cls
%% ---------------
