\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{VersionHistoryDemo}[2021/11/26 Vesion History Demo Class]

\LoadClass[]{article}

\usepackage{etoolbox}
\usepackage{fancyhdr}
\usepackage{xcolor}
%\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}


% basic formatting
\setlength\parindent{0pt}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  START: \versionDateAuthorSummary            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Note: Commands used internally here start with @. 
% Define a counter to track history entries
\newcounter{@entryCounter}
\setcounter{@entryCounter}{0}

% Define a version history entry
% In this example, let's say we need to use
% version number, date, author and change summary
\newcommand\versionDateAuthorSummary[4]{%
  \stepcounter{@entryCounter}%
  \csdef{@entryVersion\the@entryCounter}{#1}
  \csdef{@entryDate\the@entryCounter}{#2}
  \csdef{@entryAuthor\the@entryCounter}{#3}
  \csdef{@entrySummary\the@entryCounter}{#4}}

% command to get entry value at (key, counter index)
\newcommand\@getEntryValue[2]{%
  \csuse{#1#2}}


% To show the version history using itemize.
\newcounter{@entryIndex}
\newcommand\@printVersionHistoryItemized{%
\begin{itemize}
\setcounter{@entryIndex}{0}%
\whileboolexpr
%    {test {\ifnumcomp{\value{@entryIndex}}{<}{\the@entryCounter}}}%
    {test {\ifnumcomp{\the@entryIndex}{<}{\the@entryCounter}}}%
    {\stepcounter{@entryIndex}
      \item 
        \textbf{\@getEntryValue{@entryVersion}{\the@entryIndex}} % 
        [\@getEntryValue{@entryDate}{\the@entryIndex}] %
        \textit{\@getEntryValue{@entryAuthor}{\the@entryIndex}}, %
        \@getEntryValue{@entrySummary}{\the@entryIndex}%
    }
\end{itemize}
}

% To show the version history in a tabular formmat
\newcommand\@printVersionHistoryAsTable{%
\begin{tabular}{cccc}
\bf Version & \bf Date & \bf Author(s) & \bf Change Summary\\\hline
\setcounter{@entryIndex}{0}%
\whileboolexpr
    {test {\ifnumcomp{\the@entryIndex}{<}{\the@entryCounter}}}%
    {\stepcounter{@entryIndex}
        \@getEntryValue{@entryVersion}{\the@entryIndex}% 
        & \@getEntryValue{@entryDate}{\the@entryIndex}%
        & \@getEntryValue{@entryAuthor}{\the@entryIndex} %
        & \@getEntryValue{@entrySummary}{\the@entryIndex}\\%
    }
\end{tabular}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  END: \versionDateAuthorSummary            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Front-page items
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\@documentTitle}{\colorbox{red!30}{Set document title by specifying \texttt{\textbackslash documentTitle}}}
\newcommand{\documentTitle}[1]{\edef\@documentTitle{#1}}

\newcommand{\@documentType}{\colorbox{red!30}{Set document type by specifying \texttt{\textbackslash documentType}}}
\newcommand{\documentType}[1]{\edef\@documentType{#1}}

\newcommand{\@documentTeamName}{\colorbox{red!30}{Set team name by specifying \texttt{\textbackslash documentTeamName}}}
\newcommand{\documentTeamName}[1]{\edef\@documentTeamName{#1}}


\fancypagestyle{coverpagestyle}
{
   \fancyhf{}
   \fancyhead[L]{Fantastic Company}
   \fancyfoot[L]{Confidential}
   \fancyfoot[R]{Living, Loving \& Learning}
   \renewcommand{\headrulewidth}{4pt} % set to 0pt to remove
   \renewcommand{\footrulewidth}{4pt}
}

\fancypagestyle{mainpagestyle}
{
   \fancyhf{}
   \fancyhead[R]{Section \thesection}
   \fancyfoot[R]{Page \thepage}
   \renewcommand{\headrulewidth}{4pt} % set to 0pt to remove
   \renewcommand{\footrulewidth}{4pt}
}

\AtBeginDocument{%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START: set last entries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifnum\the@entryCounter=0
  % If no entry is entered, show an instruction
  \newcommand\@noEntryMessage{\colorbox{red!30}{See version history}}
  \newcommand\@lastEntryAuthor{\@noEntryMessage}
  \newcommand\@lastEntryDate{\@noEntryMessage}
  \newcommand\@lastEntryVersion{\@noEntryMessage}
  \newcommand\@lastEntrySummary{\@noEntryMessage}
\else
  % The last entry values. 
  \newcommand\@lastEntryAuthor{\@getEntryValue{@entryAuthor}{\the@entryCounter}}
  \newcommand\@lastEntryDate{\@getEntryValue{@entryDate}{\the@entryCounter}}
  \newcommand\@lastEntryVersion{\@getEntryValue{@entryVersion}{\the@entryCounter}}
  \newcommand\@lastEntrySummary{\@getEntryValue{@entrySummary}{\the@entryCounter}}
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% END: set last entries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% START: cover page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\thispagestyle{coverpagestyle}

\begin{center}
  {\large \@documentTitle}
\end{center}

This is a front page containing adminstrative information:

\begin{itemize}

  \item Document Type: \@documentType

  \item Team: \@documentTeamName
  
  \item Author: \@lastEntryAuthor

  \item Version: \@lastEntryVersion
  
  \item Date: \@lastEntryDate
  
\end{itemize}


\clearpage

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% END: cover page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START: main page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set style
\pagestyle{mainpagestyle}

% Show version history
\section*{Version History}

\ifnum\the@entryCounter=0

%%%% If no entry is entered, show instruction how to add one. 

Please set the first entry for the version history before \texttt{\textbackslash begin\{document\}}. 
For example, 

{\footnotesize
\colorbox{red!30}{
\texttt{\textbackslash versionDateAuthorSummary\{v1.0\}\{2016-07-19\}\{Anna Great\}\{The initial version.\}}
}
}

\else

%%%% If there are entries, show them. 
%%%% Here, we should two examples

Let's show the version history in an itemized format. 

\@printVersionHistoryItemized

\bigskip

Or, show it in a tabular format

\bigskip

\@printVersionHistoryAsTable

\bigskip

Or, if you want, add your own style to the class (.cls) file.
\fi

\tableofcontents

\clearpage

}
