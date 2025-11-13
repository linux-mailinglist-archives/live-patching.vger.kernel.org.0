Return-Path: <live-patching+bounces-1851-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E0747C56004
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 08:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BFFCA4E18C7
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 07:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A7A31A579;
	Thu, 13 Nov 2025 07:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="OP0qrgym";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="tmv6/JLz"
X-Original-To: live-patching@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF3C287269;
	Thu, 13 Nov 2025 07:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763017738; cv=none; b=FaaazR7vpFK9G8K6yQNSu4Gzt7H579ZHIfmkO4uyhvm2ZlA2NhWekUjhA/hd8+3CJzI4Y/4IjZl0ExNHjYolzJctBofXmBkJTNcbJ/nnUhUQwKl6Cui18NrComk+Ug09LTUNc6tEPRio45G5hp0C+nnd24aF9cUIpb/Byvcozlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763017738; c=relaxed/simple;
	bh=rRwdPug4+I5p7mJ8FHUPk2qWv7xI75rb1mHGYmdk9Gg=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=GnMQW8lJktaPHObzYWsykVz+YRBlxrFcn0c9t0+8dvzNvtmxHjvB7uhlLAno2JjBVT8IoJoT3QQc+i94Cmuk17Jp35WKrTsZGSJnkAjoH+Iq1ITzy374Dn5seWVi4nCYRTdgVWOvGYfHGXu+2LXl8SYUqcgwwx7KmHHcCXlvASA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=OP0qrgym; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=tmv6/JLz; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Thu, 13 Nov 2025 07:08:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1763017734;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UbAJQiPOzVSOGv5o0YHU+QG95QTZyEbVtD31wk6kDpA=;
	b=OP0qrgymxv4HhJNarljpk9dZ/zit8PLvZEXPjjdgDaQcgrj06pUyq65sIZKVDp6eGPYUZk
	X9I3k4ErXKmA3zultwnHL0D16Bs2Z4vtIoFCLK1fCl508ZS0UQILFuheGNhBgKIyYqije8
	HkzR9+HHt0lZoQV5U1FFVHv9Y7EvTaHUyJmPmM3qulIFxyNWh3jt8BOpQFv/2R/hJG14rC
	aqMFqrqwb6VyrZxzX9IIgYd9AO/SMga9x9cKHQ2bSnPo7TzotxHcjl0hYyJI1PF0+mHQiT
	Rxvz0BNfM4ApjtLhyZVoQi5DLfUBmyYdrPVdSggk1SZqHherZyjL6+cRPp+RUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1763017734;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UbAJQiPOzVSOGv5o0YHU+QG95QTZyEbVtD31wk6kDpA=;
	b=tmv6/JLz7ieai/bMKtG6JPmjDoF/Ej+Z9xMIADtwJA9feDOE8cDt8EGAzOnX7AroXsAQWW
	3+CHUl6HHC60qqAg==
From: "tip-bot2 for Josh Poimboeuf" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip: objtool/core] objtool: Warn on functions with ambiguous
 -ffunction-sections section names
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To:
 <65fedea974fe14be487c8867a0b8d0e4a294ce1e.1762991150.git.jpoimboe@kernel.org>
References:
 <65fedea974fe14be487c8867a0b8d0e4a294ce1e.1762991150.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <176301773269.498.5236055241779881022.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The following commit has been merged into the objtool/core branch of tip:

Commit-ID:     9c7dc1dd897a1cdcade9566ea4664b03fbabf4a4
Gitweb:        https://git.kernel.org/tip/9c7dc1dd897a1cdcade9566ea4664b03fba=
bf4a4
Author:        Josh Poimboeuf <jpoimboe@kernel.org>
AuthorDate:    Wed, 12 Nov 2025 15:47:51 -08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Thu, 13 Nov 2025 08:03:10 +01:00

objtool: Warn on functions with ambiguous -ffunction-sections section names

When compiled with -ffunction-sections, a function named startup() will
be placed in .text.startup.  However, .text.startup is also used by the
compiler for functions with __attribute__((constructor)).

That creates an ambiguity for the vmlinux linker script, which needs to
differentiate those two cases.

Similar naming conflicts exist for functions named exit(), split(),
unlikely(), hot() and unknown().

One potential solution would be to use '#ifdef CC_USING_FUNCTION_SECTIONS'
to create two distinct implementations of the TEXT_MAIN macro.  However,
-ffunction-sections can be (and is) enabled or disabled on a per-object
basis (for example via ccflags-y or AUTOFDO_PROFILE).

So the recently unified TEXT_MAIN macro (commit 1ba9f8979426
("vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and related macros")) is
necessary.  This means there's no way for the linker script to
disambiguate things.

Instead, use objtool to warn on any function names whose resulting
section names might create ambiguity when the kernel is compiled (in
whole or in part) with -ffunction-sections.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://patch.msgid.link/65fedea974fe14be487c8867a0b8d0e4a294ce1e.17629=
91150.git.jpoimboe@kernel.org
---
 include/asm-generic/vmlinux.lds.h       | 15 +++++++++++-
 tools/objtool/Documentation/objtool.txt |  7 +++++-
 tools/objtool/check.c                   | 33 ++++++++++++++++++++++++-
 3 files changed, 55 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.=
lds.h
index 8f92d66..5efe1de 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -97,6 +97,21 @@
  * Other .text.* sections that are typically grouped separately, such as
  * .text.unlikely or .text.hot, must be matched explicitly before using
  * TEXT_MAIN.
+ *
+ * NOTE: builds *with* and *without* -ffunction-sections are both supported =
by
+ * this single macro.  Even with -ffunction-sections, there may be some obje=
cts
+ * NOT compiled with the flag due to the use of a specific Makefile override
+ * like cflags-y or AUTOFDO_PROFILE_foo.o.  So this single catchall rule is
+ * needed to support mixed object builds.
+ *
+ * One implication is that functions named startup(), exit(), split(),
+ * unlikely(), hot(), and unknown() are not allowed in the kernel due to the
+ * ambiguity of their section names with -ffunction-sections.  For example,
+ * .text.startup could be __attribute__((constructor)) code in a *non*
+ * ffunction-sections object, which should be placed in .init.text; or it co=
uld
+ * be an actual function named startup() in an ffunction-sections object, wh=
ich
+ * should be placed in .text.  Objtool will detect and complain about any su=
ch
+ * ambiguously named functions.
  */
 #define TEXT_MAIN							\
 	.text								\
diff --git a/tools/objtool/Documentation/objtool.txt b/tools/objtool/Document=
ation/objtool.txt
index 9e97fc2..f88f8d2 100644
--- a/tools/objtool/Documentation/objtool.txt
+++ b/tools/objtool/Documentation/objtool.txt
@@ -456,6 +456,13 @@ the objtool maintainers.
     these special names and does not use module_init() / module_exit()
     macros to create them.
=20
+13. file.o: warning: func() function name creates ambiguity with -ffunctions=
-sections
+
+    Functions named startup(), exit(), split(), unlikely(), hot(), and
+    unknown() are not allowed due to the ambiguity of their section
+    names when compiled with -ffunction-sections.  For more information,
+    see the comment above TEXT_MAIN in include/asm-generic/vmlinux.lds.h.
+
=20
 If the error doesn't seem to make sense, it could be a bug in objtool.
 Feel free to ask objtool maintainers for help.
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 57fac6c..72c7f6f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2663,6 +2663,37 @@ static int decode_sections(struct objtool_file *file)
 	return 0;
 }
=20
+/*
+ * Certain function names are disallowed due to section name ambiguities
+ * introduced by -ffunction-sections.
+ *
+ * See the comment above TEXT_MAIN in include/asm-generic/vmlinux.lds.h.
+ */
+static int validate_function_names(struct objtool_file *file)
+{
+	struct symbol *func;
+	int warnings =3D 0;
+
+	for_each_sym(file->elf, func) {
+		if (!is_func_sym(func))
+			continue;
+
+		if (!strcmp(func->name, "startup")	|| strstarts(func->name, "startup.")	||
+		    !strcmp(func->name, "exit")		|| strstarts(func->name, "exit.")	||
+		    !strcmp(func->name, "split")	|| strstarts(func->name, "split.")	||
+		    !strcmp(func->name, "unlikely")	|| strstarts(func->name, "unlikely.")	=
||
+		    !strcmp(func->name, "hot")		|| strstarts(func->name, "hot.")	||
+		    !strcmp(func->name, "unknown")	|| strstarts(func->name, "unknown.")) {
+
+			WARN("%s() function name creates ambiguity with -ffunction-sections",
+			     func->name);
+			warnings++;
+		}
+	}
+
+	return warnings;
+}
+
 static bool is_special_call(struct instruction *insn)
 {
 	if (insn->type =3D=3D INSN_CALL) {
@@ -4932,6 +4963,8 @@ int check(struct objtool_file *file)
 	if (!nr_insns)
 		goto out;
=20
+	warnings +=3D validate_function_names(file);
+
 	if (opts.retpoline)
 		warnings +=3D validate_retpoline(file);
=20

