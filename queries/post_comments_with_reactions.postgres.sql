SELECT
    P.PostId,
    P.Title,
    P.Content,
    (
        SELECT
            JSONB_AGG(JSONB_BUILD_OBJECT(
                    'CommentId', C.CommentId,
                    'CommentText', C.CommentText,
                    'Reactions', (
                        SELECT JSONB_OBJECT_AGG(reaction_type, reaction_count)
                        FROM (
                                 SELECT R.ReactionType AS reaction_type, COUNT(*) AS reaction_count
                                 FROM Reactions R
                                 WHERE R.CommentId = C.CommentId
                                 GROUP BY R.ReactionType
                             ) AS reaction_counts
                    )
                      ))
        FROM Comments C
        WHERE C.PostId = P.PostId
    ) AS Comments
FROM
    Posts P
WHERE
    P.PostId = 22;