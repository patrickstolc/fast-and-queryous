SELECT
    P.PostId,
    P.Title,
    P.Content,
    (SELECT
         C.CommentId,
         C.CommentText,
         (SELECT
              R.ReactionType,
              COUNT(*) AS ReactionCount
          FROM Reactions R
          WHERE R.CommentId = C.CommentId
          GROUP BY R.ReactionType
        FOR JSON PATH) AS Reactions
FROM Comments C
WHERE C.PostId = P.PostId
    FOR JSON PATH) AS Comments
FROM
    Posts P
WHERE
    P.PostId = 22
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
