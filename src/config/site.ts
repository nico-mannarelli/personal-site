export const site = {
  name: "Nico Mannarelli",
  title: "Hello, I'm Nico Mannarelli",
  profileImage: "/profile.jpg",
  
  intro: "I'm a computer science and math student passionate about systems programming, quantum machine learning, and defense technology. I enjoy building performant systems and exploring the intersection of quantum computing and ML.",
  
  notableMentions: [
    "Research Assistant at ARLIS – quantum machine learning for intelligence analysis",
    "Built a bird species detection app using YOLOv8",
    "Compiler development – implementing functional language features",
  ],
  
  interests: "When I'm not coding, I enjoy reading about quantum machine learning, exploring low-level system architectures, and contributing to defense technology research projects.",
  
  blogPosts: [
    { 
      title: "Training YOLOv8 on NABirds Dataset", 
      date: "October, 2025", 
      description: "A bird species detection application using YOLOv8 object detection model trained on the NABirds dataset. The system can identify and classify various bird species in real-time from images or video streams. Built with PyTorch 2.0, YOLOv8, Streamlit, and trained on AWS SageMaker (ml.g4dn.xlarge GPU). Deployed on Streamlit Cloud with Docker support. Tech stack: Python, PyTorch, YOLOv8, Streamlit, AWS SageMaker, OpenCV, Docker, Netlify, Railway.",
      github: "https://github.com/nico-mannarelli/bird-camera.git", 
      demo: "https://bird-camera-cdp4j7hnunww5vie2ty4fa.streamlit.app/" 
    },
    { 
      title: "Earthquake Activity Analysis using ML", 
      date: "July, 2025", 
      description: "Machine learning analysis of earthquake data from the USGS to identify patterns, predict seismic activity, and analyze historical earthquake trends. Explores whether features like location and depth can predict earthquake strength or classify seismic events. Tech stack: Python, Jupyter Notebook, pandas, scikit-learn, matplotlib, HTML.",
      github: "https://github.com/nico-mannarelli/earthquake_analysis.git" 
    },
    { 
      title: "UMD Math Resource Website", 
      date: "November, 2025", 
      description: "A comprehensive web resource for University of Maryland mathematics students, featuring course materials, practice problems, and study guides. Built with modern web technologies to provide an accessible learning platform. Deployed on Netlify.",
      github: "https://github.com/yourusername/project-name", 
      demo: "https://math-resources-app.netlify.app/" 
    },
    { 
      title: "Quantum ML Portfolio", 
      date: "July, 2024", 
      description: "A portfolio showcasing quantum machine learning projects including quantum angle encoding, deep Q-learning (DQN), and variational quantum circuits (VQC). Features implementations using Qiskit for quantum state preparation, PyTorch for reinforcement learning, and PennyLane for quantum circuit visualization. Tech stack: Python, Qiskit, PennyLane, PyTorch, OpenAI Gym, NumPy, SciPy, Matplotlib.",
      github: "https://github.com/nico-mannarelli/quantum_ML.git" 
    },
  ],
  
  skills: "I work primarily with C, Python, Java, and Rust. I'm experienced with quantum computing frameworks like Qiskit and Pennylane, AWS(EC2, S3, Lambda), and building secure, scalable systems.",
};
