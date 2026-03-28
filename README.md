# Simulation of Infectious Disease Spread

> Course project: Agent-Based Modelling (Spring 2023) · University of Zurich · Dr. Damian R. Farine

Agent-based model in R simulating infectious disease spread in a university classroom, comparing **Traditional** vs. **HyFlex** (hybrid-flexible) settings.

<br>

👇 Click on the plots to view the animations!

<table>
  <tr> 
    <td><a href="https://github.com/user-attachments/assets/b336adc0-ddf9-4606-8dee-ca240413ea5d"><img src="https://github.com/user-attachments/assets/0d55f27e-ec1c-47a1-8126-bc64902a7489" width="400"/></a></td>
    <td><b>Traditional:</b><br><br>All students attend in person. Sick students may still attend with probability p = 0.2.</td>
  </tr>
  <tr>
    <td><a href="https://github.com/user-attachments/assets/78ca6156-08b7-4e67-86ef-010c4b0fe936"><img src="https://github.com/user-attachments/assets/efb277a5-2766-4909-a942-12d32f28e01d" width="400"/></a></td>
    <td><b>HyFlex (hybrid-flexible):</b><br><br>⅓ always on-site · ⅓ always online · ⅓ hybrid (50:50 each week). Sick students always stay home.</td>
  </tr>
</table>

<br>

## Method

Each student is an agent that can be healthy, infectious, or sick. Every week, students are assigned to campus or remote based on preference and health status, seated randomly in an n×n grid, and exposed to infectious neighbours within 2m. Infection probability follows $p = 1-(1-\beta)^{n_{\text{exposures}}}$. The simulation runs for 100 iterations × 2 settings × 14 classroom sizes × 14 weeks.

<br>

## Results

<img width="551" height="487" alt="image" src="https://github.com/user-attachments/assets/dbae9943-f5e0-44c6-858b-6c3393838212" />

- **26× fewer infections** with HyFlex at 18 rows (0.051 vs. 1.33 per student)
- HyFlex requires **1.65× less space** (14 vs. 18 rows minimum viable classroom)
- Traditional setting: average student misses **0.88 classes** per semester at 18 rows

<br>

## Conclusion

HyFlex drastically reduces infections per student and allows for smaller classrooms, potentially cutting university costs for energy, heating, and maintenance. In the traditional setting, students miss classes due to sickness even with moderate attendance-while-sick rates.

<br>

<details>
<summary><b>Assumptions</b></summary>
<br>

**General**
- 300 students, square classrooms, 14-week semester
- Transmission threshold: 2.2m (Khosronejad et al., 2021)
- Average neighbours within threshold: ~11 → β = R₀ / 11 = 3 / 11 ≈ 0.27 → rounded down to 0.2
- Immunity duration: 3 weeks post-recovery (Eggo et al., 2016)

**Traditional setting**
- All 300 students attend in person
- 3 patients zero (initial infection probability 0.01)
- If sick: probability of 20% that student still attends in person

**HyFlex setting**
- ⅓ always on-site · ⅓ always online · ⅓ hybrid (50:50 each week)
- 2 patients zero
- Sick students always stay home
- No missed classes (lectures available as recordings)


</details>

<details>
<summary><b>Scripts & functions</b></summary>
<br>

**Main scripts**
- `01_Simulation_multiweek.R` — full nested simulation loop
- `assumptions_and_variables.R` — parameters and setting-specific dictionaries
- `classroom_plots_multiweek.R` — runs one simulation and generates classroom plots
- `Barplot_avg_n_infections_per_student.R` — average infections per student across classroom sizes
- `Barplot_avg_classes_missed_per_student.R` — average missed classes (traditional setting only)

**Helper functions**
- `fct_initialise_df.R` — creates empty student dataframe
- `fct_seats.R` — generates seat grid with row, column, and seat ID
- `fct_week_of_infections.R` — weekly cycle: attendance, seating, exposure, infection, status update
- `fct_neighbors_within_threshold.R` — computes average neighbours within transmission distance
- `fct_stats.R` — aggregates mean ± SE per setting and classroom size
- `fct_classroom_plot.R` — generates colour-coded tile plot of classroom per week
- `fct_GIF.R` — combines weekly plots into animated GIF at 2fps

</details>

<details>
<summary><b>Limitations</b></summary>
<br>

The simulation does not account for:
- Class duration effects
- Behavioural factors (masks, coughing, ventilation)
- Aerosol dynamics
- Virus-specific transmission rates
- Transmission in public transport

</details>

<details>
<summary><b>References</b></summary>
<br>

- Arumuru, V., Pasa, J., & Samantaray, S. S. (2020). Experimental visualization of sneezing and efficacy of face masks and shields. *Physics of Fluids, 32*(11). https://doi.org/10.1063/5.0030101
- Beatty, B. J. (2019). *Hybrid-Flexible Course Design.* EdTech Books. https://edtechbooks.org/hyflex
- Eggo, R. M., et al. (2016). Respiratory virus transmission dynamics determine timing of asthma exacerbation peaks. *PNAS, 113*(8). https://doi.org/10.1073/pnas.1518677113
- Hekmati, A., et al. (2022). Simulating COVID-19 classroom transmission on a university campus. *PNAS, 119*(22). https://doi.org/10.1073/pnas.2116165119
- Khosronejad, A., et al. (2021). A computational study of expiratory particle transport during breathing with and without face masks. *Physics of Fluids, 33*(6). https://doi.org/10.1063/5.0054204
- Wang, C. C., et al. (2021). Airborne transmission of respiratory viruses. *Science, 373*(6558). https://doi.org/10.1126/science.abd9149
- Werner, D., & von Däniken, T. (2022). University of Zurich, Figures. https://www.uzh.ch/cmsssl/en/explore/portrait/figures.html

</details>
