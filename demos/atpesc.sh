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
# read -n 1 -s -r
# echo -e \
# "${GREEN}# 4th order method with dt = 5${COLOR_RESET}"
# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1"

# echo -e \
# "${GREEN}# Compute the final error${COLOR_RESET}"
# pe "./amrex_fcompare plt00001/ reference_solution/"

# # Unstable step size
# echo -e \
# "${GREEN}# 4th order method with dt = 25${COLOR_RESET}"
# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=25.0"

# echo -e \
# "${GREEN}# Compute the final error${COLOR_RESET}"
# pe "./amrex_fcompare plt00001/ reference_solution/"

# # Summarize results
# echo -e \
# "${CYAN}
# Fixed Step Results

# | dt |  error | runtime |
# +----+--------+---------+
# |  5 | 8.5e-9 |    1.68 |
# | 25 | 1      |    0.37 |

# What do you think happened?
# ${COLOR_RESET}"

# # Run some more step sizes
# read -n 1 -s -r
# echo -e \
# "${RED}
# Run the code a few more times with difference step sizes and try to identify the
# largest stable time step size.
# ${COLOR_RESET}"

# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=21.0"
# pe "./amrex_fcompare plt00001/ reference_solution/"

# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=22.0"
# pe "./amrex_fcompare plt00001/ reference_solution/"

# # Summarize results
# echo -e \
# "${CYAN}
# Fixed Step Results

# | dt |  error | runtime |
# +----+--------+---------+
# | 21 | 1.8e-6 |    0.43 |
# | 22 | 0.99   |    0.41 |

# The max step size is about 21
# ${COLOR_RESET}"

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

# read -n 1 -s -r
# echo -e \
# "${GREEN}# 4th order method with adaptive dt (rtol = 1e-4, atol = 1e-9)${COLOR_RESET}"
# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0"

# echo -e \
# "${GREEN}# Save the log file for later${COLOR_RESET}"
# pe "mv HandsOn1.log HandsOn1_1e-4.log"

# echo -e \
# "${GREEN}# Compute the final error${COLOR_RESET}"
# pe "./amrex_fcompare plt00001/ reference_solution/"

# # Summarize results
# echo -e \
# "${CYAN}
# Adaptive Step Results

# | rtol |  error | runtime |     steps |
# +------+--------+---------+-----------+
# | 1e-4 | 3.4e-4 |    0.48 | 459 (461) |

# ${COLOR_RESET}"

# echo -e \
# "${GREEN}# Plot the step size history${COLOR_RESET}"
# pe "./plot_log.py HandsOn1_1e-4.log --logy"

# # Run some more step sizes
# read -n 1 -s -r
# echo -e \
# "${RED}
# Run the code a few more times with different rtol values:
# * How well does the adaptivity algorithm produce solutions within the desired tolerances?
# * How do the number of time steps change as different tolerances are requested?
# ${COLOR_RESET}"

# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 rtol=1e-2"
# pe "./amrex_fcompare plt00001/ reference_solution/"
# pe "mv HandsOn1.log HandsOn1_1e-2.log"

# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 rtol=1e-6"
# pe "./amrex_fcompare plt00001/ reference_solution/"
# pe "mv HandsOn1.log HandsOn1_1e-6.log"

# pe "./plot_log.py HandsOn1_1e-2.log HandsOn1_1e-4.log HandsOn1_1e-6.log --logy --labels 1e-2 1e-4 1e-6 --save ex_adaptive.pdf"

# # Summarize results
# echo -e \
# "${CYAN}
# Adaptive Step Results

# | rtol |  error | runtime |     steps |
# +------+--------+---------+-----------+
# | 1e-2 | 2.2e-2 |    0.48 | 456 (459) |
# | 1e-4 | 3.4e-4 |    0.48 | 459 (461) |
# | 1e-6 | 2.5e-6 |    0.49 | 465 (466) |

# ${COLOR_RESET}"

########################
# Lesson 1.3
########################

read -n 1 -s -r
echo -e \
     "${GREEN}\
# -------------------------------- #
# Lesson 1.3: Order and Efficiency #
# -------------------------------- #
${COLOR_RESET}"

# read -n 1 -s -r
# echo -e \
# "${GREEN}# 8th order method with adaptive dt${COLOR_RESET}"
# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 arkode_order=8"

# echo -e \
# "${GREEN}# Compute the final error${COLOR_RESET}"
# pe "./amrex_fcompare plt00001/ reference_solution/"

# read -n 1 -s -r
# echo -e \
# "${RED}
# Run the code a few more times with various values of arkode_order for a fixed
# value of rtol - what is the most \"efficient\" overall method for this problem
# at this tolerance?
# ${COLOR_RESET}"

# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 arkode_order=2"
# pe "./amrex_fcompare plt00001/ reference_solution/"

# pe "mpiexec -n 4 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 arkode_order=5"
# pe "./amrex_fcompare plt00001/ reference_solution/"

# Summarize results
echo -e \
"${CYAN}
Adaptive Step Results

| order |  error | runtime |     steps | rhs evals |
+-------+--------+---------+-----------+-----------+
|     2 | 4.0e-3 |    0.50 | 673 (836) |      1675 |
|     3 | 1.8e-3 |    0.42 | 508 (510) |      1533 |
|     4 | 3.4e-4 |    0.49 | 459 (461) |      1847 | <
|     5 | 2.2e-3 |    0.64 | 365 (447) |      2686 |
|     6 | 8.6e-6 |    0.63 | 247 (328) |      2631 |
|     7 | 1.5e-4 |    0.75 | 278 (316) |      3129 |
|     8 | 2.9e-3 |    0.74 | 221 (226) |      2940 |
|     9 | 6.8e-5 |    1.38 | 289 (338) |      5366 |

${COLOR_RESET}"

########################
# Lesson 2
########################

read -n 1 -s -r
echo -e \
     "${GREEN}\
# -------------------------------------------- #
# Lesson 2: Implicit and IMEX Time Integration #
# -------------------------------------------- #
${COLOR_RESET}"

########################
# Lesson 2.1
########################

read -n 1 -s -r
echo -e \
     "${GREEN}\
# ---------------------------- #
# Lesson 2.1: Fixed Step Sizes #
# ---------------------------- #
${COLOR_RESET}"

read -n 1 -s -r
echo -e \
"${GREEN}# 4th order method with dt = 5${COLOR_RESET}"
pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2"

echo -e \
"${GREEN}# Compute the final error${COLOR_RESET}"
pe "./amrex_fcompare plt00001/ reference_solution/"

echo -e \
"${GREEN}# 4th order method with dt = 100${COLOR_RESET}"
pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=100.0"

echo -e \
"${GREEN}# Compute the final error${COLOR_RESET}"
pe "./amrex_fcompare plt00001/ reference_solution/"

# Summarize results
echo -e \
"${CYAN}
Fixed Step Results

| type |  dt |  error | runtime |
+------+-----+--------+---------+
|   ex |   5 | 8.5e-9 |    1.68 |
|   ex |  25 | 1      |    0.37 |
|   im |   5 | 4.8e-6 |   23.37 |
|   im | 100 | 9.5e-5 |    5.19 |

What do you think happened?
${COLOR_RESET}"

# Run some more step sizes
read -n 1 -s -r
echo -e \
"${RED}
Run the code a few more times with larger time step sizes, checking the
overall solution error each time.
* Can you find an unstable step size?
* Are there step sizes where the code may be stable, but are so large that the
  nonlinear and/or linear solver fails to converge?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=300.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=1000.0"

########################
# Lesson 2.2
########################

read -n 1 -s -r
echo -e \
     "${GREEN}\
# ------------------------------- #
# Lesson 2.2: Temporal Adaptivity #
# ------------------------------- #
${COLOR_RESET}"

read -n 1 -s -r
echo -e \
"${GREEN}# 4th order method with adaptive dt (rtol = 1e-4, atol = 1e-9)${COLOR_RESET}"
pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=0"

echo -e \
"${GREEN}# Save the log file for later${COLOR_RESET}"
pe "mv HandsOn2.log HandsOn2_1e-4.log"

echo -e \
"${GREEN}# Compute the final error${COLOR_RESET}"
pe "./amrex_fcompare plt00001/ reference_solution/"

echo -e \
"${CYAN}
How does the average step size for this tolerance compare against the average
step size of HandsOn1.CUDA.exe for the same tolerances?
${COLOR_RESET}"

echo -e \
"${GREEN}# Plot the step size history${COLOR_RESET}"
pe "./plot_log.py HandsOn1_1e-4.log HandsOn2_1e-4.log --logy --labels explicit implicit --save im_adaptive.pdf"

echo -e \
"${CYAN}
Why do the time steps gradually increase throughout the simulation?
${COLOR_RESET}"

# Run some more step sizes
read -n 1 -s -r
echo -e \
"${RED}
Run the code a few more times with various values of rtol - how well does the
adaptivity algorithm produce solutions within the desired tolerances?

How do the number of time steps change as different tolerances are requested?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=0 rtol=1e-2"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=0 rtol=1e-6"
pe "./amrex_fcompare plt00001/ reference_solution/"

# Summarize results
echo -e \
"${CYAN}
Adaptive Step Results

| type | rtol |  error | runtime |     steps | rhs evals |
+------+------+--------+---------+-----------+-----------+
|   ex | 1e-2 | 2.2e-2 |    0.48 | 456 (459) |     1,839 |
|   ex | 1e-4 | 3.4e-4 |    0.48 | 459 (461) |     1,847 |
|   ex | 1e-6 | 2.5e-6 |    0.49 | 465 (466) |     1,867 |
|   im | 1e-2 | 4.2e-1 |   10.43 |  15  (18) |     6,486 |
|   im | 1e-4 | 3.0e-2 |    6.86 |  32  (32) |     6,577 |
|   im | 1e-6 | 2.3e-4 |    4.50 | 104 (104) |     8,266 |

${COLOR_RESET}"

########################
# Lesson 2.3
########################

read -n 1 -s -r
echo -e \
     "${GREEN}\
# ----------------------------- #
# Lesson 2.3: IMEX Partitioning #
# ----------------------------- #
${COLOR_RESET}"

read -n 1 -s -r
echo -e \
"${GREEN}# 4th order method with dt = 5${COLOR_RESET}"
pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1"

echo -e \
"${GREEN}# Compute the final error${COLOR_RESET}"
pe "./amrex_fcompare plt00001/ reference_solution/"

# Summarize results
echo -e \
"${CYAN}
Fixed Step Results

| type |  dt |  error | runtime |                 rhs evals |
+------+-----+--------+---------+---------------------------+
|   ex |   5 | 8.5e-9 |    1.68 |                     8,001 |
|   ex |  25 | 1      |    0.37 |                     1,601 |
|   im |   5 | 4.8e-6 |   23.37 |                    60,716 |
|   im | 100 | 9.5e-5 |    5.19 |                     9,079 |
| imex |   5 | 2.6e-8 |   23.73 | 14,001 (ex) + 62,001 (im) |

${COLOR_RESET}"

echo -e \
"${CYAN}
Do you notice any efficiency or accuracy differences between fully implicit
and IMEX formulations with these fixed time-step tests?
${COLOR_RESET}"

echo -e \
"${CYAN}
Why does ARKODE report such significant differences in the number of explicit
vs implicit RHS function evaluations?
${COLOR_RESET}"

echo -e \
"${RED}
Run the IMEX version a few times with various fixed time step sizes (the
fixed_dt argument), checking the overall solution error each time - can you
find a maximum stable step size?
${COLOR_RESET}"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=40.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=45.0"
pe "./amrex_fcompare plt00001/ reference_solution/"

# Summarize results
echo -e \
"${CYAN}
Fixed Step Results

| type |  dt |  error | runtime |                 rhs evals |
+------+-----+--------+---------+---------------------------+
|   ex |   5 | 8.5e-9 |    1.68 |                     8,001 |
|   ex |  25 | 1      |    0.37 |                     1,601 |
|   im |   5 | 4.8e-6 |   23.37 |                    60,716 |
|   im | 100 | 9.5e-5 |    5.19 |                     9,079 |
| imex |   5 | 2.6e-8 |   23.73 | 14,001 (ex) + 62,001 (im) |
| imex |  40 | 6.2e-6 |    3.78 |  7,751 (ex) +  9,562 (im) |                           |

${COLOR_RESET}"

echo -e \
"${GREEN}# 4th order method with adaptive dt (rtol = 1e-4, atol = 1e-9)${COLOR_RESET}"
pe "mpiexec -n 4 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=0"

echo -e \
"${GREEN}# Save the log file for later${COLOR_RESET}"
pe "mv HandsOn2.log HandsOn2_1e-4_imex.log"

echo -e \
"${GREEN}# Compute the final error${COLOR_RESET}"
pe "./amrex_fcompare plt00001/ reference_solution/"

echo -e \
"${GREEN}# Plot the step size history${COLOR_RESET}"
pe "./plot_log.py HandsOn1_1e-4.log HandsOn2_1e-4.log HandsOn2_1e-4_imex.log --logy --labels explicit impicit imex --save imex_adaptive.pdf"

########################
# Wrap up
########################

echo -e \
     "${GREEN}\
# ------- #
# Wrap up #
# ------- #
${COLOR_RESET}"

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""
