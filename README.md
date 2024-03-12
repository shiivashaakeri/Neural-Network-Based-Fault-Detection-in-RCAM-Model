# Neural-Network-Based-Fault-Detection-in-RCAM-Model
## INTRODUCTION

This project introduces a fault detection framework using neural networks for the RCAM. The study begins by remodeling the RCAM's nonlinear dynamics to simulate various fault conditions. Subsequently, data generated from these faulty models underpin the training and testing of neural networks, which aim to classify and accurately identify system faults.

## Mathematical Background of RCAM
The Research Civil Aircraft Model (RCAM) stands as a benchmark for exploring and advancing control systems and fault detection methodologies in civil aviation. Central to the analysis and application of such technologies is a profound understanding of the RCAM's mathematical framework, which encapsulates the complex dynamics of aircraft flight.

### Nonlinear State Equation
In this equation, $\dot{\bar{x}} \in \mathcal{R}^9$ denotes the time derivative of the state vector $\bar{x} \in \mathcal{R}^9$, which encompasses the aircraft's pertinent dynamic states. The function $f$ represents mapping the current states $\bar{x}$ and control inputs $\bar{u}\in \mathcal{R}^5$ to the rate of change of states.

<img src="https://latex.codecogs.com/svg.latex?\Large&space;\dot{\bar{x}}=f(\bar{x},\bar{u})" title="\Large \dot{\bar{x}}=f(\bar{x},\bar{u})" />

where $\Bar{x}$ is the state vector, representing variables like the aircraft's velocity components ($u,v,w$), angular rates ($p,q,r$), and Euler angles ($\phi, \theta, \psi$), and $\Bar{u}$ is the input vector, including control inputs from the aileron, stabilizer, rudder, and throttle settings.

## Problem Setup and Fault Modeling
### Fault Definitions, Assumptions, and Mathematical Modeling

1. **Aileron Actuator Failure** [Yuan 2015](https://doi.org/10.1007/s00521-014-1743-4): This fault condition simulates scenarios where the aileron becomes stuck, has a limited range of motion, or becomes completely unresponsive.
   - *Assumption*: stuck, $d_A=15^{\circ}$

2. **Airspeed Sensor Failure**: Incorrect airspeed readings are simulated through this fault, ranging from complete sensor failure to partial blockage. The resultant airspeed is either set to zero or reduced by a constant value.
   - *Assumption*: complete, $V_a=0\: m/s$

3. **Angle of Attack Sensor Failure** [Ossmann 2016](https://doi.org/10.1016/j.proeng.2016.07.372): By fixing the angle of attack to a constant erroneous value, this fault impacts the lift and drag force calculations.
   - *Assumption*: $\alpha=5^{\circ}$

4. **Control Surface Damage** [IEEE 2018](https://doi.org/10.1109/ACCESS.2018.2873504): Reflects damage to ailerons, elevators, or rudders by reducing their effectiveness. The control input effectiveness is scaled down by the damage severity.
   - *Assumption*: aileron, $d'_A = 0.5 d_A$

5. **Electrical Power Failure** [IEEE 1993](https://doi.org/10.1109/59.260874): Simulates total or partial loss of electrical power, impacting all electrically actuated control surfaces and systems. In a total failure, all control inputs are neutralized, while partial failure scales down control inputs.
   - *Assumption*: partial, $\bar{u} = 0.5\bar{u}$

6. **Elevator Actuator Failure** [Wang 2015](https://doi.org/10.3390/s150819833): Affects pitch control by either sticking the elevator at a certain angle, limiting its range, or rendering it unresponsive.
   - *Assumption*: limited range, $d_T=\min(\max(d_T,-10),10)$

7. **Engine Failure** [IEEE 2009](https://doi.org/10.1109/AERO.2009.4839637): Simulates complete or partial thrust loss in one or both engines, crucial for maintaining flight level and speed. It directly modifies throttle inputs.
   - *Assumption*: partial, engine 1, $\delta_{th_1}'= 0.5\delta_{th_1}$

8. **Fuel System Malfunction** [Wang 2015](https://doi.org/10.3390/s150819833): Alters engine performance by simulating issues in fuel delivery, affecting the throttle inputs and thereby the generated thrust.
   - *Assumption*: both engines, $\delta_{th}'= 0.8\delta_{th}$

9. **Fuselage Integrity Compromise** [IEEE 2016](https://doi.org/10.1109/AERO.2016.7500674): Increases the drag coefficient to simulate structural damage.
   - *Assumption*: $CD' = 1.3 CD$

10. **Gyroscope Sensor Failure** [Napolitano 2000](https://doi.org/10.2514/2.5511): Sets angular rate readings to zero, affecting the aircraft's attitude control and stabilization systems.
    - *Assumption*: $p=q=r=0$.

11. **Landing Gear Malfunction** [Kruger 1997](https://doi.org/10.2514/2.5171): Increases drag when the landing gear is incorrectly reported as deployed.
    - *Assumption*: deployed, $CD' =CD+0.05$

12. **Propulsion Sensor Failure**: Impacts engine performance perception by adjusting throttle settings based on incorrect sensor readings.
    - *Assumption*: fuel pressure, both throttles, $\delta_{th}'= 0.9\delta_{th}$

13. **Rudder Actuator Failure**: Similar to the aileron and elevator actuator failures, it modifies the rudder control input $(d_R)$, affecting the yaw control.
    - *Assumption*: stuck, $d_R=-5^{\circ}$

14. **Sideslip Angle Sensor Failure**: Incorrectly reports the sideslip angle as zero.
    - *Assumption*: $\beta ' = 0^{\circ}$

15. **Tailplane Damage**: Reduces the effectiveness of the elevator.
    - *Assumption*: $d'_T= 0.5d_T$

16. **Temperature Sensor Failures**: Incorrectly reports ambient temperature, leading to inaccurate air density calculations.
    - *Assumption*: $\rho '=0.5$ atm

17. **Throttle Actuator Failure**: Affects engine throttle control for one or both engines by simulating stuck conditions, limited operational ranges, or complete unresponsiveness.
    - *Assumption*: stuck, engine 1, $\delta_{th_1}'= 0.5$

18. **Wing Damage**: Modifies lift and drag coefficients to simulate structural damage to the wings.
    - *Assumption*: $CD' = 0.8 CD$, $CL' = 1.2 CL$

## Data Generation, Preprocessing, and Neural Network Training
### Data Generation Process
Initial conditions and control inputs for the simulation were obtained from trim points associated with steady-state level flight. By applying them into all of the functions, we generated the data we need.
### Preprocessing Techniques
Key preprocessing tasks included normalization of the feature set to a common scale and stratification of the dataset into training and testing partitions. 


### Neural Network Training
The neural network was trained over several epochs, with the data split into training, validation, and testing sets. The division of data was as follows: $70 \%$ for training, $15\%$ for validation, and $15\%$ for testing. The performance function used was cross-entropy, which is suitable for multi-class classification problems.

