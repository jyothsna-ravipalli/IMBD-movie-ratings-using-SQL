use ap;
drop procedure if exists episode_views;

delimiter //

create procedure episode_views()
begin
    Declare Lowest_title text;
    Declare Highest_title text;
    Declare Avg_Viewers text;
    Declare Highest_Viewed text;
    Declare Lowest_Viewed text;
    Declare Highest_watched text;
    Declare Lowest_watched text;


select concat ("The average amount of views per episode is about ", round(avg(us_viewers), 2), " per episode.") 
into Avg_Viewers
from episode_list;

select title, max(us_viewers)
into Highest_title, Highest_Viewed
from episode_list e
group by title, us_viewers
order by us_viewers desc
limit 1;

select title, min(us_viewers)
into lowest_title, lowest_Viewed
from episode_list e
group by title, us_viewers
order by us_viewers asc
limit 1;

select concat(" The most viewed episode of House MD was ", highest_title, " with a US Viewer total of ", highest_viewed, ".") 
into highest_watched
from episode_list
limit 1;

select concat(" The least viewed episode of House MD was ", lowest_title, " with a US Viewer total of ", lowest_viewed, ".") 
into lowest_watched
from episode_list
limit 1;

Select Avg_Viewers as 'Average Viewers Per Episode', highest_watched as 'Highest Watched Episode', lowest_watched as 'Lowest Watched Episode';

end //

call episode_views();
