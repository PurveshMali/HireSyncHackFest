from flask import Flask, jsonify
import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from math import radians, sin, cos, sqrt, atan2

# Initialize Firebase
cred = credentials.Certificate("ML/firebase/h4ck-52132-firebase-adminsdk-fbsvc-7f014af5c4.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

app = Flask(__name__)


# Load data from Firebase
def fetch_data():
    workers_ref = db.collection("Workers").stream()
    jobs_ref = db.collection("Jobs").stream()
    
    workers = [w.to_dict() for w in workers_ref]
    jobs = [j.to_dict() for j in jobs_ref]
    
    return pd.DataFrame(workers), pd.DataFrame(jobs)

# Calculate distance 
def haversine_distance(lat1, lon1, lat2, lon2):
    R = 6371  # Earth radius in km
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = sin(dlat/2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon/2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return R * c

# Recommendation System
def generate_recommendations():
    workers_df, jobs_df = fetch_data()
    
    if workers_df.empty or jobs_df.empty:
        return {}
    
    vectorizer = TfidfVectorizer()
    workers_df["Skills_Text"] = workers_df["Skills"].apply(lambda x: " ".join(x))
    jobs_df["Skills_Text"] = jobs_df["Required_Skills"].apply(lambda x: " ".join(x))
    worker_vectors = vectorizer.fit_transform(workers_df["Skills_Text"]).toarray()
    job_vectors = vectorizer.transform(jobs_df["Skills_Text"]).toarray()
    
    recommendations = {}
    
    for _, worker in workers_df.iterrows():
        similarities = cosine_similarity([worker_vectors[_]], job_vectors).flatten()
        
        filtered_jobs = [
            jobs_df.iloc[i].to_dict() for i in similarities.argsort()[-5:][::-1]
            if haversine_distance(worker["Latitude"], worker["Longitude"], jobs_df.iloc[i]["Latitude"], jobs_df.iloc[i]["Longitude"]) <= 100
            and jobs_df.iloc[i]["Experience_Required"] <= worker["Experience"]
        ]
        recommendations[worker["Worker_ID"]] = filtered_jobs
    
    for _, job in jobs_df.iterrows():
        similarities = cosine_similarity([job_vectors[_]], worker_vectors).flatten()
        
        filtered_workers = [
            workers_df.iloc[i].to_dict() for i in similarities.argsort()[-5:][::-1]
            if haversine_distance(job["Latitude"], job["Longitude"], workers_df.iloc[i]["Latitude"], workers_df.iloc[i]["Longitude"]) <= 100
            and job["Experience_Required"] <= workers_df.iloc[i]["Experience"]
        ]
        recommendations[job["Job_ID"]] = filtered_workers
    
    return recommendations

@app.route('/recommend/jobs/<worker_id>', methods=['GET'])
def recommend_jobs(worker_id):
    recommendations = generate_recommendations()
    return jsonify(recommendations.get(worker_id, []))

@app.route('/recommend/workers/<job_id>', methods=['GET'])
def recommend_workers(job_id):
    recommendations = generate_recommendations()
    return jsonify(recommendations.get(job_id, []))

# @app.route('/update/recommendations', methods=['POST'])
# def update_recommendations():
#     recommendations = generate_recommendations()
    
#     for worker_id, jobs in recommendations.items():
#         if worker_id.startswith("W"):
#             db.collection("WorkerRecommendations").document(worker_id).set({"Jobs": jobs})
    
#     for job_id, workers in recommendations.items():
#         if job_id.startswith("J"):
#             db.collection("JobRecommendations").document(job_id).set({"Workers": workers})
    
#     return jsonify({"message": "Recommendations updated successfully!"})

if __name__ == '__main__':
    app.run(debug=True)