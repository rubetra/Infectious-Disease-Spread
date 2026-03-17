# Simulation of infectious disease spread in different classroom settings

> Course project: Agent-Based Modelling (Spring 2023) · University of Zurich · Dr. Damian R. Farine

<br>

An agent-based model in R simulating the spread of infectious disease in a university classroom, comparing different classroom formats: 

<br> 

👇 Click on the plots to view the animations!

<table>
  <tr> 
    <td><a href="https://github.com/user-attachments/assets/b336adc0-ddf9-4606-8dee-ca240413ea5d"><img src="https://github.com/user-attachments/assets/0d55f27e-ec1c-47a1-8126-bc64902a7489" width="400"/></a></td>
    <td><b>Traditional (hybrid-flexible):</b><br><br>
      - All students attend in person only.<br>
      Sick students may still go to campus with probability p = 0.2.
    </td>
  </tr>
  <tr>
    <td><a href="https://github.com/user-attachments/assets/78ca6156-08b7-4e67-86ef-010c4b0fe936"><img src="https://github.com/user-attachments/assets/efb277a5-2766-4909-a942-12d32f28e01d" width="400"/></a></td>
    <td><b>HyFlex (hybrid-flexible):</b><br><br>
      - One third of students always attends in person<br>
      - One third always online<br>
      - One third hybrid (50:50 chance each week)<br><br>
      Sick students always stay at home.
    </td>
  </tr>
</table>


<br>

## Research questions

- How much can a HyFlex class setting lower the average number of infections per student, compared to a traditional setting?
- How many classes does the average student miss due to being sick from getting infected in a traditional setting?
- How much space can the university save with a HyFlex class setting?

<br>

## Method

Each student is an agent that can be healthy, infectious, or sick, and has a certain attendance preference. Every week:

- Students are assigned to campus or remote based on preference and health status
- On-campus students are randomly assigned seats in an n_rows × n_rows grid
- Susceptible students within 2 m of an infectious student are exposed
- Infection probability: ![formula](https://latex.codecogs.com/svg.image?p=1-(1-\beta)^{n_{\text{exposures}}})​
- Infected students follow the timeline: infectious → sick → immune (3 weeks) → susceptible

The simulation runs for 100 iterations × 2 settings × 14 classroom sizes × 14 weeks.

<br>

### Assumptions

- Square classrooms, 300 students
- High season from September to April (Pappas, 2018). Simulation: 14 weeks
- Immunity for 3 weeks after recovery (Eggo et al., 2016)
- R₀ in a traditional class setting: 3 (Hekmati et al., 2022)
- Transmission threshold: 2.2 m (Khosronejad et al., 2021)
- Average number of neighbors within transmission threshold: ~11
- Beta = 3 / 11 ≈ 0.27 → 0.2

#### Assumptions for traditional setting

- Initial infection probability: 0.01 (Hekmati et al., 2022) → 3 patients zero
- On-site only
- If sick: Probability p = 0.2 the student attends the lecture anyway, p = 0.8 to miss the class

#### Assumptions for HyFlex setting
- 2 patients zero
- 1/3 of students always on-site, 1/3 always online, 1/3 hybrid (50/50)
- No missed classes (podcasts)

<br>

### Scripts

- **01_Simulation_multiweek.R**: Main script. Runs the full nested loop of the simulation.
- **assumptions_and_variables.R**: Contains the general parameters and setting-specific parameter dictionaries.
- **classroom_plots_multiweek.R**: Runs one simulation for a chosen setting and classroom size, and generates classroom status plots.
- **Barplot_avg_n_infections_per_student.R**: Bar plot of average infections per student for both settings across all classroom sizes.
- **Barplot_avg_classes_missed_per_student.R**: Same but for missed classes. Traditional setting only (HyFlex has 0 by assumption).

### Helper functions

- **fct_initialise_df.R**: Creates the empty students dataframe with all tracking columns set to zero.
- **fct_seats.R**: Generates the n_rows × n_rows seat grid with row, column, and unique seat ID per seat.
- **fct_week_of_infections.R**: Weekly cycle: Campus attendance, seat assignment, distance matrix, exposure, infection, status update.
- **fct_neighbors_within_threshold.R**: Used only to compute the average neighbors within transmission distance to derive beta from R₀.
- **fct_stats.R**: Aggregates summary_per_size into mean ± SE per setting and classroom size, used by both barplot scripts.
- **fct_classroom_plot.R**: Generates a color-coded tile plot of the classroom for a given week and saves it as a .png.
- **fct_GIF.R**: Combines all weekly .png files into an animated GIF at 2 frames per second.

<br>

## Results

<img width="551" height="487" alt="image" src="https://github.com/user-attachments/assets/dbae9943-f5e0-44c6-858b-6c3393838212" />

- At 18 rows (assumed current classroom size): HyFlex produces 26× fewer infections (0.051 vs. 1.33)
- The minimum viable square classroom for HyFlex is 14 rows vs. 18 rows for traditional → 1.65× less space needed
- For traditional to match HyFlex's worst-case infection rate, it would need 25 rows → HyFlex needs 3.19× less space
- In the traditional setting, the average student misses 0.88 classes per semester (at 18 rows), at 25 rows that's 0.23 classes.

<br>

## Conclusion
- HyFlex can drastically reduce the number of infections per student compared to a traditional setting
- HyFlex allows for smaller classroom sizes compared to traditional classes, thus potentially cutting the university’s costs for energy, heating, and maintenance
- In the traditional setting, some classes are missed due to sickness

<br>

## Limitations
The simulation does not take into account
- Duration of classes (Wang et al., 2021)
- β and thresholds depending on behaviour (masks, coughing, etc.) (Arumuru et al., 2020)
- dynamics of aerosols and ventilation (Wang et al., 2021) (Hekmati et al., 2022)
- different betas and transmission threshholds of different viruses
- transmission in public transport


<br>
  



<details>
<summary>References</summary>

- Arumuru, V., Pasa, J., & Samantaray, S. S. (2020). Experimental visualization of sneezing and efficacy of face masks and shields. Physics of Fluids,
32(11), 115129. https://doi.org/10.1063/5.0030101
- Beatty, B. J. (2019). Hybrid-Flexible Course Design: Implementing student-directed hybrid classes (1st ed.). EdTech Books.
https://edtechbooks.org/hyflex
- Eggo, R. M., Scott, J. G., Galvani, A. P., & Meyers, L. A. (2016). Respiratory virus transmission dynamics determine timing of asthma exacerbation
peaks: Evidence from a population-level model. Proceedings of the National Academy of Sciences, 113(8), 2194–2199. https://doi.org/10.1073/pnas.1518677113
- Hekmati, A., Luhar, M., Krishnamachari, B., & Matarić, M. (2022). Simulating COVID-19 classroom transmission on a university campus. Proceedings of
the National Academy of Sciences, 119(22). https://doi.org/10.1073/pnas.2116165119
- Khosronejad, A., Kang, S., Wermelinger, F., Koumoutsakos, P., & Sotiropoulos, F. (2021). A computational study of expiratory particle transport and
vortex dynamics during breathing with and without face masks. Physics of Fluids, 33(6), 066605. https://doi.org/10.1063/5.0054204
- Malczyk, B. R. (2019). Introducing Social Work to HyFlex Blended Learning: A Student-centered Approach. Journal of Teaching in Social Work, 39(4–
5), 414–428. https://doi.org/10.1080/08841233.2019.1652226
- Roy, R., Potter, S., & Yarrow, K. (2008). Designing low carbon higher education systems. International Journal of Sustainability in Higher Education,
9(2), 116–130. https://doi.org/10.1108/14676370810856279
- Wang, C. C., Prather, K. A., Sznitman, J., Jimenez, J. L., Lakdawala, S. S., Tufekci, Z., & Marr, L. C. (2021). Airborne transmission of respiratory viruses.
Science, 373(6558). https://doi.org/10.1126/science.abd9149
- Werner, D., & von Däniken, T. (2022). University of Zurich, Figures. https://www.uzh.ch/cmsssl/en/explore/portrait/figures.html
  
</details>


