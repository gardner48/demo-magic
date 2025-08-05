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

DEMO_PROMPT="${GREEN}> "

# where are we
pe "ls"

########################
# Intro
########################

read -n 1 -s -r
echo -e \
     "${CYAN}
For this hands-on we consider a model for transport of a pollutant that has
been released into a flow in a two dimensional domain. This is an example of a
scalar-valued advection-diffusion problem for chemical transport.

The example application uses a finite volume spatial discretization with
AMReX. For the time integration, we use the ARKODE package from SUNDIALS to
explore explicit, implicit, and IMEX integrators.
${COLOR_RESET}"

########################
# Lesson 1
########################

read -n 1 -s -r
echo -e \
     "${GREEN}\
# ----------------------------------- #
# Lesson 1: Explicit Time Integration #
# ----------------------------------- #
${COLOR_RESET}"

########################
# Lesson 1.1
########################

read -n 1 -s -r
echo -e \
     "${GREEN}\
# ---------------------------- #
# Lesson 1.1: Fixed Step Sizes #
# ---------------------------- #
${COLOR_RESET}"

# Stable step size
read -n 1 -s -r
echo -e \
"${GREEN}# 4th order method with dt = 5${COLOR_RESET}"
pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1"

read -n 1 -s -r
echo -e \
"${GREEN}# Compute the final error${COLOR_RESET}"
pe "./amrex_fcompare plt00001/ reference_solution/"

# Unstable step size
read -n 1 -s -r
echo -e \
"${GREEN}# 4th order method with dt = 25${COLOR_RESET}"
pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=25.0"

read -n 1 -s -r
echo -e \
"${GREEN}# Compute the final error${COLOR_RESET}"
pe "./amrex_fcompare plt00001/ reference_solution/"

# Summarize results
read -n 1 -s -r
echo -e \
"${CYAN}
Fixed Step Results

| dt |  error | runtime |
+----+--------+---------+
|  5 | 8.5e-9 |    1.68 |
| 25 | 1      |    0.37 |

What do you think happened?
${COLOR_RESET}"

# Run some more step sizes
read -n 1 -s -r
echo -e \
"${RED}
Run the code a few more times with difference step sizes and try to identify the
largest stable time step size.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=21.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=22.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

# Summarize results
read -n 1 -s -r
echo -e \
"${CYAN}
Fixed Step Results

| dt |  error | runtime |
+----+--------+---------+
| 21 | 1.8e-6 |    0.43 |
| 22 | 0.99   |    0.41 |

The max step size is about 21
${COLOR_RESET}"

########################
# Lesson 1.2
########################

read -n 1 -s -r
echo -e \
     "${GREEN}\
# ------------------------------- #
# Lesson 1.2: Temporal Adaptivity #
# ------------------------------- #
${COLOR_RESET}"

read -n 1 -s -r
echo -e \
"${GREEN}# 4th order method with adaptive dt (rtol = 1e-4, atol = 1e-9)${COLOR_RESET}"
pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0"
mv HandsOn1.log HandsOn1_1.2b.log

read -n 1 -s -r
echo -e \
"${GREEN}# Compute the final error${COLOR_RESET}"
pe "./amrex_fcompare plt00001/ reference_solution/"

# Summarize results
read -n 1 -s -r
echo -e \
"${CYAN}
Adaptive Step Results

| rtol |  error | runtime |
+------+--------+---------+
| 1e-4 | 3.4e-4 |    0.48 |

${COLOR_RESET}"

read -n 1 -s -r
echo -e \
"${GREEN}# Plot the step size history${COLOR_RESET}"
pe "./plot_log.py HandsOn1.log --logy"

# Run some more step sizes
read -n 1 -s -r
echo -e \
"${RED}
Run the code a few more times with different rtol values:
* How well does the adaptivity algorithm produce solutions within the desired tolerances?
* How do the number of time steps change as different tolerances are requested?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 rtol=1e-2"
pe "./amrex_fcompare plt00001/ reference_solution/"
mv HandsOn1.log HandsOn1_1.2a.log

pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 rtol=1e-6"
pe "./amrex_fcompare plt00001/ reference_solution/"
mv HandsOn1.log HandsOn1_1.2c.log

./plot_log.py HandsOn1_1.2a.log HandsOn1_1.2c.log HandsOn1_1.2c.log --logy --labels 1e-2 1e-4 1e-6

# Summarize results
read -n 1 -s -r
echo -e \
"${CYAN}
Adaptive Step Results

| rtol |  error | runtime |     steps |
+------+--------+---------+-----------+
| 1e-2 | 2.2e-2 |    0.48 | 459 (461) |
| 1e-4 | 3.4e-4 |    0.48 | 456 (459) |
| 1e-6 | 2.5e-6 |    0.49 | 465 (466) |

${COLOR_RESET}"

#>>>>> ADD PLOT COMPARING DIFFERENT RESULTS

read -n 1 -s -r
echo -e \
     "${GREEN}\
# -------------------------------- #
# Lesson 1.3: Order and Efficiency #
# -------------------------------- #
${COLOR_RESET}"

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
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}> "

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
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}> "

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

pe "./plot_log.py HandsOn2.log --logy"

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
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}> "

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

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=40.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=45.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

p "msg"
echo -e \
"${GREEN}
# Implicit-Explicit (IMEX) integration with adaptive step sizes.
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=0"
pe "./amrex_fcompare plt00001/ reference_solution/"
pe "./plot_log.py HandsOn2.log --logy"

########################
# Wrap up
########################

LESSON="Out-brief"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}> "

p "msg"
echo -e \
"${GREEN}
# Out-brief
${COLOR_RESET}"

# LESSON="ATPESC 2025"
# DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}> "

# p "msg"
# echo -e \
# "${GREEN}
# # Unsetup instructions.
# ${COLOR_RESET}"

# p "conda deactivate"
# p "module unload conda"

# ########################
# # Lesson 3
# ########################

# LESSON="Lesson 3: Preconditioning"
# DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}> "

# p "msg"
# echo -e \
# "${GREEN}
# # Implicit integration with adaptive step sizes and preconditioning.
# ${COLOR_RESET}"

# pe "mpiexec -n 4 ./HandsOn3.CUDA.exe inputs-3"
# pe "mpiexec -n 4 ./HandsOn3.CUDA.exe inputs-3 use_preconditioner=0"

# p "msg"
# echo -e \
# "${GREEN}
# # Note the preconditioned version is requires approximately half as many linear iterations
# ${COLOR_RESET}"

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""
