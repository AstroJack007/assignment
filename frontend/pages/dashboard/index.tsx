import { useEffect, useState } from "react";
import { supabase } from "../../lib/supabaseClient";
import Head from "next/head";

type Task = {
  id: string;
  type: string;
  status: string;
  application_id: string;
  due_at: string;
};

export default function TodayDashboard() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  async function fetchTasks() {
    setLoading(true);
    setError(null);

    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);

      const { data, error } = await supabase
        .from("tasks")
        .select("*")
        .neq("status", "completed")
        .gte("due_at", today.toISOString())
        .lt("due_at", tomorrow.toISOString());

      if (error) throw error;
      setTasks(data || []);
    } catch (err: any) {
      console.error(err);
      setError("Failed to load tasks");
    } finally {
      setLoading(false);
    }
  }

  async function markComplete(id: string) {
    try {
      const { error } = await supabase
        .from("tasks")
        .update({ status: "completed" })
        .eq("id", id);

      if (error) throw error;

      // Update local state
      setTasks(tasks.filter((t) => t.id !== id));
    } catch (err: any) {
      console.error(err);
      alert("Failed to update task");
    }
  }

  useEffect(() => {
    fetchTasks();
  }, []);

  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'call': return '📞';
      case 'email': return '✉️';
      case 'review': return '📋';
      default: return '📌';
    }
  };

  const formatTime = (dateStr: string) => {
    const date = new Date(dateStr);
    return date.toLocaleTimeString('en-US', {
      hour: 'numeric',
      minute: '2-digit',
      hour12: true
    });
  };

  return (
    <>
      <Head>
        <title>Today&apos;s Tasks | LearnLynk</title>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
      </Head>

      <div className="container">
        {/* Header */}
        <header className="page-header">
          <div>
            <h1>Today&apos;s Tasks</h1>
            <p className="page-subtitle">
              {new Date().toLocaleDateString('en-US', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
              })}
            </p>
          </div>
          <button className="btn btn-primary" onClick={fetchTasks}>
            ↻ Refresh
          </button>
        </header>

        {/* Stats */}
        <div className="stats-grid">
          <div className="stat-card">
            <span className="stat-value">{tasks.length}</span>
            <span className="stat-label">Tasks Due Today</span>
          </div>
          <div className="stat-card">
            <span className="stat-value">
              {tasks.filter(t => t.type === 'call').length}
            </span>
            <span className="stat-label">📞 Calls</span>
          </div>
          <div className="stat-card">
            <span className="stat-value">
              {tasks.filter(t => t.type === 'email').length}
            </span>
            <span className="stat-label">✉️ Emails</span>
          </div>
          <div className="stat-card">
            <span className="stat-value">
              {tasks.filter(t => t.type === 'review').length}
            </span>
            <span className="stat-label">📋 Reviews</span>
          </div>
        </div>

        {/* Loading State */}
        {loading && (
          <div className="loading-container">
            <div className="spinner"></div>
            <p>Loading tasks...</p>
          </div>
        )}

        {/* Error State */}
        {error && !loading && (
          <div className="error-message">
            ⚠️ {error}
            <button className="btn btn-ghost" onClick={fetchTasks} style={{ marginLeft: '1rem' }}>
              Try Again
            </button>
          </div>
        )}

        {/* Empty State */}
        {!loading && !error && tasks.length === 0 && (
          <div className="card empty-state">
            <div className="empty-state-icon">🎉</div>
            <h2>All Clear!</h2>
            <p>No tasks due today. Enjoy your day!</p>
          </div>
        )}

        {/* Tasks Table */}
        {!loading && !error && tasks.length > 0 && (
          <div className="table-container">
            <table>
              <thead>
                <tr>
                  <th>Type</th>
                  <th>Application</th>
                  <th>Due At</th>
                  <th>Status</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {tasks.map((t) => (
                  <tr key={t.id}>
                    <td>
                      <span className={`badge badge-${t.type}`}>
                        {getTypeIcon(t.type)} {t.type}
                      </span>
                    </td>
                    <td>
                      <span className="text-truncate monospace" title={t.application_id}>
                        {t.application_id.slice(0, 8)}...
                      </span>
                    </td>
                    <td>{formatTime(t.due_at)}</td>
                    <td>
                      <span className={`badge badge-${t.status}`}>
                        {t.status}
                      </span>
                    </td>
                    <td>
                      {t.status !== "completed" && (
                        <button
                          className="btn btn-success"
                          onClick={() => markComplete(t.id)}
                        >
                          ✓ Complete
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </>
  );
}
