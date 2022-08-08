#!/usr/bin/env bash

# include the magic
source ../demo-magic.sh -d

# hide the evidence
clear

########################
# Configure the options
########################

SHOW_CMD_NUMS=true

########################
# Demo
########################

LESSON="ATPESC 2022"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

# where are we
pe "ls"
pe "cd track-5-numerical/time_integration_sundials/thetaGPU"
pe "module load conda/2022-07-01"
pe "conda activate"

pe "mpirun -n 1 HandsOn1.CUDA.exe help=1"

LESSON="Lesson 1: Linear Stability"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

pe "mpirun -n 1 ./HandsOn1.CUDA.exe inputs-1"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"
pe "mpirun -n 1 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=100.0"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"

LESSON="Lesson 1: Temporal Adaptivity"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

pe "mpirun -n 1 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"
pe "./process_ARKStep_diags.py HandsOn1_diagnostics.txt"
pe "mpirun -n 1 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 rtol=1e-6"

LESSON="Lesson 1: Integrator Order and Efficiency"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

pe "mpirun -n 1 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 arkode_order=8"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"
pe "mpirun -n 1 ./HandsOn1.CUDA.exe inputs-1 fixed_dt=0 arkode_order=2"

LESSON="Lesson 2: Linear Stability Revisited"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

pe "mpirun -n 1 ./HandsOn2.CUDA.exe inputs-2"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"

pe "mpirun -n 1 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=100.0"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"

LESSON="Lesson 2: Temporal Adaptivity Revisited"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

pe "mpirun -n 1 ./HandsOn2.CUDA.exe inputs-2 fixed_dt=0"
pe "./fcompare plt00001/ reference_solution/"

LESSON="Lesson 2: IMEX Partitioning"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

pe "mpirun -n 1 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"

pe "mpirun -n 1 ./HandsOn2.CUDA.exe inputs-2"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"

pe "mpirun -n 1 ./HandsOn2.CUDA.exe inputs-2 rhs_adv=1 fixed_dt=0"
pe "mpirun -n 1 ./fcompare plt00001/ reference_solution/"

LESSON="Out-brief"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

LESSON="Lesson 3: Preconditioning"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

pe "mpirun -n 1 ./HandsOn3.CUDA.exe inputs-3"
pe "mpirun -n 1 ./HandsOn3.CUDA.exe inputs-3 use_preconditioner=0"

LESSON="ATPESC 2022"
DEMO_PROMPT="${CYAN}${LESSON} ${GREEN}$ "

pe "conda deactivate"
pe "module unload conda/2022-07-01"

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""
