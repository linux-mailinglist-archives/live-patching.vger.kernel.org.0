Return-Path: <live-patching+bounces-1520-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 963B4AD7CB5
	for <lists+live-patching@lfdr.de>; Thu, 12 Jun 2025 22:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 795D21895E3E
	for <lists+live-patching@lfdr.de>; Thu, 12 Jun 2025 20:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC4B2D8790;
	Thu, 12 Jun 2025 20:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPgG72MV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BE12BE7D7;
	Thu, 12 Jun 2025 20:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749761801; cv=none; b=sjC01dqdYyioOFdZR+kkjgqicpQGezFbCdYLoNCFxSsnqbE5TuADFSdUBDNcyDCTUkVDJu5GdbxrozU+yplT6RQDEUn0jGlG18fz+LvA/OqAl1x9SDsmwq4mGDyqwhd5cCZQFIIRXvPsfYOMbbbG5zLgJCTejwjq90YpSvJPsNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749761801; c=relaxed/simple;
	bh=Q7/yCJU0sRWCWTU+gCQd77lWIP8Smikay90QqwpiGKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1VbTGG42qFEBcJeOTIheYp8iOevLkw2ncR0Jc6TGSA+skLWwYULDKuIWuO/gWe0lsUKsdPw9cJy3kasDRQ7+991ywDOa8LGoxymY7RmzAEuswQY3+4NW9X05hPGAuEr2Y4LHBJow8xm0r6A257MAgzJQaXrUgv4qT9dlIPb5JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPgG72MV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6114FC4CEEA;
	Thu, 12 Jun 2025 20:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749761800;
	bh=Q7/yCJU0sRWCWTU+gCQd77lWIP8Smikay90QqwpiGKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cPgG72MVD0J43GOY3mJujBjh7d7uFTm2VTXww4ih8AdKUjB5JwKYbfrcMwVvRmwZE
	 dLjCmQvqlD9XOz29qgBEH1o54cQvqbMj47yk3i3YiIzA2RhHmXZODjZUxrzVnVU9L/
	 dnbffE3meVjq1tIzp2/azmVC2aOAEtoGcfDMW2fIxgoS9JhyEcRBAs50DJ1kpTGT1+
	 bQbcXeVQFqJpcixzRCPgWI8NaGST1yfH8pcg3VnYufeep1+pK7UN8QVirnetFNsTiC
	 pUnOfTdxd84BmL9zrIhh572ndFNAw7H/EGHLFfTBcddUqmARKWbnb7T/IknXfA1Vzk
	 Tj+W6R4pLP3vA==
Date: Thu, 12 Jun 2025 13:56:37 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>, 
	Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, 
	Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, 
	Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 00/62] objtool,livepatch: klp-build livepatch module
 generation
Message-ID: <2mmkbpkj2b3a7qxrkk32vyg7hiwuo3dh2blispfgdb6u7wrysx@xbcthy36wx6q>
References: <cover.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:16:24PM -0700, Josh Poimboeuf wrote:
> I've tested with a variety of patches on defconfig and Fedora-config
> kernels with both GCC and Clang.
> 
> These patches can also be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-v2
> 
> Please test!

I found a nasty bug while trying to patch copy_process().  The wrong
version of __refcount_add.constprop.0() was being called due to a bad
klp rela sympos value, causing refcount overflow/UAF warnings and hangs.

The problem was a mismatch between the sympos order of the vmlinux.o
archive (which klp-diff uses) and the final vmlinux.

The linker script manually emits .text.unlikely before .text instead of
emitting in them in section table order.  So if a function name exists
in both sections, the calculated sympos (based on vmlinux.o) is wrong.

In my test kernel with GCC 14, only 25 out of 136,931 functions (0.018%)
have this problem.  It was my lucky day.

The below hack fixes it by starting the sympos counting with
.text.unlikely*.  It's a bit fragile, but it works fine for now.

I'm thinking the final fix would involve adding a checksum field to
kallsyms.  Then sympos would no longer be needed.  But that will need to
come later.

diff --git a/tools/include/linux/string.h b/tools/include/linux/string.h
index 8499f509f03e..51ad3cf4fa82 100644
--- a/tools/include/linux/string.h
+++ b/tools/include/linux/string.h
@@ -44,6 +44,20 @@ static inline bool strstarts(const char *str, const char *prefix)
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
 
+/*
+ * Checks if a string ends with another.
+ */
+static inline bool str_ends_with(const char *str, const char *substr)
+{
+	size_t len = strlen(str);
+	size_t sublen = strlen(substr);
+
+	if (sublen > len)
+		return false;
+
+	return !strcmp(str + len - sublen, substr);
+}
+
 extern char * __must_check skip_spaces(const char *);
 
 extern char *strim(char *);
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index b5494b5ca78f..47ee010a7852 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -187,20 +187,6 @@ static bool is_sibling_call(struct instruction *insn)
 	return (is_static_jump(insn) && insn_call_dest(insn));
 }
 
-/*
- * Checks if a string ends with another.
- */
-static bool str_ends_with(const char *s, const char *sub)
-{
-	const int slen = strlen(s);
-	const int sublen = strlen(sub);
-
-	if (sublen > slen)
-		return 0;
-
-	return !memcmp(s + slen - sublen, sub, sublen);
-}
-
 /*
  * Checks if a function is a Rust "noreturn" one.
  */
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 5276964ef123..0290cbc90c16 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -439,6 +439,7 @@ static int correlate_symbols(struct elfs *e)
 /* "sympos" is used by livepatch to disambiguate duplicate symbol names */
 static unsigned long find_sympos(struct elf *elf, struct symbol *sym)
 {
+	bool vmlinux = str_ends_with(objname, "vmlinux.o");
 	unsigned long sympos = 0, nr_matches = 0;
 	bool has_dup = false;
 	struct symbol *s;
@@ -446,13 +447,43 @@ static unsigned long find_sympos(struct elf *elf, struct symbol *sym)
 	if (sym->bind != STB_LOCAL)
 		return 0;
 
-	for_each_sym(elf, s) {
-		if (!strcmp(s->name, sym->name)) {
-			nr_matches++;
-			if (s == sym)
-				sympos = nr_matches;
-			else
-				has_dup = true;
+	if (vmlinux && sym->type == STT_FUNC) {
+		/*
+		 * HACK: Unfortunately, symbol ordering can differ between
+		 * vmlinux.o and vmlinux due to the linker script emitting
+		 * .text.unlikely* before .text*.  Count .text.unlikely* first.
+		 *
+		 * TODO: Disambiguate symbols more reliably (checksums?)
+		 */
+		for_each_sym(elf, s) {
+			if (strstarts(s->sec->name, ".text.unlikely") &&
+			    !strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
+		}
+		for_each_sym(elf, s) {
+			if (!strstarts(s->sec->name, ".text.unlikely") &&
+			    !strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
+		}
+	} else {
+		for_each_sym(elf, s) {
+			if (!strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
 		}
 	}
 

