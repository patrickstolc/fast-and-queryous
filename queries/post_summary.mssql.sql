WITH ReactionSummary AS (
    SELECT
        CommentId,
        SUM(CASE WHEN ReactionType = 'like' THEN 1 ELSE 0 END) AS Likes,
        SUM(CASE WHEN ReactionType = 'dislike' THEN 1 ELSE 0 END) AS Dislikes
    FROM
        Reactions
    GROUP BY
        CommentId
), CommentsWithReactions AS (
    SELECT
        C.PostId,
        COUNT(C.CommentId) AS CommentCount,
        ISNULL(SUM(RS.Likes), 0) AS TotalLikes,
        ISNULL(SUM(RS.Dislikes), 0) AS TotalDislikes
    FROM
        Comments C
            LEFT JOIN ReactionSummary RS ON C.CommentId = RS.CommentId
    GROUP BY
        C.PostId
)
SELECT
    P.PostId,
    P.Title,
    P.Content,
    CR.CommentCount,
    CR.TotalLikes,
    CR.TotalDislikes
FROM
    Posts P
        JOIN
    CommentsWithReactions CR ON P.PostId = CR.PostId
ORDER BY
    P.PublicationDate DESC;