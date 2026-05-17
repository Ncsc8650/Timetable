create extension if not exists pgcrypto;

create table if not exists profiles (
  id uuid primary key default gen_random_uuid(),
  username text not null unique,
  full_name text,
  role text not null default 'staff',
  created_at timestamptz not null default now()
);

create table if not exists courses (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  batch text,
  description text,
  created_at timestamptz not null default now()
);

create table if not exists teachers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  rank text,
  department text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists subjects (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references courses(id) on delete cascade,
  name text not null,
  code text,
  total_hours numeric(6,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists teaching_methods (
  id uuid primary key default gen_random_uuid(),
  name text not null unique
);

create table if not exists rooms (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  building text
);

create table if not exists dress_codes (
  id uuid primary key default gen_random_uuid(),
  name text not null unique
);

create table if not exists time_slots (
  id smallint primary key,
  label text not null unique,
  start_time time not null,
  end_time time not null
);

insert into time_slots (id, label, start_time, end_time) values
  (1, '๐๘๐๐ - ๑๐๐๐', '08:00', '10:00'),
  (2, '๑๐๐๐ - ๑๒๐๐', '10:00', '12:00'),
  (3, '๑๓๐๐ - ๑๕๐๐', '13:00', '15:00'),
  (4, '๑๕๐๐ - ๑๗๐๐', '15:00', '17:00')
on conflict (id) do nothing;

create table if not exists schedules (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references courses(id) on delete restrict,
  subject_id uuid not null references subjects(id) on delete restrict,
  teacher_id uuid references teachers(id) on delete set null,
  method_id uuid references teaching_methods(id) on delete set null,
  room_id uuid references rooms(id) on delete set null,
  date_text text not null,
  study_date date,
  time_slot_id smallint not null references time_slots(id),
  used_hours numeric(6,2) default 0,
  total_hours numeric(6,2) default 0,
  evidence text,
  dress_code_id uuid references dress_codes(id) on delete set null,
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_schedules_course on schedules(course_id);
create index if not exists idx_schedules_subject on schedules(subject_id);
create index if not exists idx_schedules_teacher on schedules(teacher_id);
create index if not exists idx_schedules_date_slot on schedules(study_date, time_slot_id);

create or replace view schedule_view as
select
  s.id,
  s.date_text as "วัน , เดือน , ปี",
  ts.label as "เวลา",
  sub.name as "วิชา",
  concat(s.used_hours, '/', s.total_hours) as "ชม.ที่ใช้ หมดไป/ชม.ทั้งหมด",
  t.name as "ผู้สอน",
  tm.name as "วิธีสอน",
  r.name as "สถานที่",
  s.evidence as "หลักฐาน",
  dc.name as "การแต่งกาย",
  s.note as "หมายเหตุ"
from schedules s
join time_slots ts on ts.id = s.time_slot_id
join subjects sub on sub.id = s.subject_id
left join teachers t on t.id = s.teacher_id
left join teaching_methods tm on tm.id = s.method_id
left join rooms r on r.id = s.room_id
left join dress_codes dc on dc.id = s.dress_code_id;
