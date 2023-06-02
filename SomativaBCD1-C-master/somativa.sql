#CRIAÇÃO E ALTERAÇÃO DAS TABELAS

alter table usuarios
add column foto varchar(200) null;

alter table usuarios
add column celular varchar(20) null;


create table status_tarefa (
	statusID bigint auto_increment not null,
    status varchar(40) not null,
    primary key (statusID)
);

create table tarefas (
	tarefaID bigint auto_increment not null,
    tarefa varchar (200) not null,
    descricao text not null,
    prazo date,
    data_abertura datetime default now(),
    data_finalizou datetime not null,
    localID bigint not null,
    solicitanteID bigint not null,
    statusID bigint not null,
    primary key (tarefaID),
    foreign key (localID) references locais(id),
    foreign key (solicitanteID) references usuarios(id),
    foreign key (statusID) references status_tarefa(statusID)
);

create table tarefas_responsaveis (
	id bigint auto_increment not null,
    tarefaID bigint not null,
    responsavelID bigint not null,
    primary key (id),
    foreign key (tarefaID) references tarefas(tarefaID),
    foreign key (responsavelID) references usuarios(id)
);

create table tarefas_historicos (
	id bigint auto_increment not null,
    tarefaID bigint not null,
    statusID bigint not null,
    data_inclusao datetime not null default now(),
    comentario text null,
    primary key (id),
    foreign key (tarefaID) references tarefas(tarefaID),
    foreign key (statusID) references status_tarefa(statusID)
);

create table anexos_tarefas (
	id bigint auto_increment not null,
    tarefaID bigint not null,
    statusID bigint not null,
    anexo varchar(200),
    primary key (id),
    foreign key (tarefaID) references tarefas(tarefaID),
    foreign key (statusID) references status_tarefa(statusID)
);

#INSERINDO OS DADOS

insert into status_tarefa (status) values ("Aberta"), ("Em Andamento"), ("Concluida"), ("Encerrada");

insert into tarefas (tarefa, descricao, prazo, data_finalizou, localID, solicitanteID, statusID) values ("Arrumar a Biblioteca", "Organizar os livros, ordenando por Título", "2023-06-18", "2023-06-28", 2, 2, 4),
("Manteção nos Multimetros", "Troca a bateria dos multimetros do lab de Eletrônica", "2023-06-20", "2023-06-20", 3, 1, 1),
("Formatar PC 01 lab de informática", "PC 01 muito lento, precisa ser formatado", "2023-08-10", "2023-08-11", 5, 3, 2);

insert into tarefas_responsaveis (tarefaID, responsavelID) values (1, 3), (1, 5), (1, 5), (2, 6), (3, 4);

insert into tarefas_historicos (tarefaID, statusID, comentario) values (1, 1, "Começando a tarefa, livros estão ficando organizado por Títulos"), (1, 3, "Tarefa finalizada, todos os livros organizados"),
(2, 2, "Retirando a bateria antiga dos multimetros"), (3, 3, "Formatado o PC 01 e instalado os drivers");

insert into anexos_tarefas (tarefaID, statusID, anexo) values (1, 1, "www.www.www.com"), (1, 3, "www.www.www.com"), (2, 1, "www.www.www.com"), (3, 1, "www.www.www.com"), (3, 2, "www.www.www.com");


#CONSULTAS
#CRIE UMA CONSULTA QUE MOSTRE TODOS OS LOCAIS QUE TIVERAM ASSOCIAÇÃO A MAIS DE DUAS TAREFAS
select  l.id, l.nome, count(*) Tarefas_no_Local
FROM tarefas t
inner join locais l on t.localID = l.id
group by l.id
having Tarefas_no_Local >2;

#CRIE UMA CONSULTA QUE MOSTRE TODOS OS USUÁRIOS QUE TIVERAM ASSOCIAÇÃO A DUAS TAREFAS NO MÍNIMO
SELECT tarefaID ,COUNT(*) FROM tarefas_responsaveis
group by responsavelID, tarefaID
HAVING COUNT(*) >=2;

SELECT * FROM tarefas_responsaveis