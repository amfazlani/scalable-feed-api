
# 📡 Facebook-Like Feed API (Rails)

A scalable Ruby on Rails API that implements a **Facebook/Instagram-style feed system**, focusing on efficient feed generation, precomputed timelines, and optimized read performance.

---

# 🚀 Core Feature: User Feed

The main feature is a **personalized feed** that aggregates posts from users you follow.

Instead of computing the feed dynamically on each request, this system uses a **precomputed feed model (`FeedItem`)** for high performance.

---

# 🌐 API Endpoint

## GET `/api/v1/feed`

Returns a paginated feed of posts for the authenticated user.

---

## 🔐 Authentication

In production, all endpoints require authentication via `current_user` (token-based or session-based depending on configuration).

For demo and local development purposes, authentication is currently disabled and `current_user` is mocked in the controller:

```ruby
def current_user
  User.first
end
```

---

## 📥 Request

```http
GET /api/v1/feed?page=1

[
  {
    "id": 25,
    "title": "My vacation post",
    "description": "Hello world",
    "image_url": "https://...",
    "likes_count": 10,
    "comments_count": 3,
    "viewer_has_liked": true,
    "created_at": "2026-05-12T10:00:00Z"
  }
]
```

# 🧱 System Architecture

The system is designed around a **precomputed feed model**, where feed data is generated asynchronously and stored for fast read access.

---

## 🧠 High-Level Design


User Action (Post Creation)
↓
Post saved in DB
↓
Sidekiq Fanout Job (async)
↓
FeedItem rows generated for followers
↓
Feed API reads FeedItem table (fast query)


---

## 🧩 Core Components

### 1. Users
Represents platform users who can:
- Create posts
- Follow other users
- Like and comment on posts

---

### 2. Posts
Represents content created by users.

Each post can have:
- Images / text content
- Likes
- Comments

---

### 3. Subscriptions (Follow Graph)
Defines the social graph:

Used to determine feed audience.

---

### 4. FeedItem (Core Optimization Layer)
A **denormalized table** that stores feed entries per user.

Each row represents:
- A post
- Delivered to a specific user’s feed

This enables:
- Fast feed queries
- Avoidance of expensive joins

---

# ⚙️ Feed Generation Strategy

## 🪄 Fanout-on-Write Architecture

When a user creates a post:

1. Post is persisted
2. A background job is triggered
3. FeedItem rows are created for all followers

```ruby
after_create_commit :fanout_feed
```

# 🚀 Sidekiq Background Processing

Feed generation is handled asynchronously using Sidekiq to ensure the API remains fast and responsive.

---

## 🧠 Why Sidekiq is used

Without background jobs, feed generation would:

- Block the request cycle during post creation
- Fail under large follower counts
- Create high latency spikes

Sidekiq moves this work off the request thread.

---

## ⚙️ How it works

When a user creates a post:

```text id="flow"
User creates post
→ Post is saved
→ after_create_commit triggers job
→ Sidekiq enqueues FanoutFeedJob
→ Workers generate FeedItem records
→ Feed becomes available instantly
```

---

## 🪄 Job Trigger

When a post is created, we immediately trigger a background job using `after_create_commit`. This ensures that feed generation happens only after the transaction is successfully committed to the database.

```ruby id="trigger_code"
class Post < ApplicationRecord
  after_create_commit :fanout_feed

  def fanout_feed
    FanoutFeedJob.perform_later(self.id)
  end
end
```

---

## 📊 Pagination Strategy

The feed uses **Kaminari pagination** for simplicity in the MVP.

```ruby id="kaminari"
FeedItem
  .where(user_id: current_user.id)
  .includes(post: :user)
  .order(created_at: :desc)
  .page(params[:page])
 ```

Limitation: OFFSET-based pagination does not scale well.

Future: Cursor pagination using (id \< last_id)..per(10)

---

# ⚡ Performance Optimizations

-   includes(post: :user) to avoid N+1 queries
-   bulk insert_all for fanout
-   counter cache for likes/comments
-   indexed feed_items.user_id for fast lookup

---


# 📈 Scaling Strategy

-   Fanout-on-write for fast reads
-   Sidekiq async processing for heavy work
-   Precomputed FeedItem table for O(1) feed queries
-   Future hybrid model for high-follower users

---

## 🧪 Running the Project Tests

This project uses RSpec for testing and Sidekiq in inline mode during test execution to ensure deterministic behavior for background jobs.

### Install dependencies

```bash
bundle install
```

### Set up the test database

```
rails db:create RAILS_ENV=test
rails db:migrate RAILS_ENV=test
```

### Run the full test suite

```
bundle exec rspec
``` 

# 🧠 Conclusion

A precomputed social feed system using: - Sidekiq background
processing - Fanout-on-write architecture - Indexed FeedItem queries -
Optimized read-heavy design