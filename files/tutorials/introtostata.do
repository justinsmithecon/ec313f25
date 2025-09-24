************INTRODUCTION TO STATA - EC306 - FALL 2025***************************


**Preamble;
*---------;

	*The command below tells Stata to use ";" to indicate the end of a line of code

		# delimit ;

	*This file will walk you through the basic commands that you might
	use if you were doing statistics with Stata.  The first thing to note is that
	the asterisk denotes a comment, which is useful for writing notes to yourself,
	but does not execute any particular command;

	*It is normally useful to start of Stata with a few preamble command, to make
	our lives easier as we run the dofile.  The first command below tells Stata to
	clear whatever information is currently in memory, so we can start fresh.  The
	second tells Stata not to stop displaying output as it scrolls through the output
	screen.  The third tells Stata to close any "log" files (discussed below) that
	happen to already by open.  Normally, if there were no log open, Stata would stop
	and return an error.  The command "cap" in front of "log close" tells Stata
	to just keep going even if an error occurs (in this case, the error might be
	that no log file is open).;

		clear;
		set more off;
		cap log close;
			
**Setting a Working Directory;
*----------------------------;			
			
	*Now we will set the working directory.  This will typically be the folder
	where your data is stored.  As we work through this dofile in class, you will
	all have a different working directory.  To set the working directory, we use
	the command "cd", which stands for change directory.  This way we can call
	on files later without having to specify the entire path every time.  In the
	command below, replace the XXX with the directory where the data file is
	kept.  The easiest way to do this is to navigate to the folder where the data
	is stored in the windows finder, and then copy the path from the address
	bar at the top and paste it in place of the XXX below;

		cd "C:\Users\jusmith\OneDrive - Wilfrid Laurier University\Teaching\EC306";

		
**Logging Output;
*---------------;
		
	*Most people like to keep a record of their Stata session, so that they can
	go back and reference the results if necessary.  To do so, we use the "log"
	function.;

		log using "intro to stata.log", replace;	
		

**Loading Stata Data;
*-------------------;		
		
	*The usual first step in any statistical analysis is to load data.  In this
	tutorial, we will work with the 2022 Canadian Income Survey (CIS), titled
	CIS2022_PUMF.csv. Because this data is not in Stata format, we will need
	to import it.  To import a csv file, use the import command with the 
	delimited option;

		 import delimited "CIS2022_PUMF.csv", clear;
		
	*Notice how at the end of the command there is ",clear".  In Stata, commands
	written after a comma are optional (i.e. you can run the command without them,
	but sometimes they do things you want).  In this case, the option clears any 
	other data that happens to be stored in memory before loading the current one;


**Summarizing Data;
*------------------;

	*In this dataset are 210 variables. To get some general information about the
	dataset, use the describe command;

		describe;
	
	*This command tells us some overall information about the data: there are
	96, 302 observations, 210 variables.  For each variable, we are given the variable
	label, which in this case is just the name of the variable in all caps.  In
	other datasets, there may be a description of what the variable measures. 
	Unfortunately, data are rarely this clean.  When you encounter a situation
	where you do not know what the variables mean, you need to consult the 
	documentation that is published with the data.  You can find this in the 
	zip file with the data we downloaded;

	*Now suppose we want to take a "look" at the data.  There are various ways to do
	this, and one of them is to literally look at a list of the raw values.  To do 
	this, we use the "list" command.;

		*list;
		
	*This literally will list all values of all variables.  Maybe we don't want to 
	list everything.  What if we want to look only at a list of earnings and levels
	of schooling?  We would consult the documentation for the names of those 
	variables and what their values mean, and then type;

		list earng hlev2g;
		
	*Now what if we want to look only at a specific range of values for those
	two variables?  Suppose we want to look only at the first 50 observations;

		list earng hlev2g in 1/50;
		
	*Or, suppose we want to look only at the observations with earnings over
	100000 dollars;

		list earng hlev2g if earng >=100000;
		
	*The above examples illustrate that if we want to restrict to a certain number
	of observations, we use the "in" condition.  If we want to 
	restrict to data based on values of some variable, we use the "if" command. 
	Note that the "in" and "if" conditional statements can be applied to any
	other Stata command based on some restriction you want to impose;
	
	* Notice that there are some large values that are all the same for earnings.
	It is important to look at the documentation before doing any analysis on
	the data because sometimes "missing" values are stored with a large number,
	and if you don't notice this then it can completely invalidate any
	results you compute.  In this case, missing values are stored using the 
	number 999999999996.  If you don't do anything about this, Stata will think
	there are a bunch of people in your data with incomes of almost a trillion
	dollars.  To correct this, we can recode those values to missing.  Missing
	values in Stata are indicated with a ".";
	
		replace earng = . if earng == 999999999996;


	*There are two important things going on here.  First, the replace command
	takes the values of a variable and replaces them with another value.  The
	second is the different betewen the single "=" and the double "==".  Use
	the single = for assignment (assigning a value to a variable) and the double
	equal sign evaluate equality (in this case, if earnings equal 999999999996).
	This comes up often and can be confusing.
		
	*Usually when people look at data, they don't just list values.  They instead
	look at summary measures, like the mean, median, variance, etc.  Suppose we were
	interested in summarizing the data on earnings.  We could type the following;

		summarize earng;
									 
	*This provides us with some very basic information: the mean, standard deviation,
	min and max.  Notice that there are 81,163 values in this table, which is 
	less than the total because the missing values are not included. Suppose we 
	are interested in some in-depth statistics;

		summarize earng, detail;

	*Adding the option ",detail" at the end has given us a whole bunch more
	statistics, inluding percentiles.;

	*Like with other commands, we can add multiple variables and impose restrictions.
	Suppose we want the mean earnings and hours of work for those people with a 
	university degree;

		summarize earng alhrwk if hlev2g==4, detail;

	* Notice that there are values equal to 9996 for hours of work.  Those are
	missing values that we need to replaces;
	
		replace alhrwk = . if alhrwk == 9996;
		summarize earng alhrwk if hlev2g==4, detail;
		
	*In data analysis you will generally run into 2 types of variables: continuous
	and categorical. Continious variables can take any value along a given range, whereas
	categorical variables simply code observations into groups.  A key difference between
	the two is that usually the numerical values of continuous variables have meaning 
	(like with income), but the numerical values for categorical variables do not (like
	using 1 to represent men and 2 to represent women). 

	*We usually like to use the summarize continuous variables with means, standard
	deviations and things like that.  It usually does not make sense to summarize
	categorical variables this way because if they are coded with numbers, the numbers
	have no meaning.  Instead, we summarize categorical variables with frequency
	tabulations. One way to do this in Stata is with the "tab" command.  Below, I
	tabulate the frequency of men and women in the data.;
		
		tab sex;
		
	*From the documentation, 1 is men and 2 is women. We can see that there are
	slightly more women than men in this data;

	
**Generating new variables;	
*-------------------------;
	
	*Below, we are going to do some sample wage regressions, and interpret the 
	output.  In our wage regressions, we will want to use the natural
	logarithm of wages, because that allows us to interpret the estimates (times
	100) as the effect of x on income in percentage terms.  To generate the
	natural logarithm of wages, we would type;

		gen learng = ln(earng);	
		


	
**Estimating relationships between variables;	
*------------------------------------------;

	*Suppose we specify that the relationship between wages and schooling is
	learn42 = b0 + b1*hlev2g + e.  We know that we can estimate this slope 
	with OLS.  To estimate an equation by OLS, we use the "regress" command.  
	One wrinkle is that highest level of schooling is a categorical variable, so
	we cannot just put it into the regression as though it were continuous.  
	Instead, we need to break it into a series of dummy variables and put those
	into the regression.  You can create those dummy variables on your own, or
	use the "i." prefix in the regression command in front of the categorical 
	variable.  A simple regression of wages on schooling would look like;

		regress learng i.hlev2g;

	*By default, the i. prefix omits the lowest value of the categorical 
	variable as the reference (base) group.  You can change this by altering it
	slightly by putting "b" and the number you want to exclude following i in
	the syntax.  If we wanted to use high school graduates (value 2) as the
	base group, you would type;
	
		regress learng ib2.hlev2g;
		
		
	*Stata automatically spits out a table with the most relevant information.
	In the top left panel, we have the sum of squares decomposition, which will
	not really be that useful for us.  In the top right panel, we have the
	number of observations, and some summary statistics on the model fit, including
	the r-squared, and an F-test which test the restriction that all coefficients
	equal zero, against the alternative that at least one of them is non-zero. The 
	real meat is in the bottom panel, which gives us the estimated slope coefficients,
	and the results of t-test of significance for each one.	Recall that it's best
	to use p-values, since this will give us the lowest level of significance we
	can pick, and still reject the null hypothesis.;

	*Generally speaking, researchers will at least want to hold constant some other 
	variables that are correlated with schooling.  Normally in these regressions, 
	people put in age or experience, which is also categorical;

		regress learng ib2.hlev2g i.agegp;	

	*Notice how this changes the coefficient on schooling slightly. Now, a one year
	increase in schooling increases earnings by 9.52%  
	
**Visualizing data;	
*-----------------;

	*Suppose we wanted to visualze the relationship between two numerical
	variables, in this case earnings and income tax.  We could 
	do a scatterplot. Before that, replace the missing values of 
	income tax;
	
	
		replace inctx = . if inctx ==  999999999996;
		twoway scatter earng inctx;
		
	*With microdata, it is often not very useful to plot the raw data, since there
	are so many observations that it gets very noisy and obscures the picture. The
	pattern is much easier to see if we plot the average value of earnings for each
	level of education. To do that, we could use some of stata's user written commands.
	In this case, we will use the binscatter command.  First, download it;
	
		ssc install binscatter;
		
	*Now we can use the command;

		binscatter earng inctx;
		

	* Sometimes you want to plot a continuous variable against a categorical one.
	There are a few ways to do this, but a useful one is a box plot, which
	shows the distribution of the continuous variable at different values of
	the categorical one;
	
		graph box earng if hlev2g <6, over(hlev2g) nooutsides 
		title(Earnings by Level of Schooling);
		
	*In this graph I have also restricted the categories, added a title,
	and told stata not to include "outside values", which just make the
	graph noisy.


log close;
