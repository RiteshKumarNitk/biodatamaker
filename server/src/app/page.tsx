export default function Home() {
  return (
    <main style={{ padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <h1>PhotoIdeas API</h1>
      <p>Backend API for SnapIdeas Photo Ideas App</p>
      <h2>Available Endpoints</h2>
      <ul>
        <li><code>POST /api/auth/login</code> - User login</li>
        <li><code>POST /api/auth/signup</code> - User registration</li>
        <li><code>GET /api/auth/me</code> - Get current user</li>
        <li><code>PUT /api/auth/profile</code> - Update user profile</li>
        <li><code>GET /api/categories</code> - Get all categories</li>
        <li><code>POST /api/categories</code> - Create category</li>
        <li><code>DELETE /api/categories/[id]</code> - Delete category</li>
        <li><code>GET /api/photos</code> - Get all photos</li>
        <li><code>POST /api/photos</code> - Upload photo</li>
        <li><code>GET /api/photos/liked</code> - Get user liked photos</li>
        <li><code>GET /api/quotes</code> - Get all quotes</li>
        <li><code>POST /api/quotes</code> - Create quote</li>
        <li><code>GET /api/filters</code> - Get all face filters</li>
        <li><code>POST /api/upload/[bucket]</code> - Upload file</li>
      </ul>
    </main>
  );
}
