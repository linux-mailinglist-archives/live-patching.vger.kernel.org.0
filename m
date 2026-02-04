Return-Path: <live-patching+bounces-1978-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGT0Ak20gmnwYgMAu9opvQ
	(envelope-from <live-patching+bounces-1978-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:51:57 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B31E0FEC
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 03:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D3F793023340
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 02:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A202BDC05;
	Wed,  4 Feb 2026 02:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UEiZHkun"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9856D237A4F
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 02:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770173514; cv=none; b=MP/36fbSrfGM9QBlHsJLgdALsNNK+7+uJDcA9eG1qYXnW/sLv1atl+Hh8jAhhbiQ5Agenbs8ba3iIZjPk6gVz46vORksaTtqFXOeYMPlFOh485de/vUiQhh2inDLzOSKrgtgoAttDC96g8VhlcP9WrKyE246pWH+JfBZXC3gWGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770173514; c=relaxed/simple;
	bh=Id3Koly51rnDfzYITrxlwkWT+zBejEUgIj4edq3NZbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=HyP+AIRIbqU4iYMJVqyHe69Ia97lGQPmZn8SJmPgWC76QNWvV1MIatk+sbSUuGwJqoOP0THAOK3zAAaZkf5nd5QDOQFJ38b+faiZKj8AVPHFKodBdLS3cSd9xC/s7y7ss6uvRJaX9W0LDH0yaQ8BVUcV77dzfDQARlTjqTHVVBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UEiZHkun; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770173511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKv2c/h6b3uUGcxPDKLj97S6LOLd2b7KCA7Q6YYAhlc=;
	b=UEiZHkunsBkiWnQgRgGW8qU2VfsWJW+ZCIGNjV2T0XWeR3sfttwqceckP9ODIKtZTdhl5f
	hT1r8siLuEhp63lWwdL9mc9+pUv/iAZiU3Ypurx+mVI8KO9HzsLy1QLbTWrKedLFVDAmV0
	Hzyd4lT5nfzBYmjINCaWNMgYkaD7E7k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-YqOE5_DoO8CrUAExLzJhPQ-1; Tue,
 03 Feb 2026 21:51:48 -0500
X-MC-Unique: YqOE5_DoO8CrUAExLzJhPQ-1
X-Mimecast-MFC-AGG-ID: YqOE5_DoO8CrUAExLzJhPQ_1770173507
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FB101954B06;
	Wed,  4 Feb 2026 02:51:47 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.42])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E5AC31800947;
	Wed,  4 Feb 2026 02:51:45 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 1/5] objtool/klp: Fix mkstemp() failure with long paths
Date: Tue,  3 Feb 2026 21:51:36 -0500
Message-ID: <20260204025140.2023382-2-joe.lawrence@redhat.com>
In-Reply-To: <20260204025140.2023382-1-joe.lawrence@redhat.com>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1978-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[raw.githubusercontent.com:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 59B31E0FEC
X-Rspamd-Action: no action

klp-build's elf_create_file() fails with EINVAL when the build directory
path is long enough to truncate the "XXXXXX" suffix in the 256-byte
tmp_name buffer. Increase the buffer to PATH_MAX and add a truncation
check to ensure a valid template string for mkstemp().

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/objtool/elf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Repro notes:

  # Consider a looooong path like:
  $ LONG_DIR=tests/gitlab.com/joe.lawrence/kernel-tests/-/archive/klp-build/kernel-tests-klp-build.tar.gz/general/kpatch/patch-upgrade/kpatch/kernel/BUILD/kernel-6.12.0-178.1964_2250006255.el10/linux-6.12.0-178.1964_2250006255.el10.x86_64

  # Place the source repo within the long path
  $ mkdir -p /tmp/"$LONG_DIR"
  $ cd /tmp/"$LONG_DIR"
  $ git clone --depth=1 --branch=v6.19-rc4 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  $ cd linux

  # Grab a sample patch
  $ wget https://raw.githubusercontent.com/dynup/kpatch/refs/heads/master/examples/cmdline-string.patch

  # Basic config for livepatching ...
  $ make -j$(nproc) defconfig
  $ ./scripts/config --file .config \
      --set-val CONFIG_FTRACE y \
      --set-val CONFIG_KALLSYMS_ALL y \
      --set-val CONFIG_FUNCTION_TRACER y \
      --set-val CONFIG_DYNAMIC_FTRACE y \
      --set-val CONFIG_DYNAMIC_DEBUG y \
      --set-val CONFIG_LIVEPATCH y
  $ make olddefconfig

  # BAD BUILD, mkstemp() unhappy:
  $ ./scripts/livepatch/klp-build -T cmdline-string.patch
  Validating patch(es)
  Building original kernel
  Copying original object files
  Fixing patch(es)
  Building patched kernel
  Copying patched object files
  Diffing objects
  vmlinux.o: changed function: cmdline_proc_show
  vmlinux.o: error: objtool [elf.c:1233]: elf_create_file: can't create tmp file failed: Invalid argument
  error: klp-build: objtool klp diff failed
  error: klp-build: line 657: '( cd "$ORIG_DIR"; "${cmd[@]}" > >(tee -a "$log") 2> >(tee -a "$log" | "${filter[@]}" 1>&2) || die "objtool klp diff failed" )'

  # GOOD BUILD, with PATH_MAX buffer for mkstemp():
  $ ./scripts/livepatch/klp-build -S 3 -T cmdline-string.patch
  Diffing objects
  vmlinux.o: changed function: cmdline_proc_show
  Building patch module: livepatch-cmdline-string.ko
  SUCCESS

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2c02c7b49265..836575876741 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -15,6 +15,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <limits.h>
 #include <errno.h>
 #include <libgen.h>
 #include <ctype.h>
@@ -1192,6 +1193,7 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 	char *dir, *base, *tmp_name;
 	struct symbol *sym;
 	struct elf *elf;
+	int path_len;
 
 	elf_version(EV_CURRENT);
 
@@ -1219,13 +1221,17 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 
 	base = basename(base);
 
-	tmp_name = malloc(256);
+	tmp_name = malloc(PATH_MAX);
 	if (!tmp_name) {
 		ERROR_GLIBC("malloc");
 		return NULL;
 	}
 
-	snprintf(tmp_name, 256, "%s/%s.XXXXXX", dir, base);
+	path_len = snprintf(tmp_name, PATH_MAX, "%s/%s.XXXXXX", dir, base);
+	if (path_len >= PATH_MAX) {
+		ERROR_GLIBC("snprintf");
+		return NULL;
+	}
 
 	elf->fd = mkstemp(tmp_name);
 	if (elf->fd == -1) {
-- 
2.52.0


