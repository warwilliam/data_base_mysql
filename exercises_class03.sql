use dhtube;

# 1.	Listar todos os países que contêm a letra A, ordenados alfabeticamente.

select p.nome as Country
from pais p
where p.nome like '%a%'
order by Country ;


#2.	Gere uma lista de usuários, com detalhes de todos os seus dados, o avatar que possuem e a qual país pertencem.

select u.* , p.nome as Country, a.nome as Avatar
from usuario u
left join pais p on u.Pais_idPais = p.idPais
left join avatar a on a.idAvatar = u.Avatar_idAvatar
order by u.nome;


#3.	Faça uma lista com os usuários que possuem playlists, mostrando a quantidade que possuem.

select u.nome as User, count(p.idPlaylist) as playlistAmount
from usuario u
inner join playlist p on p.usuario_idUsuario = u.idUsuario
group by User
order by User; 


# 4.	Mostrar todos os canais criados entre 01/04/2021 e 01/06/2021.

select c.nome as Channel
from canal c
where dataCriacao between '2021-04-01' and '2021-06-01';


# 5.	Mostre os 5 vídeos com a menor duração, listando o título do vídeo, a tag ou tags que possuem,
#  o nome de usuário e o país ao qual correspondem.

select v.titulo as tittle, v.duracao, group_concat(h.nome) as tags, u.nome as User, p.nome as Country 
from video v
inner join video_hashtag vh on vh.video_idVideo = v.idVideo
inner join hashtag h on h.idHashtag = vh.hashtag_idHashtag
inner join usuario u on u.idUsuario = v.usuario_idUsuario
inner join pais p on p.idPais = u.Pais_idPais
group by tittle, User, Country
order by v.duracao
limit 5;


# 6.	Liste todas as playlists que possuem menos de 3 vídeos, mostrando o nome de usuário e avatar que possuem.

select p.nome  as Playlist, u.nome as User, a.nome as Avatar, count(pv.video_idVideo) as videoAmount
from playlist p
inner join usuario u  on u.idUsuario = p.usuario_idUsuario
inner join avatar a on a.idAvatar = u.Avatar_idAvatar
inner join playlist_video pv on p.idPlaylist = pv.Playlist_idPlaylist
group by Playlist_idPlaylist
having videoAmount < 3;


# 7.	Insira um novo avatar e atribua-o a um usuário.

select * from avatar;
insert into avatar values( 86 , 'Warwilliam', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9Gc');

select * from usuario;
update  usuario 
set usuario.Avatar_idAvatar =86 
where usuario.idUsuario = 10;


# 8.	Gere um relatório de estilo de classificação de avatares usados por país.

	select a.nome as Avatar, p.nome as Country, count(u.Avatar_idAvatar) as AvatarAmount
    from avatar a
    inner join usuario u on u.Avatar_idAvatar = a.idAvatar
    inner join pais p on u.Pais_idPais = p.idPais
    group by a.nome, p.nome
    order by Country desc;
    
#9.	Insira um usuário com os seguintes dados:
#a.	Nome: Roberto Rodriguez
#b.	E-mail: rrodriguez@dhtube.com
#c.	Password: rr1254
#d.	Data de nascimento: 01 de novembro de 1975
#e.	Código postal: 1429
#f.	País: Argentino
#g.	Avatar: carita feliz 

select * from pais
where pais.nome ='Argentina'; 
# id Argentina 9
select * from avatar
where avatar.nome = 'carita feliz';
# idavatar carita feliz 85

select * from usuario;

insert into usuario(idUsuario, nome, email, senha, datanascimento, codigoPostal, Pais_idPais, Avatar_idAvatar)
values(20, 'Roberto Rodriguez', 'rrodriguez', 'rr1254', '1975-11-01', 1429, 9, 85 );

# 10.	Gere um relatório de todos os vídeos e suas hashtags, 
# mas apenas aqueles cujos nomes de hashtags contêm menos de 10 caracteres, 
# classificados em ordem crescente pelo número de caracteres na hashtag.

select v.titulo as Tittle, group_concat(distinct h.nome ) as hashtag
from video v
inner join video_hashtag vh on vh.video_idVideo = v.idVideo
inner join hashtag h on h.idHashtag = vh.hashtag_idHashtag
where length(h.nome) < 10
group by v.titulo
order by length(h.nome);



