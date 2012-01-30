#!/usr/bin/perl

=head
 This is the file you want to use NOT the Test_Script file.

This script will help you set up a Git Hub Repo, it will 
initailize an empty repo on your local machine to your 
Git Hub account online. 
It will also add a blank README file in your repo if you choose, 
you can edit the README later then use this script to 'push' it 
to your git hub repo.
It will also add any other file you choose too as well.
Use option 1 to set up your repo, option 2 to add to an
already existing Git Hub repo.
=cut


use 5.10.1;
use strict;
use Cwd;

#Variables
my $file ;
my $dir;
my $cwDir = getcwd;
my $selectDir;
my $user;
my $email;
my $repo;
my $addFile;
my $select;
my $selectReadme;
my $menuSelect;
my $commitMssg;
my $lengthcommitMssg;

#Start menu function
sub startMenu{
	
print ("\nWhat would you like to do today?\n");
print (" 1 Set up a Git Hub Repo\n");
print (" 2 Push a file to an already existing Repo\n");
print (" 3 Exit(0)\n");
$menuSelect = <STDIN>;
chomp $menuSelect;					# chomp used to remove carrige return
if ($menuSelect == 1 ){
	userInfo();						# run userInfo() function 
}
	
	elsif( $menuSelect == 2 ){			
		useCWD();					# run useCWD() function to get user's directory
	    
}
	else{
		exit(0);
}
}
#Current Working Directory function
sub useCWD{
	print ("\nYou are in " .$cwDir);
	print ("\nDo you want to use the current directory? yes or no..\n");  	#check if user wants to use the current directory
	$selectDir = <STDIN>;	
	chomp $selectDir;
			if ($selectDir eq 'yes' && $menuSelect == 1 ){					#use current directory to set up repo					
				git();
			}
				elsif  ($selectDir eq 'yes' && $menuSelect == 2){			#use current directory to add/push another file to existing repo
					addanother();
				}
				else{
					dirPath();												#run dirPath() to change directory
				}
			}

#Function to add file
sub addanother{
	
print("\nEnter file name.\n");
$addFile = <STDIN>;
chomp $addFile;
			if (open(File, $addFile)){										#check file name
		       print ("File name is ok\n");
		       system 'git add '.$addFile;
		       checkLength();
		   }
	         
	          else{															# if file name is incorrect re-start addanother()function
		        print ("****File not found, please check file name and try again****\n");
		        addanother();
			}
		}
sub checkLength{
	print ("Add small message for the commit NO SPACES use an underscore, \nexample:\"added_file\".Use less than 30 chars\n");
		       $commitMssg = <STDIN>;
		       chomp $commitMssg;
		       $lengthcommitMssg = length ($commitMssg);					#use built-in 'length' function to get No. of chars
		       if ($lengthcommitMssg > 30){
				   print ("\nYour message is too long, please try a shorter one\n");
				   checkLength();
			   }
			   else{
					system "git commit -m".$commitMssg.">>commit_record" || die '\nCannot add commit message: $!';#add commit message and append 'commit_record' file
					open(NFH, '>>commit_record');
					if (! print NFH $commitMssg," ", scalar(localtime)."\nEND OF LINE\n*\t*\t*\t*\t*\t*\n"){	 #add timestamp 
						warn "Cannot write to file: $!";
					}
					system 'git push -u origin master'|| die '\nCannot push to repo:$!';	     				 #push file to repo	
					errorcheck();						                                        				 # run errorcheck() function to capture any error's
					}						
		}			
				

# Function to get username and email from user		
sub userInfo{

	print ("Enter your user name\n");
	$user = <STDIN>;
	chomp $user;
	print ("\nEnter your email address\n");
	$email = <STDIN>;
	chomp $email;
	useCWD();
}



#Function to get and check directory path
sub dirPath{
	
	print ("\nEnter a directory path..\n");
	$dir = <STDIN>;
	chomp ($dir);
		if (opendir(DIR, $dir)) {											#if dir path is ok then change to dir and list files
		chdir $dir;
		print ("You are now in directory >>> ", $dir, "\n");
		system 'ls -l';
			if ($menuSelect == 2 ){
				addanother();												# run addanother() function to get file if user chose option 2
			}
				else{
					git();													# run git() function to connect to git hub if user chose option 1
				}
}
					else {													#if dir path is incorrect re-start function
						print ("\n****The directory can not be found, please try again****");
						dirPath();
}
}
#Declare function for connecting to Git Hub
sub git{


	print ("\nEnter the name of the repo you created on Git Hub.\n");
	$repo = <STDIN>;															#get name of repo in order to connect to git hub
	chomp $repo;

	system 'git config --global user.name'. $user || die "Cannot set user name: $!";	#set global user name and email for git hub repo
	system 'git config --global user.email'. $email || die "Cannot set email: $!";


#Add README
print ("Do you wish to add a README file?  yes or no..\n");
$selectReadme = <STDIN>;
	chomp $selectReadme;
			if ($selectReadme eq 'yes'){
				system 'git init' ;													#initiate repo, creat README file ('touch'), add README and add commit message
				system 'touch README';
				system 'git add README';
				system "git commit -m 'Added README' "; 
				system "git remote add origin git\@github.com:".$user."/".$repo.".git";
				system 'git push -u origin master';									# push file to git hub repo
				errorcheck();
}
		else{																# if user doesn't want a README user can chose to commit another file
		print ("\nDo you whish to add/commit another file?  yes or no..\n");
		$select = <STDIN>;
		chomp $select;
			if ($select eq 'yes' ){
			addanother();
		}
				else{														#if user chose 'no' script will re-display the start menu
					startMenu();
		  }
}
}

#A little error checking
sub errorcheck{
 if ($? == -1) {
	 print "failed to execute: $!\n";
 }
  elsif ($? & 127) {
                       printf "child died with signal %d, %s coredump\n",
                           ($? & 127),  ($? & 128) ? 'with' : 'without';
					   }
					   else {
                       printf "child exited with value %d\n", $? >> 8;
				       }
						
	 }
#Run Functions
startMenu();



