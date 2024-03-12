# Neural-Network-Based-Fault-Detection-in-RCAM-Model
## INTRODUCTION

This project introduces a fault detection framework using neural networks for the RCAM. The study begins by remodeling the RCAM's nonlinear dynamics to simulate various fault conditions. Subsequently, data generated from these faulty models underpin the training and testing of neural networks, which aim to classify and accurately identify system faults.

## Mathematical Background of RCAM
The Research Civil Aircraft Model (RCAM) stands as a benchmark for exploring and advancing control systems and fault detection methodologies in civil aviation. Central to the analysis and application of such technologies is a profound understanding of the RCAM's mathematical framework, which encapsulates the complex dynamics of aircraft flight.

### Nonlinear State Equation
In this equation, $\dot{\bar{x}} \in \mathcal{R}^9$ denotes the time derivative of the state vector $\bar{x} \in \mathcal{R}^9$, which encompasses the aircraft's pertinent dynamic states. The function $f$ represents mapping the current states $\bar{x}$ and control inputs $\bar{u}\in \mathcal{R}^5$ to the rate of change of states.
