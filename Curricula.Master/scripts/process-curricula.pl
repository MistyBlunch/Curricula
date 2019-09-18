#!/usr/bin/perl -w

use strict;
use Lib::Common;
use Lib::GenSyllabi;
use Lib::GeneralInfo;
use Data::Dumper;

if(defined($ARGV[0])) { $Common::command = shift or Util::halt("There is no command to process (i.e. AREA-INST)");	}

# ok, Here we replace \'a by á, etc 
sub replacecodes()
{
	Util::precondition("parse_courses");
	Common::replace_special_characters_in_syllabi();
}

sub generate_general_info()
{
	foreach my $lang (@{$Common::config{SyllabusLangsList}})
	{
	}
	
	my $lang = $Common::config{language_without_accents};
	Common::read_all_min_max();
	Util::precondition("gen_syllabi"); 
	
	GeneralInfo::generate_lu_index();
	foreach my $lang (@{$Common::config{SyllabusLangsList}})
	{
		GeneralInfo::generate_description("prefix", $lang);			# CS: Computer Science, ...
	}
	GeneralInfo::generate_course_tables($lang); 					# Tables by semester
	GeneralInfo::generate_laboratories(); 							# List of Laboratories
# 	GeneralInfo::generate_distribution_area_by_semester();			# Table area by semester
	GeneralInfo::generate_distribution_credits_by_area_by_semester();
	
	GeneralInfo::generate_pie("credits");
	GeneralInfo::generate_pie("hours");
	GeneralInfo::generate_pie_by_levels();

	foreach my $lang (@{$Common::config{SyllabusLangsList}})
	{
		Util::print_color("Generating Posters in $lang ...");
		GeneralInfo::generate_curricula_in_dot("small", $lang);
		#error??? system("cp ".Common::get_template("in-small-graph-curricula-file")." ".Common::ExpandTags(Common::get_template("out-small-graph-curricula-file"), $lang);
		GeneralInfo::generate_curricula_in_dot("big", $lang);   
		GeneralInfo::generate_poster($lang);
		GeneralInfo::generate_all_outcomes_by_course($lang);
	}
	
	GeneralInfo::generate_all_topics_by_course($lang);
	Util::print_message("Check point ... generate_general_info() ...");  exit;
	GeneralInfo::generate_list_of_outcomes();
	GeneralInfo::generate_list_of_courses_by_outcome($lang);
 
	GeneralInfo::generate_list_of_courses_by_area($lang);
	foreach my $lang (@{$Common::config{SyllabusLangsList}})
	{
		GeneralInfo::generate_compatibility_with_standards($lang);
		#	GeneralInfo::generate_courses_by_professor();
	# 	GeneralInfo::generate_faculty_info();
		GeneralInfo::generate_courses_by_professor($lang);
		GeneralInfo::generate_professor_by_course($lang);
	}

 	GeneralInfo::process_equivalences();

# 	generate_sql_for_new_courses();
# 	
# 	generate_tables_for_advance();
# 	generate_courses_for_advance();
# 
# 	Common::generate_bok_sql("CS-bok-macros.sty", "$Common::out_sql_dir/bok.sql");
# 	print "gen-malla OK !\n";
#  	print "alias de HU302 = $Common::course_info{HU302}{alias}\n";
}

sub copy_basic_files()
{
	##system("cp ".Common::get_template("out-current-institution-file")." ".Common::get_template("OutputTexDir"));
	#system("cp ".Common::get_template("InLogosDir")."/$Common::config{institution}* ".Common::get_template("OutputFigDir"));
	#system("cp ".Common::get_template("in-small-graph-curricula-file")." ".Common::get_template("OutputTexDir"));
	##system("cp ".Common::get_template("in-pdf-icon-file")." ".Common::get_template("OutputHtmlFigsDir"));
	#exit;
}

sub main()
{
# 	my $codcour = "CS242";
# 	print Dumper (\%{$Common::course_info{$codcour}});
# 	if( defined($Common::course_info{$codcour}{alias}{abc}{xyz}) )
# 	{	print Dumper (\%{$Common::course_info{$codcour}});	}
# 	exit;
	
	Util::begin_time();
	Common::setup(); 
	foreach my $lang (@{$Common::config{SyllabusLangsList}})
	{
	      Util::print_message("Reading BOK in $lang ...");
		  Common::read_bok($lang);
	      Util::print_message("Generating BOK in $lang ...");
	      Common::generate_bok($lang);
	}  
	Common::gen_only_macros();
# 	Common::check_preconditions();
# 	replacecodes();

    GeneralInfo::detect_critical_path();   
	GenSyllabi::process_syllabi();
	
	foreach my $lang (@{$Common::config{SyllabusLangsList}})
	{
	    Util::print_color("Generating books in $lang ...");
		GenSyllabi::gen_book_of_descriptions($lang);
	    #GenSyllabi::gen_list_of_units_by_course();
	    GenSyllabi::gen_book_of_bibliography($lang);
	    GenSyllabi::generate_team_file($lang);
	}
	
	generate_general_info();
    #copy_basic_files();
#         Util::generate_batch_to_gen_figs(Common::get_template("out-batch-to-gen-figs-file"));
# 	
# 	Common::generate_html_index_by_country();
	   Util::print_time_elapsed();
	Util::print_message("process-curricula finished ok ...");
 	#print Dumper(\%{$Common::config{faculty}{"acuadros\@ucsp.edu.pe"}});
 	Common::shutdown();
}

main();

