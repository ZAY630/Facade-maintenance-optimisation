# Facade-maintenance-optimisation

The file is coded in MATLAB and The code is produced based on an open source NGSA-II algorithm developed by Mostapha Kalami Heris, 2015. 
Based on the theory of gene mutation and crossover, crowding distance and non-dominant sorting, the algorithm is modified to suit the purpose of facade manitenance optimisation.

nsga2.m: This is the main file for the multi-objective optimisation operation. 

CalcCrowdingDistance.m, Crossover.m, Dominates.m, Mutate.m, NonDominatedSorting.m, SortPopulation.m: Those files are the main process of the genetic algorithm.

WoodCladding.m, ConcreteCladding.m, CementitiousCladding.m, NaturalStoneCladding.m: Those files contain degradation functions.

MOP5.m - MOP8.m: Those files are the multi-objective optimisation of maintenance schedule on wood, concrete, cemnetitious, stone claddings.
ReverseMOP5.m - ReverseMOP8.m: Those files are similar to MOP5.m - MOP8.m files for plotting purpose.

Analysis.m: The files contain maintenance schedules for the three scenarios.

Relisis_2.m: Reliability assessment calculation
Relisis5.m = Relisis8.m: Those files are coded to incoporate maintenance schedule to calculate reliability indices for wood, concrete, cemnetitious, stone claddings.

PlotCostResilience.m, PlotServicelifeCosts.m, PlotServicelifeResilience.m, REpaintNUmberResilience.m, Plot3D: Those files are for plotting purpose of the whole population.

Annotations are included in the code. Wooden cladding is annotated as an example for other materials since codes in the other files are the same.

                                                                                                                                                                        
                                                                                                                                                                        
                                                                                                                                                                        Aoyu Zou
                                                                                                                                                                       June 2021
