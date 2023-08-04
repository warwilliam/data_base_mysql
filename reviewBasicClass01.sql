select * from dhtube.video_hashtag;


select v.titulo as video, v.descricao, h.nome as hashtag, count(h.idHashtag) as qtdHashtag
from video v
inner join video_hashtag vh
on v.idvideo = vh.video_idVideo
inner join hashtag h
on h.idHashtag = vh.hashtag_idHashtag
group by v.titulo
order by qtdHashtag desc
limit 10
offset 5;


#Mais curtidas
select v.titulo, count(r.Tiporeacao_idTiporeacao) as likes
from video v
inner join reacao r
where v.idvideo = r.video_idVideo
group by titulo
order by likes desc;

#Rank assinantes por pais
select count(u.nome), p.nome as pais
from usuario u
inner join pais p
where u.Pais_idPais = p.idPais
group by pais 
order by u.nome desc;

# videos das playslists
select p.nome as PlayList, count(video.titulo) as qtdVideos, u.nome as usuario
from playlist p
inner join usuario u
on u.idUsuario = p.usuario_idUsuario
inner join video
where video.usuario_idUsuario = u.idUsuario
group by Playlist
order by qtdVideos;

select u.nome as user, count(v.titulo) as qtdvideo
from usuario u
inner join video v
where u.idUsuario = v.usuario_idUsuario
group by user
order by qtdvideo desc;




