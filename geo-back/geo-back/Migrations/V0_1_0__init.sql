create
extension if not exists postgis;

-- таблица пользователей
create table users
(
    id            uuid primary key,        -- уникальный идентификатор пользователя
    email         text not null,           -- электронная почта пользователя
    password_hash text not null,           -- хешированный пароль
    role          text not null,           -- роль пользователя (например, admin или geologist)
    created_at    timestamp default now(), -- время создания записи
    updated_at    timestamp default now()  -- время последнего обновления записи
);

-- таблица логов действий
create table logs
(
    id         uuid primary key,       -- уникальный идентификатор записи лога
    user_id    uuid      not null,     -- идентификатор пользователя, совершившего действие
    action     text      not null,     -- описание действия
    timestamp  timestamp not null,     -- время совершения действия
    metadata   jsonb,                  -- дополнительные данные события
    updated_at timestamp default now() -- время последнего обновления записи
);

-- таблица для связи пользователей и локаций (многие ко многим)
create table location_users
(
    location_id uuid not null,           -- идентификатор локации
    user_id     uuid not null,           -- идентификатор пользователя
    created_at  timestamp default now(), -- время добавления записи
    updated_at  timestamp default now(), -- время последнего обновления записи
    primary key (location_id, user_id)
);

-- таблица локаций
create table locations
(
    id          uuid primary key,                -- уникальный идентификатор локации
    name        text not null,                   -- название локации
    description text,                            -- описание локации
    geometry    geometry(polygon,4326) not null, -- геометрия локации (полигон в системе координат wgs84)
    created_at  timestamp default now(),         -- время создания записи
    updated_at  timestamp default now()          -- время последнего обновления записи
);

-- таблица изолиний
create table isolines
(
    id          uuid primary key,                   -- уникальный идентификатор изолинии
    location_id uuid             not null,          -- идентификатор локации, к которой принадлежит изолиния
    elevation   double precision not null,          -- значение высоты изолинии
    geometry    geometry(linestring,4326) not null, -- геометрия изолинии (linestring в wgs84)
    source      text,                               -- источник данных изолинии
    created_at  timestamp default now(),            -- время создания записи
    updated_at  timestamp default now(),            -- время последнего обновления записи
    constraint fk_isolines_location foreign key (location_id) references locations (id)
);

-- таблица профилей местности (результат асинхронного процесса)
create table terrain_profiles
(
    id          uuid primary key,                   -- уникальный идентификатор профиля
    location_id uuid not null,                      -- идентификатор локации, к которой относится профиль
    created_by  uuid not null,                      -- идентификатор пользователя, создавшего профиль
    name        text not null,                      -- название профиля
    description text,                               -- описание профиля
    geometry    geometry(linestring,4326) not null, -- геометрия профиля (linestring в wgs84)
    created_at  timestamp default now(),            -- время создания профиля
    updated_at  timestamp default now(),            -- время последнего обновления профиля
    constraint fk_terrain_profiles_location foreign key (location_id) references locations (id),
    constraint fk_terrain_profiles_created_by foreign key (created_by) references users (id)
);

-- таблица правок профилей
create table profile_edits
(
    id                 uuid primary key,        -- уникальный идентификатор правки
    profile_id         uuid      not null,      -- идентификатор профиля, к которому относится правка
    user_id            uuid      not null,      -- идентификатор пользователя, внесшего правку
    edit_type          text      not null,      -- тип правки (ручное, автоматическое и т.д.)
    change_description text,                    -- описание изменений, внесенных в профиль
    timestamp          timestamp not null,      -- время внесения правки
    updated_at         timestamp default now(), -- время последнего обновления записи
    constraint fk_profile_edits_profile foreign key (profile_id) references terrain_profiles (id),
    constraint fk_profile_edits_user foreign key (user_id) references users (id)
);

-- таблица отчётов, сгенерированных по профилям
create table reports
(
    id           uuid primary key,        -- уникальный идентификатор отчёта
    profile_id   uuid      not null,      -- идентификатор профиля, по которому сформирован отчёт
    report_type  text      not null,      -- тип отчёта (pdf, csv, dxf и т.д.)
    file_path    text      not null,      -- путь к файлу отчёта
    user_id      uuid      not null,      -- идентификатор пользователя, сгенерировавшего отчёт
    generated_at timestamp not null,      -- время генерации отчёта
    updated_at   timestamp default now(), -- время последнего обновления отчёта
    constraint fk_reports_profile foreign key (profile_id) references terrain_profiles (id),
    constraint fk_reports_user foreign key (user_id) references users (id)
);

-- таблица запросов на асинхронное создание профиля
create table profile_requests
(
    id                uuid primary key,          -- уникальный идентификатор запроса
    user_id           uuid             not null, -- идентификатор пользователя, инициировавшего запрос
    location_id       uuid             not null, -- идентификатор локации, для которой запрошен профиль
    sampling_interval double precision not null, -- интервал выборки данных для построения профиля
    profile_mode      text             not null, -- режим формирования профиля (например, detailed или quick)
    status            text             not null, -- статус запроса (pending, processing, completed, failed)
    created_at        timestamp default now(),   -- время создания запроса
    updated_at        timestamp default now(),   -- время последнего обновления запроса
    completed_at      timestamp                  -- время завершения запроса
);

-- функция для обновления поля updated_at после любого изменения
create
or replace function update_updated_at_column()
returns trigger as $$
begin
  new.updated_at
= now();
return new;
end;
$$
language plpgsql;

-- триггеры для обновления updated_at во всех таблицах
create trigger trg_update_users
    before update
    on users
    for each row
    execute function update_updated_at_column();

create trigger trg_update_logs
    before update
    on logs
    for each row
    execute function update_updated_at_column();

create trigger trg_update_location_users
    before update
    on location_users
    for each row
    execute function update_updated_at_column();

create trigger trg_update_locations
    before update
    on locations
    for each row
    execute function update_updated_at_column();

create trigger trg_update_isolines
    before update
    on isolines
    for each row
    execute function update_updated_at_column();

create trigger trg_update_terrain_profiles
    before update
    on terrain_profiles
    for each row
    execute function update_updated_at_column();

create trigger trg_update_profile_edits
    before update
    on profile_edits
    for each row
    execute function update_updated_at_column();

create trigger trg_update_reports
    before update
    on reports
    for each row
    execute function update_updated_at_column();

create trigger trg_update_profile_requests
    before update
    on profile_requests
    for each row
    execute function update_updated_at_column();
