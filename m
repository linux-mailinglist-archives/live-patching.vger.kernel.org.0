Return-Path: <live-patching+bounces-548-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 987CC969285
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C78DB21A84
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9331D1F63;
	Tue,  3 Sep 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uum9/FgW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A200D1D1759;
	Tue,  3 Sep 2024 04:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336036; cv=none; b=eXAL6BHsQ5KgLDs0/Aw5OM6OxtfOIytYqiW+JqrqN2gqkfvCxV8K9iWG9QfiU62V5qaqXGytzGO1j60Mf/fLUfcckFN5dMYSzs3ee2VgG+2FiIlmTuelt7/vhz3xdCufqfUEBA8V13/9mmvy457bhVlZpv8QNNicHTeDpRDWZGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336036; c=relaxed/simple;
	bh=S1TH3NgEYk8GKWSjwZk9iXKEQgbZtCkEzrr/z/94KPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDQpLc8LWsoVYZOZxVvte+a3/7hxP2eac8sV/XWsSByCUCTFbBbJpFCwh/1jufzidjRDSmmAd9YyZ9sy7cjokPBx38pwWqP0qrX8KXJyUggMvzCgn8xZ/uf/3SMHWp2/6ir8hplzlbF9X+XJN5ClvP4UnCrh077uDsqdJ4xTmis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uum9/FgW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF1AC4CEC8;
	Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336035;
	bh=S1TH3NgEYk8GKWSjwZk9iXKEQgbZtCkEzrr/z/94KPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uum9/FgWdoJnVN7TiIBuJmzsm4uI2exSJUrF+Sn+6vwuamDLqxWMGNnIe7JgfZHX6
	 kiszVrIzcR9GeEAPotXDZU4HlXfwqqhwPVzFZ3S69YySTnTNWQMsnBC4Dxx453esN3
	 tPRAf+gY0k4cC3arZqf+1JH68GQyUl5ed6DunTdlcvFFGp+yA3gaLrxg+d1TOgLGT7
	 CUBc320fzM7nwq/lyvYHZbcJ6oM72VJ3laxRkCt9Ddhv+HbLqWXbL9NN50Pgf+KDE5
	 OcLgjWKgUCVsSYAlNRkjqDYcIsAvo7T8dszGk8lfpH4mtfFh+4gq1PVriakeFmqk5J
	 U2PHDm8GnUUjg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 12/31] objtool: 'objname' refactoring
Date: Mon,  2 Sep 2024 20:59:55 -0700
Message-ID: <3058a111d265e2cbcc6732e7d1a48ef4b506c8df.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the global 'objname' variable to 'Objname' to avoid local
variable conflicts, and initialize it in elf_open_read() which is a more
natural place for that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/builtin-check.c           |  2 +-
 tools/objtool/check.c                   |  4 ++--
 tools/objtool/elf.c                     |  3 +++
 tools/objtool/include/objtool/objtool.h |  2 +-
 tools/objtool/include/objtool/warn.h    |  8 +++++---
 tools/objtool/objtool.c                 | 17 ++++++++---------
 tools/objtool/orc_dump.c                |  4 ++--
 tools/objtool/weak.c                    |  2 +-
 8 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 5e21cfb7661d..2f16f5ee83ae 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -204,8 +204,8 @@ static bool link_opts_valid(struct objtool_file *file)
 
 int objtool_run(int argc, const char **argv)
 {
-	const char *objname;
 	struct objtool_file *file;
+	const char *objname;
 	int ret;
 
 	argc = cmd_parse_options(argc, argv, check_usage);
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 95f5de0c293d..92171ce458ec 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4621,7 +4621,7 @@ static int disas_funcs(const char *funcs)
 			"}' 1>&2";
 
 	/* fake snprintf() to calculate the size */
-	size = snprintf(NULL, 0, objdump_str, cross_compile, objname, funcs) + 1;
+	size = snprintf(NULL, 0, objdump_str, cross_compile, Objname, funcs) + 1;
 	if (size <= 0) {
 		WARN("objdump string size calculation failed");
 		return -1;
@@ -4630,7 +4630,7 @@ static int disas_funcs(const char *funcs)
 	cmd = malloc(size);
 
 	/* real snprintf() */
-	snprintf(cmd, size, objdump_str, cross_compile, objname, funcs);
+	snprintf(cmd, size, objdump_str, cross_compile, Objname, funcs);
 	ret = system(cmd);
 	if (ret) {
 		WARN("disassembly failed: %d", ret);
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 5301fff87bea..12dbcf425321 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -996,6 +996,9 @@ struct elf *elf_open_read(const char *name, int flags)
 	struct elf *elf;
 	Elf_Cmd cmd;
 
+	if (!Objname)
+		Objname = strdup(name);
+
 	elf_version(EV_CURRENT);
 
 	elf = malloc(sizeof(*elf));
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 94a33ee7b363..ae30497e014b 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -39,7 +39,7 @@ struct objtool_file {
 	struct pv_state *pv_ops;
 };
 
-struct objtool_file *objtool_open_read(const char *_objname);
+struct objtool_file *objtool_open_read(const char *objname);
 
 void objtool_pv_add(struct objtool_file *file, int idx, struct symbol *func);
 
diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index ac04d3fe4dd9..69995f84f91b 100644
--- a/tools/objtool/include/objtool/warn.h
+++ b/tools/objtool/include/objtool/warn.h
@@ -14,7 +14,7 @@
 #include <objtool/builtin.h>
 #include <objtool/elf.h>
 
-extern const char *objname;
+extern char *Objname;
 
 static inline char *offstr(struct section *sec, unsigned long offset)
 {
@@ -41,10 +41,12 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 	return str;
 }
 
-#define WARN(format, ...)				\
+#define WARN(...) WARN_FILENAME(Objname, ##__VA_ARGS__)
+
+#define WARN_FILENAME(filename, format, ...)		\
 	fprintf(stderr,					\
 		"%s: warning: objtool: " format "\n",	\
-		objname, ##__VA_ARGS__)
+		filename, ##__VA_ARGS__)
 
 #define WARN_FUNC(format, sec, offset, ...)		\
 ({							\
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index f40febdd6e36..6d2102450b35 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -18,12 +18,12 @@
 
 bool help;
 
-const char *objname;
+char *Objname;
 static struct objtool_file file;
 
-static bool objtool_create_backup(const char *_objname)
+static bool objtool_create_backup(const char *objname)
 {
-	int len = strlen(_objname);
+	int len = strlen(objname);
 	char *buf, *base, *name = malloc(len+6);
 	int s, d, l, t;
 
@@ -32,7 +32,7 @@ static bool objtool_create_backup(const char *_objname)
 		return false;
 	}
 
-	strcpy(name, _objname);
+	strcpy(name, objname);
 	strcpy(name + len, ".orig");
 
 	d = open(name, O_CREAT|O_WRONLY|O_TRUNC, 0644);
@@ -41,7 +41,7 @@ static bool objtool_create_backup(const char *_objname)
 		return false;
 	}
 
-	s = open(_objname, O_RDONLY);
+	s = open(objname, O_RDONLY);
 	if (s < 0) {
 		perror("failed to open orig file");
 		return false;
@@ -79,16 +79,15 @@ static bool objtool_create_backup(const char *_objname)
 	return true;
 }
 
-struct objtool_file *objtool_open_read(const char *_objname)
+struct objtool_file *objtool_open_read(const char *objname)
 {
-	if (objname) {
-		if (strcmp(objname, _objname)) {
+	if (Objname) {
+		if (strcmp(Objname, objname)) {
 			WARN("won't handle more than one file at a time");
 			return NULL;
 		}
 		return &file;
 	}
-	objname = _objname;
 
 	file.elf = elf_open_read(objname, O_RDWR);
 	if (!file.elf)
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index a62247efb64f..9c0b9d8a34fe 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -10,7 +10,7 @@
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
-int orc_dump(const char *_objname)
+int orc_dump(const char *objname)
 {
 	int fd, nr_entries, i, *orc_ip = NULL, orc_size = 0;
 	struct orc_entry *orc = NULL;
@@ -27,7 +27,7 @@ int orc_dump(const char *_objname)
 	struct elf dummy_elf = {};
 
 
-	objname = _objname;
+	Objname = strdup(objname);
 
 	elf_version(EV_CURRENT);
 
diff --git a/tools/objtool/weak.c b/tools/objtool/weak.c
index d83f607733b0..b568da3c33e6 100644
--- a/tools/objtool/weak.c
+++ b/tools/objtool/weak.c
@@ -15,7 +15,7 @@
 	return ENOSYS;							\
 })
 
-int __weak orc_dump(const char *_objname)
+int __weak orc_dump(const char *objname)
 {
 	UNSUPPORTED("ORC");
 }
-- 
2.45.2


