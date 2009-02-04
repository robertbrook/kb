CREATE TABLE "acts_as_xapian_jobs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "model" varchar(255) NOT NULL, "model_id" integer NOT NULL, "action" varchar(255) NOT NULL);
CREATE TABLE "records" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "category" varchar(255) DEFAULT NULL NULL, "notes" text DEFAULT NULL NULL, "other_notes" text DEFAULT NULL NULL, "web_page" varchar(255) DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL, "updated_at" datetime DEFAULT NULL NULL, "name" varchar(255) DEFAULT NULL NULL, "check_by_date" date DEFAULT NULL NULL, "use_check_by_date" boolean DEFAULT NULL NULL, "summary" varchar(255) DEFAULT NULL NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "slugs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) DEFAULT NULL NULL, "sluggable_id" integer DEFAULT NULL NULL, "sequence" integer DEFAULT 1 NOT NULL, "sluggable_type" varchar(40) DEFAULT NULL NULL, "scope" varchar(40) DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL);
CREATE TABLE "taggings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tag_id" integer DEFAULT NULL NULL, "taggable_id" integer DEFAULT NULL NULL, "tagger_id" integer DEFAULT NULL NULL, "tagger_type" varchar(255) DEFAULT NULL NULL, "taggable_type" varchar(255) DEFAULT NULL NULL, "context" varchar(255) DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL);
CREATE TABLE "tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) DEFAULT NULL NULL);
CREATE UNIQUE INDEX "index_acts_as_xapian_jobs_on_model_and_model_id" ON "acts_as_xapian_jobs" ("model", "model_id");
CREATE UNIQUE INDEX "index_slugs_on_name_and_sluggable_type_and_scope_and_sequence" ON "slugs" ("name", "sluggable_type", "scope", "sequence");
CREATE INDEX "index_slugs_on_sluggable_id" ON "slugs" ("sluggable_id");
CREATE INDEX "index_taggings_on_tag_id" ON "taggings" ("tag_id");
CREATE INDEX "index_taggings_on_taggable_id_and_taggable_type_and_context" ON "taggings" ("taggable_id", "taggable_type", "context");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20080811141733');

INSERT INTO schema_migrations (version) VALUES ('20080811141734');

INSERT INTO schema_migrations (version) VALUES ('20080811142159');

INSERT INTO schema_migrations (version) VALUES ('20080819111719');

INSERT INTO schema_migrations (version) VALUES ('20080828160932');

INSERT INTO schema_migrations (version) VALUES ('20080829112649');

INSERT INTO schema_migrations (version) VALUES ('20080829122019');

INSERT INTO schema_migrations (version) VALUES ('20080829131042');

INSERT INTO schema_migrations (version) VALUES ('20080901112131');

INSERT INTO schema_migrations (version) VALUES ('20080902105857');

INSERT INTO schema_migrations (version) VALUES ('20090204105415');