#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Programmer(s): David J. Gardner @ LLNL
# ------------------------------------------------------------------------------
# Driver script for SUNDIALS+AMReX hands-on presentation at ATPESC 2024
# Lesson repo: https://github.com/xsdk-project/MathPackagesTraining2024
# ------------------------------------------------------------------------------

# include the magic
source ./demo-magic.sh -d

# sync with installed examples
#rsync -a /eagle/ATPESC2024/EXAMPLES/track-5-numerical/time_integration_sundials .
cd time_integration_sundials

# hide the evidence
clear

########################
# Configure the options
########################

SHOW_CMD_NUMS=true

########################
# Demo
########################

LESSON="ATPESC 2024"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

# where are we
pe "ls"

########################
# Intro
########################

p "msg"
echo -e \
"${GREEN}
# For this hands-on we consider a model for transport of a pollutant that has
# been released into a flow in a two dimensional domain. This is an example of a
# scalar-valued advection-diffusion problem for chemical transport.
#
# The example application uses a finite volume spatial discretization with
# AMReX. For the time integration, we use the ARKODE package from SUNDIALS to
# explore explicit, implicit, and IMEX integrators.
${COLOR_RESET}"

########################
# Lesson 1
########################

LESSON="Lesson 1: Linear Stability"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Explicit integration with fixed step sizes.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=25.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

p "question"
echo -e \
"${GREEN}
# What do you think happened?
${COLOR_RESET}"

p "msg"
echo -e \
"${GREEN}
# Run the code a few more times, trying to identify the largest stable time step
# size.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=21.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=22.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

LESSON="Lesson 1: Temporal Adaptivity"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Explicit integration with adaptive step sizes.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0"
pe "./amrex_fcompare plt00001/ reference_solution/"
pe "./process_ARKStep_diags.py HandsOn1_diagnostics.txt"

p "msg"
echo -e \
"${GREEN}
# Run the code a few more times with different rtol values:
# * How well does the adaptivity algorithm produce solutions within the desired tolerances?
# * How do the number of time steps change as different tolerances are requested?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 rtol=1e-2"
pe "./amrex_fcompare plt00001/ reference_solution/"
pe "./process_ARKStep_diags.py HandsOn1_diagnostics.txt"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 rtol=1e-6"
pe "./amrex_fcompare plt00001/ reference_solution/"
pe "./process_ARKStep_diags.py HandsOn1_diagnostics.txt"

LESSON="Lesson 1: Integrator Order and Efficiency"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Explicit integration with adaptive step sizes and different methods orders.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 arkode_order=8"
pe "./amrex_fcompare plt00001/ reference_solution/"

p "msg"
echo -e \
"${GREEN}
Run the code a few more times with various values of arkode_order for a fixed
value of rtol - what is the most \"efficient\" overall method for this problem
at this tolerance?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 arkode_order=2"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 arkode_order=5"
pe "./amrex_fcompare plt00001/ reference_solution/"

########################
# Lesson 2
########################

LESSON="Lesson 2: Linear Stability Revisited"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Implicit integration with fixed step sizes.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=100.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

p "question"
echo -e \
"${GREEN}
# What do you think happened?
${COLOR_RESET}"

p "msg"
echo -e \
"${GREEN}
# Run the code a few more times with larger time step sizes, checking the
# overall solution error each time.
# * Can you find an unstable step size?
# * Are there step sizes where the code may be stable, but are so large that the
#   nonlinear and/or linear solver fails to converge?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=300.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=1000.0"

LESSON="Lesson 2: Temporal Adaptivity Revisited"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Implicit integration with adaptive step sizes.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=0"
pe "./amrex_fcompare plt00001/ reference_solution/"

p "msg"
echo -e \
"${GREEN}
# How does the average step size for this tolerance compare against the average
# step size of HandsOn1.CUDA.exe (mean = 21.7) for the same tolerances?
${COLOR_RESET}"

pe "./process_ARKStep_diags.py HandsOn2_diagnostics.txt"

p "question"
echo -e \
"${GREEN}
# Why do the time steps gradually increase throughout the simulation?
${COLOR_RESET}"

p "msg"
echo -e \
"${GREEN}
# Run the code a few more times with various values of rtol - how well does the
# adaptivity algorithm produce solutions within the desired tolerances?
#
# How do the number of time steps change as different tolerances are requested?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=0 rtol=1e-2"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=0 rtol=1e-6"
pe "./amrex_fcompare plt00001/ reference_solution/"

LESSON="Lesson 2: IMEX Partitioning"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Implicit-Explicit (IMEX) integration with fixed step sizes.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1"
pe "./amrex_fcompare plt00001/ reference_solution/"

p "msg"
echo -e \
"${GREEN}
# Do you notice any efficiency or accuracy differences between fully implicit
# and IMEX formulations with these fixed time-step tests?
${COLOR_RESET}"

# pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2"
# pe "./amrex_fcompare plt00001/ reference_solution/"

p "question"
echo -e \
"${GREEN}
# Why does ARKODE report such significant differences in the number of explicit
# vs implicit RHS function evaluations?
${COLOR_RESET}"

p "msg"
echo -e \
"${GREEN}
# Run the IMEX version a few times with various fixed time step sizes (the
# fixed_dt argument), checking the overall solution error each time - can you
# find a maximum stable step size?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=53.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=55.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

p "msg"
echo -e \
"${GREEN}
# Implicit-Explicit (IMEX) integration with adaptive step sizes.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=0"
pe "./amrex_fcompare plt00001/ reference_solution/"
pe "./process_ARKStep_diags.py HandsOn2_diagnostics.txt"

########################
# Wrap up
########################

LESSON="Out-brief"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Out-brief
${COLOR_RESET}"

LESSON="ATPESC 2024"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Unsetup instructions.
${COLOR_RESET}"

pe "conda deactivate"
pe "module unload conda"

########################
# Lesson 3
########################

LESSON="Lesson 3: Preconditioning"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

p "msg"
echo -e \
"${GREEN}
# Implicit integration with adaptive step sizes and preconditioning.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn3.CUDA.exe inputs-3"
pe "mpiexec -n 4 ./HandsOn3.CUDA.exe inputs-3 use_preconditioner=0"

p "msg"
echo -e \
"${GREEN}
# Note the preconditioned version is requires approximately half as many linear iterations
${COLOR_RESET}"

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""
