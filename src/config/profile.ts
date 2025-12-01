export const profile = {
  name: "Nico Mannarelli",
  title: "Computer Science & Mathematics Student",
  phone: "(443) 845 - 8181",
  email: "nicomannarelli@gmail.com",
  location: "College Park, MD",
  profileImage: "/profile.jpg",
  social: {
    github: "https://github.com/nico-mannarelli",
    linkedin: "https://linkedin.com/in/nico-mannarelli",
  },
  skills: {
    languages: ["Python", "C", "C++", "Java", "MATLAB", "SQL", "Rust"],
    frameworks: ["Pandas", "PyTorch", "NumPy", "Qiskit", "PennyLane", "Ultralytics"],
    tools: ["Git", "Github", "VSCode", "Jupyter", "AWS", "Azure"],
  },
  experience: [
    {
      title: "Research Assistant",
      company: "Applied Research Lab for Intelligence and Security (ARLIS)",
      dateRange: "June 2025 - August 2025",
      location: "College Park, MD",
      bullets: [
        "Conducted applied research in quantum machine learning and hybrid classical–quantum architectures for intelligence analysis and decision-support systems",
        "Achieved 97.3% accuracy on the MNIST dataset using a custom-parameterized quantum circuit optimized via PennyLane and PyTorch with a gradient-free evolutionary optimizer",
        "Deployed quantum simulation experiments on ARLIS's classified HPC environment, ensuring compliance with DoD and NIST security standards under Secret Clearance"
      ],
    },
    {
      title: "Research Assistant",
      company: "FIRE Quantum Machine Learning Lab - University of Maryland",
      dateRange: "June 2024 - August 2024",
      location: "College Park, MD",
      bullets: [
        "Conducted research on Variational Quantum Circuits (VQC) applied to Reinforcement Learning (RL)",
        "Focused on performance and trainability of quantum algorithms with data re-uploading",
        "Developed quantum-classical hybrid approaches to improve decision-making in classical control problems"
      ],
    },
    {
      title: "Research Assistant",
      company: "FIRE Rapid Diagnostics - University of Maryland",
      dateRange: "August 2023 - December 2024",
      location: "College Park, MD",
      bullets: [
        "Developed microfluidic and paperfluidic devices for point-of-care diagnostics",
        "Gained experience with Matlab, CAD, 3D printing, cutter-plotting, and PDMS molding for device fabrication",
        "Focused on rapid, on-site chemical and bio-analysis for healthcare, environmental monitoring, and disease control"
      ],
    },
  ],
};
