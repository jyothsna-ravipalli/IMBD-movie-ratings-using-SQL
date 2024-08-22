USE HOUSE_MD;
/* VIEW 1: Average User Ratings by Season with Comparison */
CREATE VIEW average_user_ratings_comparison AS
WITH season_avg_ratings AS (
    SELECT
        season,
        AVG(user_rating) AS avg_user_rating
    FROM user_ratings
    GROUP BY season
),
season_comparison AS (
    SELECT
        s1.season AS season_1,
        s1.avg_user_rating AS avg_user_rating_season_1,
        s2.season AS season_2,
        s2.avg_user_rating AS avg_user_rating_season_2,
        CASE
            WHEN s1.avg_user_rating > s2.avg_user_rating THEN 'Higher'
            WHEN s1.avg_user_rating < s2.avg_user_rating THEN 'Lower'
            ELSE 'Equal'
        END AS comparison
    FROM season_avg_ratings s1
    CROSS JOIN season_avg_ratings s2
    WHERE s1.season < s2.season
)
SELECT
    season_1,
    avg_user_rating_season_1,
    season_2,
    avg_user_rating_season_2,
    comparison
FROM season_comparison;

SELECT * FROM average_user_ratings_comparison;



/* VIEW 2:top_episodes_user_ratings */
CREATE VIEW top_episodes_user_ratings AS
WITH EpisodeRatings AS (
    SELECT 
        el.season,
        el.episode_num_overall,
        AVG(ur.user_rating) AS avg_user_rating
    FROM episode_list el
    JOIN user_ratings ur ON el.season = ur.season AND el.episode_num_in_season = ur.episode_num_in_season
    GROUP BY el.season, el.episode_num_overall
)
SELECT 
    season,
    episode_num_overall,
    AVG(avg_user_rating) AS average_user_rating
FROM EpisodeRatings
GROUP BY season, episode_num_overall
ORDER BY season, average_user_rating DESC;

SELECT * FROM top_episodes_user_ratings ;


/* VIEW 3:Comment activity by episode view*/
CREATE VIEW comment_activity_by_episode AS
WITH CommentCounts AS (
    SELECT 
        episode_num_overall,
        COUNT(comment) AS comment_count
    FROM user_comments
    GROUP BY episode_num_overall
)
SELECT 
    el.*,
    cc.comment_count,
    CASE 
        WHEN cc.comment_count > AVG(cc.comment_count) OVER () THEN 'Above Average'
        ELSE 'Below Average'
    END AS comment_activity
FROM episode_list el
LEFT JOIN CommentCounts cc ON el.episode_num_overall = cc.episode_num_overall;

SELECT * FROM comment_activity_by_episode;
